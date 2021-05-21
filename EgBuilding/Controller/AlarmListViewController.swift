//
//  AlarmListViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbTimeCreated: UILabel!
    @IBOutlet var lbContent: UILabel!
    @IBOutlet var btnExecute: UIButton!
    
    @IBOutlet var roundView: UIView!
}


class AlarmListViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

 
    @IBOutlet var tableView: UITableView!
    
    let date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        

    }
    
    //Alarm에서 절감조치하고 돌아올 시 viewdidappear 호출 -> 새로고침
    override func viewDidAppear(_ animated: Bool) {
        
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        CaApplication.m_Engine.GetBldAlarmList(CaApplication.m_Info.m_nSeqAdmin, 30, false, self)
        CaApplication.m_Engine.GetSaveResultDaily(CaApplication.m_Info.m_nSeqSavePlanActive, today, true, self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApplication.m_Info.m_alAlarm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        let alarm = CaApplication.m_Info.m_alAlarm[indexPath.row]
        
        
        myCell.roundView.layer.cornerRadius = 15
        myCell.roundView.layer.borderWidth = 2
        myCell.roundView.layer.borderColor = CGColor(red: 20/255, green: 118/255, blue: 156/255, alpha: 1) //dark cyan
        
        myCell.btnExecute.layer.cornerRadius = 10
        
        myCell.lbTitle.text = alarm.strTitle
        myCell.lbContent.text = alarm.strContent
        myCell.lbTimeCreated.text = alarm.dtCreated
        
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
    
        switch (alarm.nAlarmType) {
        case m_GlobalEngine.ALARM_SAVE_ACT_MISSED, m_GlobalEngine.ALARM_PLAN_ELEM_BEGIN, m_GlobalEngine.ALARM_PLAN_ELEM_END:
    
            myCell.btnExecute.isHidden = false
            
            
            for i in 0..<CaApplication.m_Info.m_alPlan.count {
                let plan = CaApplication.m_Info.m_alPlan[i]
                
                if(plan.nSeqPlanElem == alarm.nSeqSavePlanElem) {
               
                    if plan.bAllChecked {
                        myCell.btnExecute.setTitle("조치 완료", for: .normal)
                        myCell.btnExecute.isEnabled = false
                        myCell.btnExecute.backgroundColor = UIColor(named: "Pastel_blue")
                    }
                    else if plan.nHourTo<=Int(CaApplication.m_Info.dfHH.string(from: date))! {
                        myCell.btnExecute.setTitle("조치 미흡", for: .normal)
                        myCell.btnExecute.isEnabled = false
                        myCell.btnExecute.backgroundColor = UIColor(named: "Pastel_blue")
                        
                    }
                    else if (plan.nHourTo > Int(CaApplication.m_Info.dfHH.string(from: date))!) && (plan.nHourFrom <= Int(CaApplication.m_Info.dfHH.string(from: date))!) {
                        myCell.btnExecute.setTitle("지금조치하기", for: .normal)
                        myCell.btnExecute.isEnabled = true
                        alarm.bClickable = true
                        myCell.btnExecute.backgroundColor = UIColor(named: "EG_Dark_yellow")
                        
                    }
                    
                    else {
                        //myCell.btnExecute.isHidden = true
                        myCell.btnExecute.setTitle("지금조치하기", for: .normal)
                        myCell.btnExecute.isEnabled = false
                        alarm.bClickable = false
                        myCell.btnExecute.backgroundColor = UIColor(named: "EG_Dark_yellow")
                        myCell.btnExecute.setTitleColor(UIColor.gray, for: .normal)
                    }
                    break
                }
            }
     
            
        default:
            myCell.btnExecute.isHidden = true
        }
        
        
    
        if CaApplication.m_Info.dfyyyyMMdd.string(from: CaApplication.m_Info.dfStd.date(from: alarm.dtCreated)!) != today {
            myCell.btnExecute.isHidden = true
        }
     
        
        return myCell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let alarm = CaApplication.m_Info.m_alAlarm[indexPath.row]
    
        alarm.bRead = true
        alarm.bReadStateChanged = true
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        alarm.dtRead = dateFormatter.string(from: now)
        setAlarmReadStateToDb()
        tableView.reloadData()
        
        if alarm.bClickable {
            let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController
            view?.nSeqPlanElem = alarm.nSeqSavePlanElem
            view?.modalPresentationStyle = .fullScreen
            self.present(view!, animated: false, completion: nil)
        }
        
        
    }

    func setAlarmReadStateToDb() {
        let strSeqAlarmList = CaApplication.m_Info.getAlarmReadListString()
        
        if strSeqAlarmList.isEmpty {return}
        else {
            //CaApplication.m_Engine.SetAlarmListAsRead(CaApplication.m_Info.nSeqMember, strSeqAlarmList, false, self)
        }
    }

    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.CB_GET_BLD_ALARM_LIST:
                print("Result of GetAlarmList Received...")
                let jo:[String:Any] = Result.JSONResult
                let ja:Array<[String:Any]> = jo["list_alarm"] as! Array<[String:Any]>
                
                if ja.count != 0 {
                    CaApplication.m_Info.setAlarmList(ja)
                }
                
                
        case m_GlobalEngine.CB_GET_SAVE_RESULT_DAILY:
            print("Result of SetAlarmListAsRead Received...")
            let jo:[String:Any] = Result.JSONResult
            let joSave:[String:Any] = jo["save_result_daily"] as! [String:Any]
            let jaPlan:Array<[String:Any]> = joSave["list_plan_elem"] as! Array<[String:Any]>
            
            CaApplication.m_Info.setPlanList(jaPlan)
            
            tableView.reloadData()
            
          
            
            default:
                print("Unknown type result received : \(Result.callback)")
        }
    }
    

    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
  
}
