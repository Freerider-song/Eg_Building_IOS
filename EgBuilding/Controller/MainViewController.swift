//
//  ViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
// view를 overcurrentContext로 Present시 dismiss후 메인뷰로 돌아와도 viewdidappear 호출 되지 않ㄴ느다.
//https://medium.com/livefront/why-isnt-viewwillappear-getting-called-d02417b00396

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
    @IBOutlet weak var btnSavingResult: UIButton!
    
    
    @IBOutlet var CheckListHeight: NSLayoutConstraint!
    
    var lvAct : Array<CaAct> = Array()
    var plan : CaPlan = CaPlan()
    var tvSaving = UITableView()
    var SavingListHeight: NSLayoutConstraint!
    
    //tableViewCell 안에 tableView를 넣어 관리하고 싶을 때
    override func awakeFromNib() {
        super.awakeFromNib()
        tvCheckList.delegate = self
        tvCheckList.dataSource = self
        
        
    }
    
    override func layoutSubviews() {
        
        //처음 스크롤 할떄는 공간이 남지만 다음 스크롤 시에는 정상적으로 작동한다. 이것이 지금 최선인듯
        self.CheckListHeight?.constant = self.tvCheckList.contentSize.height
        self.SavingListHeight?.constant = self.tvSaving.contentSize.height

        
        //super.layoutSubView()를 먼저 실행하게 될 경우 오류 발생.
        //super.layoutSubviews()
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lvAct.count
        
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SavingCheckCell", for: indexPath) as! SavingCheckCell
        
        let act = lvAct[indexPath.row]
        Cell.lbContent.text = act.strActContent
        
        if act.bChecked {
           
            Cell.ivCheckbox.image = UIImage(named: "checked_checkbox.png")
        }
        else {
         
            Cell.ivCheckbox.image = UIImage(named: "unchecked_checkbox.png")
        }
      
        let date = Date()
        let strNow: String = CaApplication.m_Info.dfHH.string(from: date)
        let nNow: Int = Int(strNow)!
        
        if plan.nHourFrom > nNow { //아직 다가오지 않은 미래 절감조치의 경우
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
        
        print("Main: tvChecklist Loaded...") //색 입힌 후 tvchecklist 가 로딩된다.
        
        return Cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
 
    
}

class SavingCheckCell: UITableViewCell{
   
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var ivCheckbox: UIImageView!
    
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
        // tableView의 계산된 높이 값은 290이다. 즉 Default Height이다.
        tvSavingList.estimatedRowHeight = 290.0
        
        
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
    
        //절감 조치 이후에 새로고침 되어야 하므로 viewDidAppear에서 API 호출
        let date = Date()
        let getTime = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        //view가 다 load되어 있는 상태이므로 bshowWating을 true로 하여도 view가 dismiss되지 않는다.
        CaApplication.m_Engine.GetSaveResultDaily(CaApplication.m_Info.m_nSeqSavePlanActive, getTime, true, self)
        
   
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
        
        let actRatio = Int(100 * Double(String(format: "%.2f", (Double(CaApplication.m_Info.m_nActCountWithHistory)/Double(CaApplication.m_Info.m_nActCount))))!)
       
        //이 Tool은 area를 다음과 같이 문자열로 표현해야 작동한다.
        gaugeView.areas = strArea1 + "," + strArea2 + "," + strArea3
        gaugeView.needleValue = CGFloat(needleValue)
        
        lblKwhReal.text = String(kwhReal)
        lblKwhPlan.text = "절감목표(" + String(kwhPlan) + ")"
        lblKwhRef.text = "절감기준(" + String(kwhRef) + ")"
        
        lblActCount.text = "절감조치 시행률    " + String(actRatio) + " %  (" + String(CaApplication.m_Info.m_nActCountWithHistory) + " / " + String(CaApplication.m_Info.m_nActCount) + ")"
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Main: alPlan count is " + String(CaApplication.m_Info.m_alPlan.count))
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
    
    // Cell에 lvAct, plan 선언 후 Cell안에 있는 tableView에서 사용할 의도
    Cell.lvAct = plan.alAct
    Cell.plan = plan
    Cell.tvSaving = tvSavingList
    Cell.SavingListHeight = SavingListHeight

    let date = Date()
    
    let strNow: String = CaApplication.m_Info.dfHH.string(from: date)
    let nNow: Int = Int(strNow)!
    
    if (!plan.bAllChecked && plan.nHourTo > nNow && plan.nHourFrom <= nNow) {
        Cell.btnSavingResult.setTitle("지금조치하기", for: .normal)
        Cell.btnSavingResult.blink()
        Cell.roundView.blink2()
        Cell.btnSavingResult.backgroundColor = UIColor(named: "Light_cyan")
        Cell.btnSavingResult.layer.cornerRadius = 10
        Cell.btnSavingResult.setTitleColor(UIColor.white, for: .normal)
        plan.bExecute = true
        
        //조치완료 등 테이블뷰 셀 안에 있는 버튼 클릭 시 Obj-c 함수가 실행된다
        Cell.btnSavingResult.tag = indexPath.row
        Cell.btnSavingResult.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
    }
    else if (!plan.bAllChecked && plan.nHourTo <= nNow) {
        Cell.btnSavingResult.setTitle("조치미흡", for: .normal)
        Cell.btnSavingResult.setTitleColor(UIColor.red, for: .normal)
        Cell.btnSavingResult.backgroundColor = UIColor.clear

    }
    else if (plan.nHourFrom > nNow) {
        Cell.btnSavingResult.setTitle("", for: .normal)
        Cell.btnSavingResult.backgroundColor = UIColor.clear
   
    }
    else {
        Cell.btnSavingResult.setTitle("조치완료", for: .normal)
        Cell.btnSavingResult.setTitleColor(UIColor.black, for: .normal)
        Cell.btnSavingResult.backgroundColor = UIColor.clear

    }
    
    if plan.nHourFrom > nNow {
        
        Cell.roundView.layer.borderWidth = 2
        Cell.roundView.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1) //light gray
        Cell.roundView.backgroundColor = UIColor.white
    }
    else {
        if plan.dKwhReal <= plan.dKwhPlan{
         
            if plan.nHourTo > nNow {
            
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_green")
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 0, green: 128/255, blue: 0, alpha: 1) // green
                
            }
            else{
                
                Cell.roundView.layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_green")
            }
        }
        else if plan.dKwhReal <= plan.dKwhRef{
         
            if plan.nHourTo > nNow {
               
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_yellow")
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 128/255, green: 128/255, blue: 0, alpha: 1)
                // olive
            }
            else{
                
                Cell.roundView.layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_yellow")
            }
        }
        else {
            if plan.nHourTo > nNow {
                
                Cell.roundView.layer.borderWidth = 2
                Cell.roundView.layer.borderColor = CGColor(red: 255/255, green: 0, blue: 0, alpha: 1) // red
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_red")
            }
            else{
                
                Cell.roundView.layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                Cell.roundView.backgroundColor = UIColor(named: "Pastel_red")
            }
        }
    }
    
    Cell.tvCheckList.backgroundColor = Cell.roundView.backgroundColor
 
    return Cell
    
   }
    
    @objc func buttonTapped(_ sender: UIButton){
      // use the tag of button as index
        let plan = CaApplication.m_Info.m_alPlan[sender.tag]
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController
        view?.nSeqPlanElem = plan.nSeqPlanElem
        view?.modalPresentationStyle = .fullScreen
        self.present(view!, animated: false, completion: nil)
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        //self.SavingListHeight?.constant = self.tvSavingList.contentSize.height
        // Reload 해야 오류가 나지 않는다.
        tvSavingList.reloadData()
       
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
            
            //오류 나지 않으려면 필수
            tvSavingList.reloadData()

            initChart()
            print("Main: getSaveResultDaily called...")
            
                                
        default:
            print("Main: Error!")
        }
    }

}


