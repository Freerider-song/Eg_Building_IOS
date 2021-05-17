//
//  AlarmViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit


class AlarmCheckCell: UITableViewCell {
    
    @IBOutlet weak var ivCheckbox: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    
}
class AlarmViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource{
  

    @IBOutlet var lbMeter: UILabel!
    @IBOutlet var lbSavingTime: UILabel!
    @IBOutlet var lbKwhPlan: UILabel!
    @IBOutlet var tableView: UITableView!
    var nSeqPlanElem: Int = 0
    var plan: CaPlan = CaPlan()
    
    let date = Date()
    
    var checkedRow:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true
        
        // tableView의 rowHeight는 유동적일 수 있다
        tableView.rowHeight = UITableView.automaticDimension
        // tableView의 계산된 높이 값은 68이다. 즉 Default Height이다.
        tableView.estimatedRowHeight = 45.0
        
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
      
        Cell.lbContent.text = act.strActContent;
        if act.bChecked {
            Cell.ivCheckbox.image = UIImage(named: "checked_checkbox.png")
            
        }
        else {
            Cell.ivCheckbox.image = UIImage(named: "unchecked_checkbox.png")
            /*
            Cell.btnCheckBox.setImage(UIImage(named: "unchecked_checkbox.png"), for: .normal)
            Cell.btnCheckBox.imageView?.contentMode = .scaleAspectFit
            Cell.btnCheckBox.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)*/
        }
        
        if indexPath.row == checkedRow {
                //Cell.ivCheckbox.image = UIImage(named: "checked_checkbox.png")
            }
        
        return Cell
    }
    /*
    @objc func checkboxTapped(_ sender: UIButton){
      // use the tag of button as index
        let act = plan.alAct[sender.tag]
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        if !act.bChecked {
            CaApplication.m_Engine.SetSaveActBegin(act.nSeqAct, CaApplication.m_Info.m_nSeqAdmin, today, false, self)
            Cell.btnCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
            Cell.btnCheckBox.imageView?.contentMode = .scaleAspectFit
            Cell.btnCheckBox.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        }
    }
 */
    
    //셀 선택했을시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCheckCell", for: indexPath) as! AlarmCheckCell
        let act = plan.alAct[indexPath.row]
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        Cell.ivCheckbox.image = UIImage(named: "checked_checkbox.png")
        if !act.bChecked {
            //checkedRow = indexPath.row
            act.bChecked = true
            /*
            Cell.btnCheckBox.setImage(UIImage(named: "checked_checkbox.png"), for: .normal)
            Cell.btnCheckBox.imageView?.contentMode = .scaleAspectFit
            Cell.btnCheckBox.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
 */
            CaApplication.m_Engine.SetSaveActBegin(act.nSeqAct, CaApplication.m_Info.m_nSeqAdmin, today, false, self)
            
        }
        
        //Update new tick
        tableView.reloadData()
        print("btnCheckbox checked...")
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
