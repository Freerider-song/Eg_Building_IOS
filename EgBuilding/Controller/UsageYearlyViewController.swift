//
//  UsageYearlyViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/06.
//

import UIKit
import Charts

class UsageYearlyViewController: CustomUIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtMeter: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
  
    @IBOutlet weak var chartUsageYearly: HorizontalBarChartView!
    
    let datePicker = UIDatePicker()
    
    var year = 0
    
    var allMeter: CaMeter = CaMeter()
    var nMeter: Int = 0
    var alMeter: Array<CaMeter> = Array()
    
    var meterPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DateTime 외관 설정
        txtDate.layer.cornerRadius = 15
        txtDate.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDate.layer.borderColor = CGColor.init(red: 0.51, green: 0.48, blue: 0.48, alpha: 1) //light cyan
        } else {
            // Fallback on earlier versions
        }
        txtMeter.layer.cornerRadius = 15
        txtMeter.layer.borderWidth = 2
        txtMeter.layer.borderColor = CGColor.init(red: 0.51, green: 0.48, blue: 0.48, alpha: 1)
        
        
        btnSearch.layer.cornerRadius = 15
        
        // DatePicker 설정
        showDatePicker()
        
        txtMeter.inputView = meterPickerView
        meterPickerView.delegate = self
        meterPickerView.dataSource = self
        
        meterPickerView.tag = 1
        
        // 오늘 날짜
        let date = Date()
        
        // 오늘 날짜
        let calendar = Calendar.current
        
        txtDate.text = CaApplication.m_Info.dfyyyy.string(from: date)
        
        year = calendar.component(.year, from: date)
       
        
        // ShowWaitDialog가 False인 이유
        // -> View가 Load되자마자 WaitDialog를 호출하면, WaitDialog가 Dismiss되면서 View도 같이 Dismiss하는 문제 발생
        // 따라서, View가 Load될 때는 WaitDialog를 False로 하고, 이후 재호출시에는 True로 한다.
        getUsageYearly(year, false)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alMeter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = alMeter[row]
        return item.strDescr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = alMeter[row]
        nMeter = row
        
        txtMeter.text = item.strDescr
        txtMeter.resignFirstResponder()
    }
    
    
    func viewSetting() {
       
        // Zoom 안 되게
        chartUsageYearly.doubleTapToZoomEnabled = false
        chartUsageYearly.pinchZoomEnabled = false
        chartUsageYearly.drawBarShadowEnabled = false
        
        // Marker 설정
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))

        marker.chartView = chartUsageYearly
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartUsageYearly.marker = marker
        chartUsageYearly.backgroundColor = .white
        
        // x축 값
        let xAxis = chartUsageYearly.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = chartUsageYearly.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartUsageYearly.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = chartUsageYearly.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        //l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        chartUsageYearly.fitBars = true
        
        chartUsageYearly.rightAxis.enabled = false
        
        print("viewSetting accomplished...")
    }
    
    func prepareChartData(_ ja:Array<[String:Any]>){
        
        
        for jo in ja {
            let ca_meter: CaMeter = CaMeter()
            
            ca_meter.nSeqMeter = jo["seq_meter"] as! Int
            
            ca_meter.strMid = jo["mid"] as! String
            ca_meter.strDescr = jo["descr"] as! String
           
            
            let jaUsage: Array<[String:Any]> = jo["list_usage"] as! Array<[String:Any]>
            
            for joUsage in jaUsage {
                let ca_meterUsage: CaMeterUsage = CaMeterUsage()
                ca_meterUsage.nUnit = joUsage["unit"] as! Int
                if(joUsage["kwh"] as? Double == nil) {
                    ca_meterUsage.dKwh = 0.0
                }
                else{
                    ca_meterUsage.dKwh = joUsage["kwh"] as! Double
                }
               
                print(String(ca_meterUsage.nUnit) + " 미터에 따른 kwh " + String(ca_meterUsage.dKwh))
                ca_meter.alMeterUsage.append(ca_meterUsage)
            }
            alMeter.append(ca_meter)
            
        }
        txtMeter.text = alMeter[nMeter].strDescr
        setChart()
    }
    
    func setChart() {
        
        print("Drawing Start...")
        
        // (barWidth + barSpace) * 2 + groupSpace = 1
        let groupSpace = 0.4
        let barSpace = 0.1
        let barWidth = 0.2
        
        var kwhAllEntry: [BarChartDataEntry] = []
        var kwhMeterEntry: [BarChartDataEntry] = []
       
        // currDataEntry와 prevDataEntry에 데이터가 들어간 순서대로 Chart를 Draw함.
        // 근데 Chart를 Draw할 때, 아래에서 위로 Draw함. 왜 이렇게 만들었는지는 모르지만 우리는 위에서부터 0시~23시 순서로
        // Draw해야 하기에 Entry에 데이터를 넣는 순서를 바꿀 필요가 있음.
        // 마찬가지로, DailyChartFormatter가 "(24-i)시" 를 리턴하는 이유임
        
        print("almeterusage는 대체?" + String(allMeter.alMeterUsage.count))
        let nCountUsage: Int = allMeter.alMeterUsage.count
        for i in 0..<nCountUsage {
            
            let usageAll: CaMeterUsage = allMeter.alMeterUsage[nCountUsage-1-i]
            let usageMeter: CaMeterUsage = alMeter[nMeter].alMeterUsage[nCountUsage-1-i]
            
            let allData = BarChartDataEntry(x: Double(usageAll.nUnit), y: round(usageAll.dKwh)*1000/1000)
            let meterData = BarChartDataEntry(x: Double(usageMeter.nUnit), y: round(usageMeter.dKwh)*1000/1000)
            
            kwhAllEntry.append(allData)
            kwhMeterEntry.append(meterData)
            
            let leftAxisFormatter = NumberFormatter()
            
            leftAxisFormatter.positiveSuffix = ""
            leftAxisFormatter.numberStyle = .decimal
            
            chartUsageYearly.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        }
       
        print("kwhAllEntry count.. " + String(kwhAllEntry.count))
    
        // 0시 ~ 24시 -> 25개. -> dataArray.count + 1
        chartUsageYearly.xAxis.setLabelCount(nCountUsage, force: true)
        
        let kwhMeter = BarChartDataSet(entries: kwhMeterEntry, label: alMeter[nMeter].strDescr)
        kwhMeter.setColor(UIColor(named: "EG_Dark_yellow")!)
        let kwhAll = BarChartDataSet(entries: kwhAllEntry, label: "전체 사용량")
        kwhAll.setColor(UIColor(named: "Light_gray")!)
        
        let chartData = BarChartData(dataSets: [kwhMeter, kwhAll])
        
        print("chartData is ... ")
        print(chartData.description)
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        chartData.barWidth = barWidth
        
        // Data Grouping
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
        // X축 간격
        chartUsageYearly.xAxis.granularity = chartUsageYearly.xAxis.axisMaximum / Double(nCountUsage)
        chartUsageYearly.xAxis.granularityEnabled = true
        chartUsageYearly.xAxis.labelCount = nCountUsage
        // X축 Label
        //chartUsageMonthly.xAxis.valueFormatter = formatter
        
        chartUsageYearly.animate(yAxisDuration: 2.5)
        
        chartUsageYearly.xAxis.axisMinimum = 0.0
        chartUsageYearly.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(nCountUsage)
        
        let formatter = YearlyChartFormatter()
        chartUsageYearly.xAxis.valueFormatter = formatter
       
        
        chartUsageYearly.data = chartData
        
        print("setChart Complished...")
        
    }
    
    // 일별 전기 사용량 Data 불러오는 API 호출
    func getUsageYearly(_ year: Int, _ bShowWaitDialog:Bool) {
        CaApplication.m_Engine.GetUsageForAllMeterYear(CaApplication.m_Info.m_nSeqSite, year, bShowWaitDialog, self)
    }
    
    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.CB_GET_USAGE_FOR_ALL_METER_YEAR:
                let jo:[String:Any] = Result.JSONResult
                
                let jaMeter: Array<[String:Any]> = jo["list_meter"] as! Array<[String:Any]>
                let jaAllMeter: Array<[String:Any]> = jo["list_usage_for_all_meter"] as! Array<[String:Any]>
                
                allMeter = CaMeter() //초기화
                for usage in jaAllMeter {
                    let ca_usage: CaMeterUsage = CaMeterUsage()
                    ca_usage.nUnit = usage["unit"] as! Int
                    if(usage["kwh"] as? Double == nil) {
                        ca_usage.dKwh = 0.0
                    }
                    else{
                        ca_usage.dKwh = usage["kwh"] as! Double
                    }
                    print(String(ca_usage.nUnit) + "미터에 따른 전체 kwh " + String(ca_usage.dKwh))
                    allMeter.alMeterUsage.append(ca_usage)
                }
                
                alMeter.removeAll()
                
                if jaMeter.count != 0 {
                    viewSetting()
                    prepareChartData(jaMeter)
                }
                
            default:
                print("Default!")
        }
    }
    
    //DateTextField Click시 DatePicker 띄움
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        //Style = Wheels
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        //Locale
        datePicker.locale = Locale(identifier: "ko")
        //Background color
        datePicker.backgroundColor = UIColor.white
        //Maximun date = Today
        datePicker.maximumDate = Date()
        //Minimum date = 2000/01/01
        let dateMinString: String = "20180101"
        let dateMin: Date = CaApplication.m_Info.dfyyyyMMdd.date(from: dateMinString)!
        datePicker.minimumDate = dateMin
        
       //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker

    }

    // datePicker 선택 완료 시 연, 월, 일 값 저장 후 일별 사용량 데이터 가져옴
    @objc func donedatePicker(){

        txtDate.text = CaApplication.m_Info.dfyyyy.string(from: datePicker.date)
        year = Int(CaApplication.m_Info.dfyyyy.string(from: datePicker.date))!
   
       
        
        self.view.endEditing(true)
        
    
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        getUsageYearly(year, true)
    }
    
}
