//
//  AlarmViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit


class AlarmCheckCell: UITableViewCell {
    @IBOutlet var btnCheckBox: UIButton!
    
}
class AlarmViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource{
  

    @IBOutlet var lbMeter: UILabel!
    @IBOutlet var lbSavingTime: UILabel!
    @IBOutlet var lbKwhPlan: UILabel!
    @IBOutlet var tableView: UITableView!
    var nSeqPlanElem: Int = 0
    var plan: CaPlan = CaPlan()
    
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if nSeqPlanElem > 0 {
            for i in 0..<CaApplication.m_Info.m_alPlan.count {
                if CaApplication.m_Info.m_alPlan[i].nSeqPlanElem == nSeqPlanElem {
                    plan = CaApplication.m_Info.m_alPlan[i]
                    
                    lbMeter.text = plan.strMeterDescr
                    lbSavingTime.text = "절감 시간  " + String(plan.nHourFrom) + "시 ~ " + String(plan.nHourTo) + "시"
                    lbKwhPlan.text = "절감 목표  " + String(plan.nPercentToSave) + " %  ( " + String(format: "%.1f", plan.dKwhPlan) + " kWh )"
                    
                    
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.alAct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCheckCell", for: indexPath) as! AlarmCheckCell
        
        let act = plan.alAct[indexPath.row]
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        
        Cell.btnCheckBox.setTitle(act.strActContent, for: .normal)
        
        var flag: Bool = false
    
        for i in 0..<act.alActHistory.count {
            let actHistory = act.alActHistory[i]
            let dtBegin: Date = CaApplication.m_Info.dfStd.date(from: actHistory.dtBegin)!
            let strBegin: String = CaApplication.m_Info.dfyyyyMMdd.string(from: dtBegin)
            if(today == strBegin){
                Cell.btnCheckBox.isSelected = true
                flag = true
                break
            }
        }
        if flag == false {
            Cell.btnCheckBox.isSelected = false
        }
        
        
        
        return Cell
    }
    
    //셀 선택했을시 notice로 넘어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCheckCell", for: indexPath) as! AlarmCheckCell
        let act = plan.alAct[indexPath.row]
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        if !Cell.btnCheckBox.isSelected {
            CaApplication.m_Engine.SetSaveActBegin(act.nSeqAct, CaApplication.m_Info.m_nSeqAdmin, today, false, self)
            Cell.btnCheckBox.isSelected = true
        }
        
        tableView.reloadData()
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.CB_SET_SAVE_ACT_BEGIN:
                
                print("Result of SetSaveActBegin Received...")
                let jo:[String:Any] = Result.JSONResult
                let nResultCode: Int = jo["result_code"] as! Int
                
                if nResultCode == 0 {
                    alert(title: "확인", message: "해당 절감조치는 이미 이행되었습니다.", text: "확인")
                }
                
            
            default:
                print("Unknown type result received : \(Result.callback)")
        }
    }
    
    
  
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onExecuteBtnClicked(_ sender: UIButton) {
        let msg = UIAlertController(title: "확인", message: "절감 조치가 이행되었습니다.", preferredStyle: .alert)
                
                //Alert에 부여할 Yes이벤트 선언
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    self.dismiss(animated: false, completion: nil)
                })
                
                //Alert에 이벤트 연결
                msg.addAction(YES)
             
                //Alert 호출
                self.present(msg, animated: true, completion: nil)
    }
}
