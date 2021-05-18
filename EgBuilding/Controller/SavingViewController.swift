//
//  SavingViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/28.
//
// tableview Height 관련 https://stackoverflow.com/questions/2595118/resizing-uitableview-to-fit-content
import UIKit

import Charts

class SavingResultCell : UITableViewCell {
    @IBOutlet weak var lbInstrument: UILabel!
    @IBOutlet weak var lbUsage: UILabel!
    @IBOutlet weak var lbUsageRef: UILabel!
    @IBOutlet weak var lbUsagePlan: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    
    
}

extension Date {

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}

class SavingViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtDateFrom: UITextField!
    @IBOutlet weak var txtDateTo: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var chartUsageTotal: BarChartView!
    @IBOutlet weak var chartSavingAction: BarChartView!
    @IBOutlet weak var chartUsage: HorizontalBarChartView!
    
    let datePicker = UIDatePicker()
    let datePickerFrom = UIDatePicker()
    
    var year = 0
    var month = 0
    var day = 0
    
    var alMeterGross: Array<CaMeter> = Array()
    var alUsageForAllMeter: Array<CaMeterUsage> = Array()
    
    var strDateFrom: String = ""
    var strDateTo: String = ""
    
    let dtSavePlanCreated: Date = CaApplication.m_Info.dfStd.date(from: CaApplication.m_Info.m_dtSavePlanCreated)!
    
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDatePicker()

        tableView.delegate = self
        tableView.dataSource = self
        
        btnSearch.layer.cornerRadius = 15
        // DateTime 외관 설정
        txtDateTo.layer.cornerRadius = 15
        txtDateTo.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDateTo.layer.borderColor = CGColor.init(red: 0.51, green: 0.48, blue: 0.48, alpha: 1) //light cyan
        } else {
            // Fallback on earlier versions
        }
        
        txtDateFrom.layer.cornerRadius = 15
        txtDateFrom.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDateFrom.layer.borderColor = CGColor.init(red: 0.51, green: 0.48, blue: 0.48, alpha: 1) //light cyan
        } else {
            // Fallback on earlier versions
        }
        
        let date = Date()
        
        txtDateTo.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: date.dayBefore)
        strDateTo = CaApplication.m_Info.dfyyyyMMdd.string(from: date.dayBefore)
            
        
        txtDateFrom.text =  CaApplication.m_Info.dfyyyyMMddStd.string(from: dtSavePlanCreated)
        strDateFrom = CaApplication.m_Info.dfyyyyMMdd.string(from: dtSavePlanCreated)
    
        //CaApplication.m_Engine.GetSaveResult(CaApplication.m_Info.m_nSeqSavePlanActive, strDateFrom, strDateTo, false,self)
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CaApplication.m_Engine.GetSaveResult(CaApplication.m_Info.m_nSeqSavePlanActive, strDateFrom, strDateTo, true, self)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(" 테이블 뷰 갯수 왜 안나옴" + String(alMeterGross.count))
        return alMeterGross.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SavingResultCell", for: indexPath) as! SavingResultCell
        
        let meter = alMeterGross[indexPath.row]
        
        Cell.roundView.layer.cornerRadius = 15
        Cell.roundView.layer.borderWidth = 2
        
        Cell.lbInstrument.text = meter.strDescr
        Cell.lbUsage.text = String(format: "%.1f", meter.dKwhReal) + " kWh"
        Cell.lbUsageRef.text = "절감 기준  " + String(format: "%.1f", meter.dKwhRef)
        Cell.lbUsagePlan.text = "절감 목표  " + String(format: "%.1f", meter.dKwhPlan)
        
        if meter.dKwhReal < meter.dKwhPlan {
            //Cell.roundView.layer.borderColor = CGColor(red: 181, green: 234, blue: 215, alpha: 1) // pastel green
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.71, green: 0.918, blue: 0.843, alpha: 1) // pastel green
            Cell.roundView.backgroundColor = UIColor(named: "Pastel_green")
        }
        else if meter.dKwhReal < meter.dKwhRef {
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.992, green: 0.992, blue: 0.588, alpha: 1) // pastel yellow
            Cell.roundView.backgroundColor = UIColor(named: "Pastel_yellow")
        }
        else if meter.dKwhReal >= meter.dKwhRef {
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.99, green: 1.00, blue: 0.80, alpha: 1) // pastel red
            Cell.roundView.backgroundColor = UIColor(named: "Pastel_red")
        }
  
        return Cell
    }
    
   
    
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeight?.constant = self.tableView.contentSize.height
    }
    

 
 
    
    
    func viewSetting() {
        
        
        // Zoom 안 되게
        chartUsage.doubleTapToZoomEnabled = false
        chartUsage.pinchZoomEnabled = false
        chartUsage.drawBarShadowEnabled = false
        
        chartUsageTotal.doubleTapToZoomEnabled = false
        chartUsageTotal.pinchZoomEnabled = false
        chartUsageTotal.drawBarShadowEnabled = false
        
        chartSavingAction.doubleTapToZoomEnabled = false
        chartSavingAction.pinchZoomEnabled = false
        chartSavingAction.drawBarShadowEnabled = false
        
        // Marker 설정
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartUsage
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartUsage.marker = marker
        chartUsage.backgroundColor = .white
        chartSavingAction.marker = marker
        chartSavingAction.backgroundColor = .white
        chartUsageTotal.marker = marker
        chartUsageTotal.backgroundColor = .white
        
        // x축 값
        let TotalXAxis = chartUsageTotal.xAxis
        TotalXAxis.labelPosition = .bottom
        TotalXAxis.labelFont = .systemFont(ofSize: 10)
        TotalXAxis.drawAxisLineEnabled = true
        TotalXAxis.drawGridLinesEnabled = false
        
        // y축 값
        let TotalLeftAxis = chartUsageTotal.leftAxis
        TotalLeftAxis.labelFont = .systemFont(ofSize: 10)
        TotalLeftAxis.drawAxisLineEnabled = true
        TotalLeftAxis.drawGridLinesEnabled = false
        TotalLeftAxis.axisMinimum = 0

        let TotalrightAxis = chartUsageTotal.rightAxis
        TotalrightAxis.enabled = false
        
        let llRef = ChartLimitLine(limit: round(CaApplication.m_Info.m_dKwhRefForAllMeter) , label: "기준")
        let llRefHo = ChartLimitLine(limit: round(CaApplication.m_Info.m_dKwhRefForAllMeter) , label: "")
        llRef.lineWidth = 1
        llRef.lineColor = .red
        llRefHo.lineWidth = 1
        llRefHo.lineColor = .red
        //llRef.lineDashLengths = [8.0]
        llRef.labelPosition = .topRight
        chartUsageTotal.leftAxis.addLimitLine(llRef)
        chartUsage.leftAxis.addLimitLine(llRefHo)

        let llGoal = ChartLimitLine(limit: round(CaApplication.m_Info.m_dKwhPlanForAllMeter), label: "목표")
        let llGoalHo = ChartLimitLine(limit: round(CaApplication.m_Info.m_dKwhPlanForAllMeter), label: "")
        llGoal.lineWidth = 1
        llGoal.lineColor = .blue
        llGoalHo.lineWidth = 1
        llGoalHo.lineColor = .blue
        //llGoal.lineDashLengths = [8.0]
        llGoal.labelPosition = .topRight
        chartUsageTotal.leftAxis.addLimitLine(llGoal)
        chartUsage.leftAxis.addLimitLine(llGoalHo)
       
    
        // x축 값
        let actionXAxis = chartSavingAction.xAxis
        actionXAxis.labelPosition = .bottom
        actionXAxis.labelFont = .systemFont(ofSize: 10)
        actionXAxis.drawAxisLineEnabled = true
        actionXAxis.drawGridLinesEnabled = false
        
        // y축 값
        let actionLeftAxis = chartSavingAction.leftAxis
        actionLeftAxis.labelFont = .systemFont(ofSize: 10)
        actionLeftAxis.drawAxisLineEnabled = true
        actionLeftAxis.drawGridLinesEnabled = false
        actionLeftAxis.axisMinimum = 0

        let actionRightAxis = chartSavingAction.rightAxis
        actionRightAxis.enabled = false
        
        // x축 값
        let xAxis = chartUsage.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = chartUsage.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartUsage.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = chartUsage.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        let Tl = chartUsageTotal.legend
        Tl.horizontalAlignment = .left
        Tl.verticalAlignment = .bottom
        Tl.orientation = .horizontal
        Tl.drawInside = false
        Tl.form = .square
        Tl.formSize = 8
        Tl.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        Tl.xEntrySpace = 4
        
        let Sl = chartSavingAction.legend
        Sl.horizontalAlignment = .left
        Sl.verticalAlignment = .bottom
        Sl.orientation = .horizontal
        Sl.drawInside = false
        Sl.form = .square
        Sl.formSize = 8
        Sl.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        Sl.xEntrySpace = 4
        
        chartUsage.fitBars = true
        chartSavingAction.fitBars = true
        chartUsageTotal.fitBars = true
        
        chartUsage.rightAxis.enabled = false
        chartSavingAction.rightAxis.enabled = false
        chartUsageTotal.rightAxis.enabled = false
        
        chartSavingAction.xAxis.enabled = false
        chartUsageTotal.xAxis.enabled = false
        
        chartUsage.legend.enabled = false
        
        print("viewSetting accomplished...")
    }
    
    func setBarChart() {
        
        var colors: [NSUIColor] = []
        
        var SavingActEntry: [BarChartDataEntry] = []
        
        //절감행동 실천 그래프
        
        let actTotalCountData = BarChartDataEntry(x: 0, y: Double(CaApplication.m_Info.m_nTotalSaveActCount - CaApplication.m_Info.m_nTotalSaveActWithHistoryCount))
        let actHistoryCountData = BarChartDataEntry(x: 0, y:Double(CaApplication.m_Info.m_nTotalSaveActWithHistoryCount))
        colors.append(UIColor(named: "Light_gray")!)
        colors.append(UIColor(named: "Light_blue")!)
        
        SavingActEntry.append(actTotalCountData)
        SavingActEntry.append(actHistoryCountData)
        
        let actLeftAxisFormatter = NumberFormatter()
        
        actLeftAxisFormatter.positiveSuffix = " 회"
        actLeftAxisFormatter.numberStyle = .decimal
        
        chartSavingAction.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: actLeftAxisFormatter)
        
        let SavingAct = BarChartDataSet(entries: SavingActEntry, label: "실천 횟수")
        SavingAct.setColors(colors, alpha: 1.0)
        
        let savingActChartData = BarChartData(dataSet: SavingAct)
        chartSavingAction.animate(yAxisDuration: 2.5)
        chartSavingAction.data = savingActChartData
        
        //UsageTotal Bar Chart
        
        var usageTotalEntry: [BarChartDataEntry] = []
        
        let totalUsageData = BarChartDataEntry(x: 0, y: round(CaApplication.m_Info.m_dAvgKwhForAllMeter*1000)/1000)
       
        
        usageTotalEntry.append(totalUsageData)
      
        
        let usageLeftAxisFormatter = NumberFormatter()
        
        usageLeftAxisFormatter.positiveSuffix = " kWh"
        usageLeftAxisFormatter.numberStyle = .decimal
        
        chartUsageTotal.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: usageLeftAxisFormatter)
        
        let usageTotal = BarChartDataSet(entries: usageTotalEntry, label: "평균 사용량")
        var maxYValue: Double = 0.0
        
        if(CaApplication.m_Info.m_dAvgKwhForAllMeter<CaApplication.m_Info.m_dKwhPlanForAllMeter) {
            usageTotal.setColor(UIColor(named:"Pastel_green")!)
            maxYValue = CaApplication.m_Info.m_dKwhRefForAllMeter + 50
        }
        else if CaApplication.m_Info.m_dAvgKwhForAllMeter < CaApplication.m_Info.m_dKwhRefForAllMeter {
            usageTotal.setColor(UIColor(named:"EG_Chart_prev")!)
            maxYValue = CaApplication.m_Info.m_dKwhRefForAllMeter + 50
        }
        else {
            usageTotal.setColor(UIColor(named:"Pastel_red")!)
            maxYValue = CaApplication.m_Info.m_dAvgKwhForAllMeter + 50
        }
        
        let usageTotalChartData = BarChartData(dataSet: usageTotal)
        
        chartUsageTotal.leftAxis.axisMaximum = maxYValue
        chartUsageTotal.animate(yAxisDuration: 2.5)
        chartUsageTotal.data = usageTotalChartData
    }
    
    // API 호출 결과를 통해 차트 Drawing
    func setHorizontalChart() {
        
        // (barWidth + barSpace) * 2 + groupSpace = 1
        let groupSpace = 0.4
        let barSpace = 0.1
        let barWidth = 0.2
        
        var currDataEntry: [BarChartDataEntry] = []
        
        
        // x축 label
        
        
        var colors: [NSUIColor] = []
        let nCountUsage: Int = alUsageForAllMeter.count
      
        
        // x값을 date형식으로 변환한 후 timeinterval 형식으로 변환
        var objects : Array<TimeInterval> = []
        for i in 0..<nCountUsage{
            let usage = alUsageForAllMeter[nCountUsage-1-i]
            
            var strMonth = String(usage.nMonth)
            var strDay = String(usage.nDay)
            if (usage.nMonth <= 9) {
                strMonth = "0" + strMonth
            }
            if usage.nDay <= 9 {
                strDay = "0" + strDay
            }
            let strX = "\(usage.nYear)-\(strMonth)-\(strDay) 00:00:00"
            let dtX = CaApplication.m_Info.dfStd.date(from: strX)
            let epoch = dtX!.timeIntervalSince1970
            objects.append(epoch)
        }

        // Define the reference time interval
       var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = objects.min() {
                referenceTimeInterval = minTimeInterval
            }



        // 사용량 보여줄 때
        
        for i in 0..<nCountUsage {
            // x에 23-unit해놨는데 그냥 unit도 상관없는 듯
            let usage = alUsageForAllMeter[nCountUsage-1-i]
            
            let xValue = (objects[i] - referenceTimeInterval) / (3600 * 24)

            let currData = BarChartDataEntry(x: xValue, y: round((usage.dKwh)*1000)/1000)
       
            if(usage.dKwh<CaApplication.m_Info.m_dKwhPlanForAllMeter) {
                colors.append(UIColor(named: "Pastel_green")!)
            }
            else if usage.dKwh<CaApplication.m_Info.m_dKwhRefForAllMeter {
                colors.append(UIColor(named: "EG_Dark_yellow")!)
            }
            else if usage.dKwh >= CaApplication.m_Info.m_dKwhRefForAllMeter{
                colors.append(UIColor.red)
            }
            
 
            
            currDataEntry.append(currData)
          
            
            // 단위 붙이기
            let leftAxisFormatter = NumberFormatter()
            
            leftAxisFormatter.positiveSuffix = " kWh"
            leftAxisFormatter.numberStyle = .decimal
            
            chartUsage.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
            
            // x값을 timeInterval에서 날짜형식으로 전환하는 formatter
            let formatter = DateFormatter()
            //formatter.dateStyle = .short
            //formatter.timeStyle = .none
            formatter.locale = Locale.current
            formatter.setLocalizedDateFormatFromTemplate("MMdd")

            let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
            
            chartUsage.xAxis.valueFormatter = xValuesNumberFormatter
        }
        
        
    
        
        // 0시 ~ 24시 -> 25개. -> dataArray.count + 1
        chartUsage.xAxis.setLabelCount(nCountUsage, force: true)
        
        let curr = BarChartDataSet(entries: currDataEntry, label: "일 사용량")
        //curr.setColor(UIColor(named: "EG_Chart_curr")!)
        curr.setColors(colors, alpha: 1.0)
        
        
        let chartData = BarChartData(dataSets: [curr])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        chartData.barWidth = barWidth
        
        // Data Grouping
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
        // X축 간격
        //chartUsage.xAxis.granularity = chartUsage.xAxis.axisMaximum / Double(nCountUsage)
        
        chartUsage.xAxis.granularityEnabled = true
    
        chartUsage.xAxis.labelCount = nCountUsage

        
        
        chartUsage.animate(yAxisDuration: 2.5)
        
        //chartUsage.xAxis.axisMinimum = 0.0
        //chartUsage.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(nCountUsage)
        
        chartUsage.data = chartData
        
    }

    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case m_GlobalEngine.CB_GET_SAVE_RESULT:
            let jo:[String: Any] = Result.JSONResult
            CaApplication.m_Info.m_nTotalSaveActCount = jo["total_save_act_count"] as! Int
            CaApplication.m_Info.m_nTotalSaveActWithHistoryCount = jo["total_save_act_with_history_count"] as! Int
            CaApplication.m_Info.m_dAvgKwhForAllMeter = jo["avg_kwh_for_all_meter"] as! Double
            let jaMeter: Array<[String:Any]> = jo["list_meter"] as! Array<[String:Any]>
            let jaUsageForAllMeter = jo["list_usage_for_all_meter"] as! Array<[String: Any]>
            let jaMeterGross = jo["list_meter_gross"] as! Array<[String:Any]>
            CaApplication.m_Info.setMeterList(jaMeter)
            
            //chart data
            alUsageForAllMeter.removeAll()
            
            for jo in jaUsageForAllMeter {
                
                let ca_meterUsage: CaMeterUsage = CaMeterUsage()
                
                ca_meterUsage.nYear =  jo["year"] as! Int
                ca_meterUsage.nDay =  jo["day"] as! Int
                ca_meterUsage.nMonth =  jo["month"] as! Int
                ca_meterUsage.bHoliday =  jo["is_holiday"] as! Bool
                ca_meterUsage.dKwh = jo["kwh"]! as! Double
                
                alUsageForAllMeter.append(ca_meterUsage)
            }
            print("alUsageForAllMeter Called... Length is " + String(alUsageForAllMeter.count) )
            
            viewSetting()
            setHorizontalChart()
            setBarChart()
            //list data
            alMeterGross.removeAll()
            
            for jo in jaMeterGross {
                
                let ca_meterGross: CaMeter = CaMeter()
                
                ca_meterGross.nSeqMeter =  jo["seq_meter"] as! Int
                ca_meterGross.strDescr =  jo["descr"] as! String
                ca_meterGross.dKwhRef =  jo["kwh_ref"] as! Double
                ca_meterGross.dKwhPlan =  jo["kwh_plan"] as! Double
                ca_meterGross.dKwhReal = jo["kwh_real"]! as! Double
                
                alMeterGross.append(ca_meterGross)
            }
            
            print("alMeterGross Called... Length is " + String(alMeterGross.count))
               
              
            print("GetSaveResult Succeed...")
            
            tableView.reloadData()
            
            tableView.beginUpdates()
            
            //self.tableViewHeight?.constant = self.tableView.contentSize.height
            
            tableView.endUpdates() //이거 지우면 테이블뷰가 안뜨는 현상 발ㅆ
            
        default:
            print("Saving: ERROR!")
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
        
        //Formate Date
        datePickerFrom.datePickerMode = .date
        //Style = Wheels
        if #available(iOS 13.4, *) {
            datePickerFrom.preferredDatePickerStyle = .wheels
        }
        //Locale
        datePickerFrom.locale = Locale(identifier: "ko")
        //Background color
        datePickerFrom.backgroundColor = UIColor.white
        //Maximun date = Today
        datePickerFrom.maximumDate = Date()
        //Minimum date = 2000/01/01
        
        datePickerFrom.minimumDate = dateMin
        
       //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDateTo.inputAccessoryView = toolbar
        txtDateTo.inputView = datePicker
        
        txtDateFrom.inputAccessoryView = toolbar
        txtDateFrom.inputView = datePickerFrom

    }

    // datePicker 선택 완료 시 연, 월, 일 값 저장 후 일별 사용량 데이터 가져옴
    @objc func donedatePicker(){

        txtDateTo.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: datePicker.date)
        txtDateFrom.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: datePickerFrom.date)
        //첫번쨰로 txtDateTo의 값을 바꿨을때 txtDateFrom의 날짜가 오늘날짜로 같이 바뀌는 문제가 발생중
        strDateTo = CaApplication.m_Info.dfyyyyMMdd.string(from: datePicker.date)
        strDateFrom = CaApplication.m_Info.dfyyyyMMdd.string(from: datePickerFrom.date)
        
        self.view.endEditing(true)
        
        // 여기서는 ShowWaitDialog가 True임을 기억하기
        //getUsageDaily(year, month, day, true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
   
    
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        let date1 = Int(strDateFrom)!
        let date2 = Int(strDateTo)!
        
        
        let nSavePlanCreated = Int( CaApplication.m_Info.dfyyyyMMdd.string(from: dtSavePlanCreated))
        
        if date1 >= date2 {
            alert(title: "오류", message: "날짜 입력이 잘못되었습니다.", text: "확인")
        }
        
        else if date1 < nSavePlanCreated! {
            alert(title: "오류", message: "절감계획 이전의 데이터는 불러올 수 없습니다.", text: "확인")
        }
        else{
            CaApplication.m_Engine.GetSaveResult(CaApplication.m_Info.m_nSeqSavePlanActive, strDateFrom, strDateTo, false, self)
        }
        
        
    }
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
