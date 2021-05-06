//
//  UsageDailyVIewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/30.
//

import UIKit

import Charts



class UsageDailyViewController: CustomUIViewController {
    
    @IBOutlet var txtDateTime: UITextField!
    @IBOutlet var chartUsageDaily: HorizontalBarChartView!
    @IBOutlet var btnShowKwh: UIButton!
    @IBOutlet var btnShowWon: UIButton!
    @IBOutlet var lbKwh: UILabel!
    @IBOutlet var lbKwhPercent: UILabel!
    @IBOutlet var ivKwhPercent: UIImageView!
    @IBOutlet var lbWon: UILabel!
    @IBOutlet var lbWonPercent: UILabel!
    @IBOutlet var ivWonPercent: UIImageView!
    let datePicker = UIDatePicker()
    
    // 정보 가져올 날짜
    var year = 0
    var month = 0
    var day = 0
    
    var bShowKwh = true
    
    // 전체 API 응답 결과
    var data:[String:Any] = [:]
    // 전기 사용량 데이터
    var dataArray:Array<[String:Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
        // DatePicker 설정
        showDatePicker()
        
        // 오늘 날짜
        let date = Date()
        
        // 오늘 날짜
        let calendar = Calendar.current
        
        txtDateTime.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: date)
        
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        
        // ShowWaitDialog가 False인 이유
        // -> View가 Load되자마자 WaitDialog를 호출하면, WaitDialog가 Dismiss되면서 View도 같이 Dismiss하는 문제 발생
        // 따라서, View가 Load될 때는 WaitDialog를 False로 하고, 이후 재호출시에는 True로 한다.
        getUsageDaily(year, month, day, false)
    }
    
    func viewSetting() {
        // DateTime 외관 설정
        txtDateTime.layer.cornerRadius = 15
        txtDateTime.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDateTime.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        
        // Zoom 안 되게
        chartUsageDaily.doubleTapToZoomEnabled = false
        chartUsageDaily.pinchZoomEnabled = false
        chartUsageDaily.drawBarShadowEnabled = false
        
        // Marker 설정
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartUsageDaily
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartUsageDaily.marker = marker
        chartUsageDaily.backgroundColor = .white
        
        // x축 값
        let xAxis = chartUsageDaily.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = chartUsageDaily.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartUsageDaily.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = chartUsageDaily.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        chartUsageDaily.fitBars = true
        
        chartUsageDaily.rightAxis.enabled = false
    }
    
    // API 호출 결과를 통해 차트 Drawing
    func setChart(_ dataArray:Array<[String:Any]>) {
        
        // (barWidth + barSpace) * 2 + groupSpace = 1
        let groupSpace = 0.4
        let barSpace = 0.1
        let barWidth = 0.2
        
        var currDataEntry: [BarChartDataEntry] = []
        var prevDataEntry: [BarChartDataEntry] = []
        
        // x축 label
        let formatter:DailyChartFormatter = DailyChartFormatter()
        
        var reversedArray: Array<[String:Any]> = []
        
        // currDataEntry와 prevDataEntry에 데이터가 들어간 순서대로 Chart를 Draw함.
        // 근데 Chart를 Draw할 때, 아래에서 위로 Draw함. 왜 이렇게 만들었는지는 모르지만 우리는 위에서부터 0시~23시 순서로
        // Draw해야 하기에 Entry에 데이터를 넣는 순서를 바꿀 필요가 있음.
        // 마찬가지로, DailyChartFormatter가 "(24-i)시" 를 리턴하는 이유임
        for i in 0..<dataArray.count {
            reversedArray.append(dataArray[dataArray.count - (i+1)])
        }
        
        print(reversedArray.description)
        
        // 사용량 보여줄 때
        if bShowKwh {
            for data in reversedArray {
                // x에 23-unit해놨는데 그냥 unit도 상관없는 듯
                let currData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["kwh_curr"]! as! Double)*1000)/1000)
                let prevData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["kwh_prev"]! as! Double)*1000)/1000)
                
                currDataEntry.append(currData)
                prevDataEntry.append(prevData)
                
                // 단위 붙이기
                let leftAxisFormatter = NumberFormatter()
                
                leftAxisFormatter.positiveSuffix = " Kwh"
                leftAxisFormatter.numberStyle = .decimal
                
                chartUsageDaily.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
            }
        } else {
            // 금액 보여줄 때
            for data in reversedArray {
                let currData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["won_curr"]! as! Double)*1000)/1000)
                let prevData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["won_prev"]! as! Double)*1000)/1000)
                
                currDataEntry.append(currData)
                prevDataEntry.append(prevData)
                
                let leftAxisFormatter = NumberFormatter()
                
                leftAxisFormatter.positiveSuffix = " 원"
                leftAxisFormatter.numberStyle = .decimal
                
                chartUsageDaily.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
            }
        }
        
        // 0시 ~ 24시 -> 25개. -> dataArray.count + 1
        chartUsageDaily.xAxis.setLabelCount(dataArray.count+1, force: true)
        
        let curr = BarChartDataSet(entries: currDataEntry, label: "조회일")
        curr.setColor(UIColor(named: "EG_Chart_curr")!)
        let prev = BarChartDataSet(entries: prevDataEntry, label: "전년동일")
        prev.setColor(UIColor(named: "EG_Chart_prev")!)
        
        let chartData = BarChartData(dataSets: [curr, prev])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        chartData.barWidth = barWidth
        
        // Data Grouping
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
        // X축 간격
        chartUsageDaily.xAxis.granularity = chartUsageDaily.xAxis.axisMaximum / Double(dataArray.count+1)
        chartUsageDaily.xAxis.granularityEnabled = true
        chartUsageDaily.xAxis.labelCount = dataArray.count+1
        // X축 Label
        chartUsageDaily.xAxis.valueFormatter = formatter
        
        chartUsageDaily.animate(yAxisDuration: 2.5)
        
        chartUsageDaily.xAxis.axisMinimum = 0.0
        chartUsageDaily.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(dataArray.count)
        
        chartUsageDaily.data = chartData
        
    }
    
    func setUsageView() {
        let kwhCurr = data["total_kwh_curr"]! as! Double
        let kwhPrev = data["total_kwh_prev"]! as! Double
        let wonCurr = data["total_won_curr"]! as! Double
        let wonPrev = data["total_won_prev"]! as! Double
        
        lbKwh.text = String(format: "%.1f", kwhCurr) + " kWh"
        lbWon.text = CaApplication.m_Info.decimal(value: wonCurr) + " 원"
        
        let kwhPercent:Double = 100*(kwhCurr-kwhPrev)/kwhPrev
        let wonPercent:Double = 100*(wonCurr-wonPrev)/wonPrev
        
        if kwhPercent < 0 {
            lbKwhPercent.text = String(format: "%.1f", abs(kwhPercent)) + " %"
            lbKwhPercent.textColor = .blue
            
            ivKwhPercent.image = UIImage(named: "arrow_down.png")
        } else {
            lbKwhPercent.text = String(format: "%.1f", kwhPercent) + " %"
            lbKwhPercent.textColor = .red
            
            ivKwhPercent.image = UIImage(named: "arrow_up.png")
        }
        
        if wonPercent < 0 {
            lbWonPercent.text = String(format: "%.1f", abs(wonPercent)) + " %"
            lbWonPercent.textColor = .blue
            
            ivWonPercent.image = UIImage(named: "arrow_down.png")
        } else {
            lbWonPercent.text = String(format: "%.1f", wonPercent) + " %"
            lbWonPercent.textColor = .red
            
            ivWonPercent.image = UIImage(named: "arrow_up.png")
        }
    }
    
    // 일별 전기 사용량 Data 불러오는 API 호출
    func getUsageDaily(_ year: Int, _ month: Int, _ day: Int, _ bShowWaitDialog:Bool) {
        CaApplication.m_Engine.GetUsageOfOneDay(CaApplication.m_Info.nSeqSite, CaApplication.m_Info.nSeqMeter, year, month, day, bShowWaitDialog, self)
    }
    
    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.EG_GET_USAGE_OF_ONE_DAY:
                let jo:[String:Any] = Result.JSONResult
                
                dataArray = jo["list_usage"] as! Array<[String:Any]>
                
                data = jo
                setUsageView()
                
                setChart(dataArray)
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
        let dateMinString: String = "20000101"
        let dateMin: Date = CaApplication.m_Info.dfyyyyMMdd.date(from: dateMinString)!
        datePicker.minimumDate = dateMin
        
       //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDateTime.inputAccessoryView = toolbar
        txtDateTime.inputView = datePicker

    }

    // datePicker 선택 완료 시 연, 월, 일 값 저장 후 일별 사용량 데이터 가져옴
    @objc func donedatePicker(){

        txtDateTime.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: datePicker.date)
        year = Int(CaApplication.m_Info.dfyyyy.string(from: datePicker.date))!
        month = Int(CaApplication.m_Info.dfMM.string(from: datePicker.date))!
        day = Int(CaApplication.m_Info.dfdd.string(from: datePicker.date))!
        
        self.view.endEditing(true)
        
        // 여기서는 ShowWaitDialog가 True임을 기억하기
        getUsageDaily(year, month, day, true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShowKwhBtnClicked(_ sender: UIButton) {
        if !bShowKwh {
            bShowKwh = true
            
            btnShowKwh.setTitleColor(.black, for: .normal)
            btnShowWon.setTitleColor(.gray, for: .normal)
            
            setChart(dataArray)
        }
    }
    
    @IBAction func onShowWonBtnClicked(_ sender: UIButton) {
        if bShowKwh {
            bShowKwh = false
            
            btnShowKwh.setTitleColor(.gray, for: .normal)
            btnShowWon.setTitleColor(.black, for: .normal)
            
            setChart(dataArray)
        }
    }
    @IBAction func onAlarmBtnClicked(_ sender: UIButton) {
        print("alarm button clicked...")
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}
