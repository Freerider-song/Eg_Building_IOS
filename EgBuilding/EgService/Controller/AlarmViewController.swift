//
//  AlarmViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/02/04.
//

import UIKit

class AlarmCell: UITableViewCell {
    @IBOutlet var ivNew: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbContent: UILabel!
    @IBOutlet var lbTimeCreated: UILabel!
    @IBOutlet var lbAckResponse: UILabel!
    @IBOutlet var roundView: UIView!
    
}

class AlarmViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApplication.m_Info.alAlarm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        let alarm = CaApplication.m_Info.alAlarm[indexPath.row]
        
        myCell.contentView.backgroundColor = UIColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        
        myCell.layer.backgroundColor = CGColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        
        myCell.roundView.layer.cornerRadius = 20
        
        myCell.lbTitle.text = alarm.strTitle
        myCell.lbContent.text = alarm.strContent
        myCell.lbTimeCreated.text = alarm.dtCreated
        
        
        if alarm.bRead {
            myCell.ivNew.isHidden = true
        }
        else {
            myCell.ivNew.isHidden = false
        }
        
        if alarm.isRequestAck() {
            switch (alarm.nResponse) {
            case 0:
                myCell.lbAckResponse.text = "승인 대기중"
                
            case 1:
                myCell.lbAckResponse.text = "승인함"
                
            case 2:
                myCell.lbAckResponse.text = "거절함"
                
            default:
                myCell.lbAckResponse.text = "미정"
            }
            myCell.lbAckResponse.isHidden = false
        }
        else {
            myCell.lbAckResponse.isHidden = true
        }
        
        switch alarm.nAlarmType {
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_USAGE:
         
            myCell.roundView.backgroundColor = UIColor(red: 244/255, green: 210/255, blue: 34/255, alpha: 1)
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_TRANS:
            
            myCell.roundView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 34/255, alpha: 1)
            
        default:
      
            myCell.roundView.backgroundColor = UIColor(red: 209/255, green: 203/255, blue: 66/255, alpha: 1)
        }
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let alarm = CaApplication.m_Info.alAlarm[indexPath.row]
        
        
        
        alarm.bRead = true
        alarm.bReadStateChanged = true
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        alarm.dtRead = dateFormatter.string(from: now)
        setAlarmReadStateToDb()
        tableView.reloadData()
        
        if alarm.isRequestAck() && alarm.nResponse == 0 {
            // alert
            
            let msg = UIAlertController(title: "\(alarm.strTitle)", message: "\(alarm.strContent)", preferredStyle: .alert)
                    
                    //Alert에 부여할 Yes이벤트 선언
                    let YES = UIAlertAction(title: "승인", style: .default, handler: { (action) -> Void in
                        CaApplication.m_Engine.ResponseAckMember(alarm.nSeqMemberAckRequester, 1, _bShowWaitDialog: false, self)
                    })
                    
                    //Alert에 부여할 No이벤트 선언
                    let NO = UIAlertAction(title: "거절", style: .default, handler: { (action) -> Void in
                        CaApplication.m_Engine.ResponseAckMember(alarm.nSeqMemberAckRequester, 2, _bShowWaitDialog: false, self)
                    })
                    
                    
                    //Alert에 이벤트 연결
                    msg.addAction(YES)
                    msg.addAction(NO)

                    //Alert 호출
                    self.present(msg, animated: true, completion: nil)
        }
        else {
            
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "AlarmPopUpViewController") as? AlarmPopUpViewController
            view?.strTitle = alarm.strTitle
            view?.strContent = alarm.strContent
            view?.nAckResponse = alarm.nResponse
            view?.modalPresentationStyle = .fullScreen
            self.present(view!, animated: true, completion: nil)
            
        }
        


   
    
    }
    
    //tableview cell 높이 자동 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setAlarmReadStateToDb() {
        let strSeqAlarmList = CaApplication.m_Info.getAlarmReadListString()
        
        if strSeqAlarmList.isEmpty {return}
        else {
            CaApplication.m_Engine.SetAlarmListAsRead(CaApplication.m_Info.nSeqMember, strSeqAlarmList, false, self)
        }
    }

    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.EG_RESPONSE_ACK_MEMBER:
                print("Result of ResponseAckMember Received...")
                let jo:[String:Any] = Result.JSONResult
                
                let nResultCode = jo["result_code"] as! Int
                if nResultCode == 1 {
                    let nAckType = jo["ack_type"] as! Int// 1=승인 2=거절 3= 철회
                    let nSeqMemberSub = jo["seq_member_sub"] as! Int
                    let strNameSub = jo["name_sub"] as! String
                    let strPhoneSub = jo["phone_sub"] as! String
                    
                    CaApplication.m_Info.setResponseCodeForMemberSub(nSeqMemberSub, nAckType)
                    
                    if nAckType == 1 {
                        let ca_family: CaFamily = CaFamily()
                        ca_family.nSeqMember = nSeqMemberSub
                        ca_family.strName = strNameSub
                        ca_family.strPhone = strPhoneSub
                        ca_family.bMain = false
                        
                        CaApplication.m_Info.alFamily.append(ca_family)
                        
                       
                    }
                }
        case m_GlobalEngine.EG_SET_ALARM_LIST_AS_READ:
            print("Result of SetAlarmListAsRead Received...")
            let jo:[String:Any] = Result.JSONResult
            let result = jo["result_code"] as! Int
            print("result is \(result)")
            
            default:
                print("Unknown type result received : \(Result.callback)")
        }
    }
    
    
  
     @IBAction func onBackBtnClicked(_ sender: UIButton) {
        setAlarmReadStateToDb()
        self.dismiss(animated: true, completion: nil)
     }
    
    
    
     
    @IBAction func onAlarmSettingBtnClicked(_ sender: UIButton) {
        print("Alarm: AlarmSetting Button Clicked")
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SettingViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}
