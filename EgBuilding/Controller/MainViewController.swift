//
//  ViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
//

import UIKit
import ABGaugeViewKit

class SavingCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
   
    @IBOutlet var lblUsageToday: UILabel!
    @IBOutlet var lblUsageGoal: UILabel!
    @IBOutlet var lblUsageRef: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet var tvCheckList: UITableView!
    @IBOutlet var lblSavingResult: UILabel!
    
    @IBOutlet var CheckListHeight: NSLayoutConstraint!
    
    var lvAct : Array<CaAct> = Array()
    var plan : CaPlan = CaPlan()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvCheckList.delegate = self
        tvCheckList.dataSource = self
        
    }
    
    override func layoutSubviews() {
        
        self.CheckListHeight?.constant = self.tvCheckList.contentSize.height
        print("checklistheight 조정")
        super.layoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lvAct.count
        
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SavingCheckCell", for: indexPath) as! SavingCheckCell
        
        let act = lvAct[indexPath.row]
        Cell.btnCheckBox.setTitle(act.strActContent, for: .normal)
        
        var flag: Bool = false
        
        let date = Date()
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        
        for i in 0..<act.alActHistory.count {
            let actHistory = act.alActHistory[i]
            let dtBegin = CaApplication.m_Info.dfStd.date(from: actHistory.dtBegin)!
            if(today == CaApplication.m_Info.dfyyyyMMdd.string(from: dtBegin)){
                Cell.btnCheckBox.isSelected = true
                print("HOME: 절감조치: " + act.strActContent + "의 체크박스가 체크 되었슴")
                flag = true
                break
            }
        }
        
        if flag == true {
            Cell.btnCheckBox.isSelected = false
            act.bChecked = false
        }
        print("actbchecked 여기서 체크됨")
        
        let strNow: String = CaApplication.m_Info.dfHH.string(from: date)
        let nNow: Int = Int(strNow)!
        
        if plan.nHourFrom > nNow {
            
         
            Cell.backgroundColor = UIColor.white
        }
        else {
            if plan.dKwhReal <= plan.dKwhPlan{
                    Cell.backgroundColor = UIColor(named: "Pastel_green")
            }
            else if plan.dKwhReal <= plan.dKwhRef{
                
                    Cell.backgroundColor = UIColor(named: "Pastel_yellow")
            }
            else {
               
                    Cell.backgroundColor = UIColor(named: "Pastel_red")
            }
        }
        
        print("tvChecklist 로딩 완료") //색 입힌 후 tvchecklist 가 로딩된다.
        
        return Cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class SavingCheckCell: UITableViewCell{
    @IBOutlet var btnCheckBox: UIButton!
    
}

class MainViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
 
    @IBOutlet weak var tvSavingList: UITableView!
    @IBOutlet var gaugeView: ABGaugeView!
    
    @IBOutlet weak var lblKwhPlan: UILabel!
    @IBOutlet weak var lblKwhRef: UILabel!
    @IBOutlet weak var lblKwhReal: UILabel!
    @IBOutlet weak var lblActCount: UILabel!
    
    @IBOutlet var SavingListHeight: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvSavingList.delegate = self
        tvSavingList.dataSource = self
        
        // tableView의 rowHeight는 유동적일 수 있다
        tvSavingList.rowHeight = UITableView.automaticDimension
        // tableView의 계산된 높이 값은 68이다. 즉 Default Height이다.
        tvSavingList.estimatedRowHeight = 290.0
             
        print("tvSavingList rowheight 조정")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let date = Date()
        let getTime = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        CaApplication.m_Engine.GetSaveResultDaily(CaApplication.m_Info.m_nSeqSavePlanActive, getTime, false, self)
    }
    
    func initChart(){
        
        
        let kwhPlan = Double(String(format: "%.1f", CaApplication.m_Info.m_dKwhPlanForAllMeter))!
        let kwhRef = Double(String(format: "%.1f", CaApplication.m_Info.m_dKwhRefForAllMeter))!
        let kwhReal = Double(String(format: "%.1f", CaApplication.m_Info.m_dKwhRealForAllMeter))!
        let kwhMax = Double(String(format: "%.1f", kwhRef > kwhReal ? 1.5 * kwhRef: 1.5 * kwhReal))!
        
        let strArea1 = String(kwhPlan * (100.0/kwhMax))
        let strArea2 = String((kwhRef-kwhPlan) * (100.0/kwhMax))
        let strArea3 = String((kwhMax-kwhRef) *  (100.0/kwhMax))
        
        let needleValue = (kwhReal * (100.0)/kwhMax)
        
        let actRatio = Int(100 * Double(String(format: "%.2f", (CaApplication.m_Info.m_nActCountWithHistory/CaApplication.m_Info.m_nActCount)))!)
        
        print("needle value :"  + String(needleValue))
        print("area: " + strArea1 + "," + strArea2 + "," + strArea3)
        //gaugeView.areas =  "20.5,29.5,50"
        gaugeView.areas = strArea1 + "," + strArea2 + "," + strArea3
        //gaugeView.needleValue = 55.5
        gaugeView.needleValue = CGFloat(needleValue)
        
        lblKwhReal.text = String(kwhReal)
        
        lblKwhPlan.text = "절감목표(" + String(kwhPlan) + ")"
        lblKwhRef.text = "절감기준(" + String(kwhRef) + ")"
        
        lblActCount.text = "절감조치 시행률    " + String(actRatio) + " %  (" + String(CaApplication.m_Info.m_nActCountWithHistory) + " / " + String(CaApplication.m_Info.m_nActCount) + ")"
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("플랫 갯수 " + String(CaApplication.m_Info.m_alPlan.count))
        return CaApplication.m_Info.m_alPlan.count
       
       }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let Cell = tableView.dequeueReusableCell(withIdentifier: "SavingCell", for: indexPath) as! SavingCell
    
    let plan = CaApplication.m_Info.m_alPlan[indexPath.row]
    
    Cell.lblTitle.text = plan.strMeterDescr
    Cell.lblUsageGoal.text = "절감목표  " + CaApplication.m_Info.decimal(value: plan.dKwhPlan) + " kWh"
    Cell.lblUsageRef.text = "절감기준  " + CaApplication.m_Info.decimal(value: plan.dKwhRef) + " kWh"
    Cell.lblUsageToday.text = "오늘 " + CaApplication.m_Info.decimal(value: plan.dKwhReal) + " kWh"
    Cell.lblTime.text = String(plan.nHourFrom) + "시 ~ " + String(plan.nHourTo) + "시"
    
    Cell.roundView.layer.cornerRadius = 15
    
    //Cell.tvCheckList.dataSource = plan.alAct as? UITableViewDataSource
    Cell.lvAct = plan.alAct
    Cell.plan = plan
    
    for i in 0..<plan.alAct.count {
        let act = plan.alAct[i]
        if !act.bChecked {
            plan.bAllChecked = false
            break
        }
    }
    
    let date = Date()
    
    let strNow: String = CaApplication.m_Info.dfHH.string(from: date)
    let nNow: Int = Int(strNow)!
    
    if (!plan.bAllChecked && plan.nHourTo > nNow && plan.nHourFrom <= nNow) {
        Cell.lblSavingResult.text = "지금 조치하기"
        Cell.lblSavingResult.backgroundColor = UIColor(named: "Light_cyan")
        Cell.lblSavingResult.textColor = UIColor.white
        Cell.lblSavingResult.layer.cornerRadius = 15
        print("지금조치하기")
        
    }
    else if (!plan.bAllChecked && plan.nHourTo <= nNow) {
        Cell.lblSavingResult.text = "조치 미흡"
        Cell.lblSavingResult.textColor = UIColor.red
        print("조치미흡")
    }
    else if (plan.nHourFrom > nNow) {
        Cell.lblSavingResult.text = ""
        print("미래 절감조치")
    }
    else {
        Cell.lblSavingResult.text = "조치완료"
        print("조치완료")
    }
    
    if plan.nHourFrom > nNow {
        
        //Cell.roundView.layer.backgroundColor = CGColor(red: 211, green: 211, blue: 211, alpha: 1) //light gray
        //Cell.roundView.backgroundColor = UIColor(named: "Light_gray")
        Cell.roundView.layer.borderWidth = 2
        //Cell.roundView.layer.borderColor = CGColor(red: 211, green: 211, blue: 211, alpha: 1) //light gray
        Cell.roundView.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        Cell.roundView.backgroundColor = UIColor.white
    }
    else {
        if plan.dKwhReal <= plan.dKwhPlan{
            print("꼐측기 이름: " + plan.strMeterDescr + " plan.hourfrom is  " + String(plan.nHourFrom) + " nNow is " + String(nNow))
            if plan.nHourTo > nNow {
                //Cell.roundView.layer.backgroundColor = CGColor(red: 181, green: 234, blue: 215, alpha: 1) // pastel green
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_green")
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 0, green: 128, blue: 0, alpha: 1) // green
                
            }
            else{
            
                Cell.roundView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_green")
            }
        }
        else if plan.dKwhReal <= plan.dKwhRef{
            if plan.nHourTo > nNow {
                //Cell.roundView.layer.backgroundColor = CGColor(red: 253, green: 253, blue: 150, alpha: 1) // pastel yellow
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_yellow")
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 128, green: 128, blue: 0, alpha: 1) // olive
            }
            else{
                //Cell.roundView.layer.backgroundColor = CGColor(red: 253, green: 253, blue: 150, alpha: 1) // pastel yellow
                Cell.roundView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_yellow")
            }
        }
        else {
            if plan.nHourTo > nNow {
                //Cell.roundView.layer.backgroundColor = CGColor(red: 255, green: 154, blue: 162, alpha: 1) // pastel red
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1) // red
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_red")
            }
            else{
                //Cell.roundView.layer.backgroundColor = CGColor(red: 255, green: 154, blue: 162, alpha: 1) // pastel red
                Cell.roundView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_red")
            }
        }
    }
    
    Cell.tvCheckList.backgroundColor = Cell.roundView.backgroundColor
    print("tvChecklist 색깔 입히기")
    
    return Cell
    
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        //let Cell = tableView.dequeueReusableCell(withIdentifier: "SavingCell", for: indexPath) as! SavingCell
        
        let plan = CaApplication.m_Info.m_alPlan[indexPath.row]
        
        if plan.bExecute {
            let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController
            view?.nSeqPlanElem = plan.nSeqPlanElem
            view?.modalPresentationStyle = .overCurrentContext
            self.present(view!, animated: false, completion: nil)
        }
       
        
        tableView.reloadData()
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.SavingListHeight?.constant = self.tvSavingList.contentSize.height
       print("tvsavinglist 높이 맞추기")
        tvSavingList.reloadData()
        print("viewdidlayoutsubview에서 tvsavinglist reload")
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case m_GlobalEngine.CB_GET_SAVE_RESULT_DAILY:
            
            let jo:[String: Any] = Result.JSONResult
          
            let joSave: [String: Any] = jo["save_result_daily"] as! [String: Any]
            let jaPlan: Array<[String: Any]> = joSave["list_plan_elem"] as! Array<[String: Any]>
            
            CaApplication.m_Info.m_nSeqSaveRef = joSave["seq_save_ref"] as! Int
            CaApplication.m_Info.m_nSeqSite = joSave["seq_site"] as! Int
            CaApplication.m_Info.m_strSavePlanName = joSave["save_plan_name"] as! String
            CaApplication.m_Info.m_strSaveRefName = joSave["save_ref_name"] as! String
            CaApplication.m_Info.m_dSaveKwhTotalFromElem = joSave["save_kwh_total_from_elem"] as! Double
            CaApplication.m_Info.m_dSaveWonTotalFromElem = joSave["save_won_total_from_elem"] as! Double
            CaApplication.m_Info.m_dSaveKwhTotalFromMeter = joSave["save_kwh_total_from_meter"] as! Double
            CaApplication.m_Info.m_dSaveWonTotalFromMeter = joSave["save_kwh_total_from_meter"] as! Double
            CaApplication.m_Info.m_dKwhPlanForAllMeter = joSave["kwh_plan_for_all_meter"] as! Double
            CaApplication.m_Info.m_dKwhRealForAllMeter = joSave["kwh_real_for_all_meter"] as! Double
            CaApplication.m_Info.m_dKwhRefForAllMeter = joSave["kwh_ref_for_all_meter"] as! Double
            CaApplication.m_Info.m_dWonPlanForAllMeter = joSave["won_plan_for_all_meter"] as! Double
            CaApplication.m_Info.m_dWonRealForAllMeter = joSave["won_real_for_all_meter"] as! Double
            CaApplication.m_Info.m_dWonRefForAllMeter = joSave["won_ref_for_all_meter"] as! Double
            CaApplication.m_Info.m_dtSavePlanEnded = joSave["time_ended"] as! String
            CaApplication.m_Info.m_dtSavePlanCreated = joSave["time_created"] as! String
            CaApplication.m_Info.m_nActCount = joSave["act_count"] as! Int
            CaApplication.m_Info.m_nActCountWithHistory = joSave["act_count_with_history"] as! Int


            CaApplication.m_Info.setPlanList(jaPlan)
            
            // tableView의 rowHeight는 유동적일 수 있다
            tvSavingList.rowHeight = UITableView.automaticDimension
            // tableView의 계산된 높이 값은 68이다. 즉 Default Height이다.
            tvSavingList.estimatedRowHeight = 290.0
            
            tvSavingList.reloadData()

            
            initChart()
            print("HOME: getsaveresultdaily called...")
            
                                
        default:
            print("Main: Error!")
        }
    }

}

