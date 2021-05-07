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
    @IBOutlet weak var chartUsageTotal: BarChartView!
    @IBOutlet weak var chartSavingAction: BarChartView!
    @IBOutlet weak var chartUsage: HorizontalBarChartView!
    
    let datePicker = UIDatePicker()
    
    var year = 0
    var month = 0
    var day = 0
    
    var alMeterGross: Array<CaMeter> = Array()
    var alUsageForAllMeter: Array<CaMeterUsage> = Array()
    
    var strDateFrom: String = ""
    var strDateTo: String = ""
    
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let date = Date()
        
        txtDateTo.text = CaApplication.m_Info.dfyyyyMMddStd.string(from: date.dayBefore)
        strDateTo = CaApplication.m_Info.dfyyyyMMdd.string(from: date.dayBefore)
            
        let dtSavePlanCreated: Date = CaApplication.m_Info.dfStd.date(from: CaApplication.m_Info.m_dtSavePlanCreated)!
        txtDateFrom.text =  CaApplication.m_Info.dfyyyyMMddStd.string(from: dtSavePlanCreated)
        strDateFrom = CaApplication.m_Info.dfyyyyMMdd.string(from: dtSavePlanCreated)
    
        CaApplication.m_Engine.GetSaveResult(CaApplication.m_Info.m_nSeqSavePlanActive, strDateFrom, strDateTo, false,self)
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(" 테이블 뷰 갯수 왜 안나옴" + String(alMeterGross.count))
        return alMeterGross.count
        
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
            Cell.roundView.layer.borderColor = CGColor(red: 181, green: 234, blue: 215, alpha: 1) // pastel green
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.71, green: 0.918, blue: 0.843, alpha: 1) // pastel green
        }
        else if meter.dKwhReal < meter.dKwhRef {
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.992, green: 0.992, blue: 0.588, alpha: 1) // pastel yellow
        }
        else if meter.dKwhReal >= meter.dKwhRef {
            Cell.roundView.layer.borderColor = CGColor.init(red: 0.99, green: 1.00, blue: 0.80, alpha: 1) // pastel red
        }
  
        return Cell
    }
    
   
    
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        //self.tableViewHeight?.constant = self.tableView.contentSize.height
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        //self.tableViewHeight?.constant = self.tableView.contentSize.height
    }
 
    /*
    
    func viewSetting() {
        // DateTime 외관 설정
        txtDateTo.layer.cornerRadius = 15
        txtDateTo.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDateTo.layer.borderColor = CGColor.init(red: 64, green: 173, blue: 180, alpha: 1) //cyan_light
        } else {
            // Fallback on earlier versions
        }
        
        txtDateFrom.layer.cornerRadius = 15
        txtDateFrom.layer.borderWidth = 2.0
        if #available(iOS 13.0, *) {
            txtDateFrom.layer.borderColor = CGColor.init(red: 64, green: 173, blue: 180, alpha: 1) //cyan_light
        } else {
            // Fallback on earlier versions
        }
        
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
 */

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
            self.tableViewHeight?.constant = self.tableView.contentSize.height
            tableView.endUpdates()
            
        default:
            print("Saving: ERROR!")
        }
    }
   
    
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
