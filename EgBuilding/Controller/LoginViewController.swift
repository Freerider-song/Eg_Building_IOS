//
//  LoginViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
//

import UIKit
import Firebase

class LoginViewController: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var BtnChangePassword: UIButton!
    @IBOutlet var BtnLogin: UIButton!
    @IBOutlet var TxtPassword: DesignableUITextField!
    @IBOutlet var TxtId: DesignableUITextField!
    @IBOutlet var lblVersion: UILabel!
    
    var callback : ((String) -> Void)?
    
    var m_strId = ""
    var m_strPw = ""
    var m_strDeviceId = ""
    
    var restoreFrameValue: CGFloat = 0.0
    
    let toast: Toast = Toast()
    
    let m_Pref: CaPref = CaPref()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("login viewdidload")
        
        getPushId()
        viewSetting()
        
        let savedLoginId : String = m_Pref.getValue(m_GlobalEngine.PREF_MEMBER_ID, "")
        if savedLoginId != "" {
            TxtId.text = savedLoginId
        }
        
        let savedPassword : String = m_Pref.getValue(m_GlobalEngine.PREF_PASSWORD, "")
        if savedPassword != "" {
            TxtPassword.text = savedPassword
        }
        
        
        
    }
    
    func viewSetting() {
        
        // ID TextField 외관 둥글게 설정 + 회색
        TxtId.layer.cornerRadius = 15
        TxtId.layer.borderWidth = 2.0
        
       
        TxtId.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        
        
        // PW TextField 설정
        TxtPassword.layer.cornerRadius = 15
        TxtPassword.layer.borderWidth = 2.0
        
        TxtPassword.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
       
        
        // Login Button 둥글게
        BtnLogin.layer.cornerRadius = 15
        BtnLogin.layer.shadowColor = UIColor.black.cgColor // 색깔
        BtnLogin.layer.masksToBounds = false
        BtnLogin.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
        BtnLogin.layer.shadowRadius = 1 // 반경
        BtnLogin.layer.shadowOpacity = 0.3 // alpha값
        
 
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        lblVersion.text = version

        
        // 키보드 입력
        TxtId.delegate = self
        TxtPassword.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    //키보드가 텍스트 가리는 문제 해결
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
           self.view.frame.origin.y -= 50
       }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        if self.view.frame.origin.y != restoreFrameValue {
            self.view.frame.origin.y += 50
        }
          
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = restoreFrameValue
        print("touches began execute")
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
    
    // Firebase Push Key 받아오기
    func getPushId() {
        
        if(Messaging.messaging().fcmToken != nil){
            
            CaApplication.m_Info.m_strPushId = Messaging.messaging().fcmToken!
            
        }
        
        print("Push key: " + CaApplication.m_Info.m_strPushId)
    }
    
    // Alert 설정, 알람 띄우는 역할
    override func alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    // API 응답했을 때 호출됨
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
        // 로그인 API 응답
            case m_GlobalEngine.CB_CHECK_BLD_LOGIN:
                // 로그인 성공
                let jo:[String:Any] = Result.JSONResult
                let nResultCode = jo["result_code"]! as! Int
                if  nResultCode == 1 {
                    print("Login: Login Success!")
                    
                   
                    
                    // 로그인 정보 저장
                    m_Pref.setValue(m_GlobalEngine.PREF_MEMBER_ID , m_strId)
                    m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, m_strPw)
                    
                    CaApplication.m_Info.m_nSeqAdmin = jo["seq_admin"]! as! Int
                    CaApplication.m_Info.m_nTeamType = jo["team_type"]! as! Int
                    CaApplication.m_Info.m_strAdminId = m_strId
                    CaApplication.m_Info.m_strPassword = m_strPw
                    
                    CaApplication.m_Engine.GetBldAdminInfo(CaApplication.m_Info.m_nSeqAdmin, false ,self)
                    
                    
                } else {
                    print("Login: Login Failed!")
                    
                    alert(title: "Login Failed", message: "일치하는 회원정보가 없습니다. 아이디나 비밀번호를 확인해주십시오.", text: "확인")
                }
                
            break
                
                // 맴버 정보 가져옴
            case m_GlobalEngine.CB_GET_BLD_ADMIN_INFO:
                let jo:[String:Any] = Result.JSONResult
                let jaListSite: Array<[String:Any]> = Result.JSONResult["list_site"]! as! Array<[String : Any]>
                
                /*CaApplication.m_Info.dtCreated = jo["time_created"] as? Date
                CaApplication.m_Info.dtModified = jo["time_modified"] as? Date
                CaApplication.m_Info.dtLastLogin = jo["time_last_login"] as? Date
                CaApplication.m_Info.dtChangePassword = joMemberInfo["time_change_password"] as? Date*/
                
                CaApplication.m_Info.m_strAdminName = jo["admin_name"] as! String
                CaApplication.m_Info.m_strAdminPhone = jo["admin_phone"] as! String
                CaApplication.m_Info.m_nUnreadNoticeCount = jo["unread_notice_count"] as! Int
                CaApplication.m_Info.m_nUnreadAlarmCount = jo["unread_alarm_count"] as! Int
                CaApplication.m_Info.m_dtCreated = jo["time_created"] as? String ?? ""
                CaApplication.m_Info.m_dtModified = jo["time_modified"] as? String ?? ""
                CaApplication.m_Info.m_dtLastLogin = jo["time_last_login"] as? String ?? ""
                CaApplication.m_Info.m_dtChangePassword = jo["time_change_password"] as? String ?? ""
                CaApplication.m_Info.m_nSeqTeam = jo["seq_team"] as! Int
                CaApplication.m_Info.m_nTeamType = jo["team_type"] as! Int
                
                CaApplication.m_Info.m_strTeamName = jo["team_name"] as! String
                CaApplication.m_Info.m_bNotiAll = jo["noti_all"] as! Bool
                CaApplication.m_Info.m_bNotiKwh = jo["noti_this_month_kwh"] as! Bool
                CaApplication.m_Info.m_bNotiWon = jo["noti_this_month_won"] as! Bool
                CaApplication.m_Info.m_bNotiUsageAtTime = jo["noti_this_month_usage_at_time"] as! Bool
                CaApplication.m_Info.m_bNotiSavingStandard = jo["noti_meter_kwh_over_save_ref"] as! Bool
                CaApplication.m_Info.m_bNotiSavingGoal = jo["noti_meter_kwh_over_save_plan"] as! Bool
                CaApplication.m_Info.m_dThresholdThisMonthKwh = jo["threshold_this_month_kwh"] as! Double
                CaApplication.m_Info.m_dThresholdThisMonthWon = jo["threshold_this_month_won"] as! Double
                
                for k in 0 ..< jaListSite.count{
                    
                    let joListSite: [String:Any] = jaListSite[k]
                    
                    CaApplication.m_Info.m_nSeqSite = joListSite["seq_site"]! as! Int
                    CaApplication.m_Info.m_nSiteType = joListSite["site_type"]! as! Int
                    CaApplication.m_Info.m_strSiteName = joListSite["site_name"]! as! String
                    CaApplication.m_Info.m_nBuiltYear = joListSite["built_year"]! as! Int
                    CaApplication.m_Info.m_nBuiltMonth = joListSite["built_month"]! as! Int
                    CaApplication.m_Info.m_strFloorInfo = joListSite["floor_info"]! as! String
                    CaApplication.m_Info.m_strHomePage = joListSite["home_page"]! as! String
                    CaApplication.m_Info.m_strSitePhone = joListSite["site_phone"]! as! String
                    CaApplication.m_Info.m_strSiteAddress = joListSite["site_address"]! as! String
                    CaApplication.m_Info.m_dSiteDx = joListSite["site_dx"]! as! Double
                    CaApplication.m_Info.m_dSiteDy = joListSite["site_dy"]! as! Double
                    CaApplication.m_Info.m_dKwContracted = joListSite["kw_contracted"]! as! Double
                    CaApplication.m_Info.m_nReadDay = joListSite["read_day"]! as! Int
                    CaApplication.m_Info.m_nSeqSavePlanActive = joListSite["seq_save_plan_active"]! as! Int
                }
                
                
                
                print("Login: 성공적으로 불렸습니다")
                
                /*
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true, completion: nil)
                */
                
                let date = Date()
                let getTime = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
                
                CaApplication.m_Engine.GetSaveResultDaily(CaApplication.m_Info.m_nSeqSavePlanActive, getTime, false, self)
                
                //done(sender: self)
                
                
            break
                

        case m_GlobalEngine.CB_GET_SAVE_RESULT_DAILY:
            
            let jo:[String: Any] = Result.JSONResult
            //print(jo["list_plan_elem"])
            
            //let jaPlan: [String: Any] = jo["list_plan_elem"] as! [String: Any]
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

            print("HOME: getsaveresultdaily called...")
            
            done(sender: self)
            
                
            default:
                print("Login: Error!")
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        print("Login: Login Success")
        
        // Login 성공으로 바꿈
        CaApplication.m_Info.isLogin = true
        
        //그 전에 쌓여있던 뷰 모두 제거 후 루트뷰로 전환
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func OnBtnLoginClicked(_ sender: UIButton) {
        
        if TxtId.text == "" {
            alert(title: "Login Failed", message: "아이디를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        if TxtPassword.text == "" {
            alert(title: "Login Failed", message: "비밀번호를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        
        m_strId = TxtId.text!
        m_strPw = TxtPassword.text!
        m_strDeviceId = CaApplication.m_Info.m_strPushId
        print("m_strDeviceId is " + m_strDeviceId)
        
        let date = Date()
        
        // 정보 가져올 날짜
        let today: String = CaApplication.m_Info.dfyyMMdd.string(from: date) + "01"
        
        CaApplication.m_Engine.CheckBldLogin(self.m_strId, self.m_strPw, "IOS", self.m_strDeviceId, today, self)
    }
    
    @IBAction func OnBtnChangePwClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ChangePasswordAuthViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    

}
