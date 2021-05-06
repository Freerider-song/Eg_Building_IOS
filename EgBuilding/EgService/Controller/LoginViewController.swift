//
//  LoginViewController.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/13.
//

import UIKit
import Firebase

class LoginViewController: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var txtId: DesignableUITextField!
    @IBOutlet var txtPw: DesignableUITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnJoin: UIButton!
    @IBOutlet var lblVersion: UILabel!
    
    var callback : ((String) -> Void)?
    
    var m_strId = ""
    var m_strPw = ""
    var m_strDeviceId = ""
    
    var restoreFrameValue: CGFloat = 0.0 //키보드 관련
    
    let toast: Toast = Toast()
    
    let m_Pref: CaPref = CaPref()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("togdog Login viewDidLoad")
        
        getPushId()
        viewSetting()
        
        //저장된 로그인정보 확인
        let savedLoginId: String = m_Pref.getValue(m_GlobalEngine.PREF_MEMBER_ID, "")
        if savedLoginId != "" {
            txtId.text = savedLoginId
        }
        
        let savedPassword: String = m_Pref.getValue(m_GlobalEngine.PREF_PASSWORD, "")
        if savedPassword != "" {
            txtPw.text = savedPassword
        }
  
    }
    
    func viewSetting() {
        
        // ID TextField 외관 둥글게 설정 + 회색
        txtId.layer.cornerRadius = 15
        txtId.layer.borderWidth = 2.0
       
        txtId.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
       
        
        // PW TextField 설정
        txtPw.layer.cornerRadius = 15
        txtPw.layer.borderWidth = 2.0
        
        txtPw.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
       
        
        // Login Button 둥글게
        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.shadowColor = UIColor.black.cgColor // 색깔
        btnLogin.layer.masksToBounds = false
        btnLogin.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
        btnLogin.layer.shadowRadius = 1 // 반경
        btnLogin.layer.shadowOpacity = 0.3 // alpha값
        
        
        btnChangePassword.layer.cornerRadius = 15
        btnChangePassword.layer.borderWidth = 2.0
        btnChangePassword.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        btnJoin.layer.cornerRadius = 15
        btnJoin.layer.borderWidth = 2.0
        btnJoin.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        lblVersion.text = version

        
        // 키보드 입력
        txtId.delegate = self
        txtPw.delegate = self
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
            
            CaApplication.m_Info.strPushId = Messaging.messaging().fcmToken!
            
        }
        
        print("Push key: " + CaApplication.m_Info.strPushId)
    }
    
    // Alert 설정, 알람 띄우는 역할
    func alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    // API 응답했을 때 호출됨
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
        // 로그인 API 응답
            case m_GlobalEngine.EG_CHECK_LOGIN:
                // 로그인 성공
                if Result.JSONResult["is_id_password_ok"]! as! Bool {
                    print("Login: Login Success!")
                    
                    let jo:[String:Any] = Result.JSONResult
                    
                    // 로그인 정보 저장
                    m_Pref.setValue(m_GlobalEngine.PREF_MEMBER_ID , m_strId)
                    m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, m_strPw)
                    
                    let bNewVersionAvailable: Bool = jo["is_new_version_available"]! as! Bool
                    let bMainMember: Bool = jo["is_main_member"]! as! Bool
                    let nSeqMemberMain: Int = jo["seq_member_main"]! as! Int
                    let nSeqMemberSub: Int = jo["seq_member_sub"]! as! Int
                    
                    CaApplication.m_Info.strMemberId = m_strId
                    CaApplication.m_Info.strPassword = m_strPw
                    CaApplication.m_Info.nSeqMember = jo["seq_member"]! as! Int
                    CaApplication.m_Info.nSeqSite = jo["seq_site"]! as! Int
                    CaApplication.m_Info.bMainMember = bMainMember
                    
                    CaApplication.m_Info.dtAuthRequested = jo["time_ack_request"]! as? Date
                    CaApplication.m_Info.dtAuthResponsed = jo["time_ack_response"]! as? Date
                    
                    
                    CaApplication.m_Info.nAckResponseCodeLatest
                     = jo["ack_response_code_latest"]! as! Int
                    CaApplication.m_Info.nAckRequestTodayCount
                     = jo["ack_request_today_count"] as! Int
                    
                    if bMainMember {
                        if bNewVersionAvailable {
                            alert(title: "새 버전 출시", message: "새로운 버전이 있습니다. 앱 버전 업데이트를 진행해주세요!", text: "확인")
                        }
                        else {
                            CaApplication.m_Engine.GetMemberInfo(CaApplication.m_Info.nSeqMember, self)
                        }
                    }
                    else {
                        if CaApplication.m_Info.nAckResponseCodeLatest == 1 {
                            if bNewVersionAvailable {
                                alert(title: "새 버전 출시", message: "새로운 버전이 있습니다. 앱 버전 업데이트를 진행해주세요!", text: "확인")
                            }
                            else {
                                CaApplication.m_Engine.GetMemberInfo(CaApplication.m_Info.nSeqMember, self)
                            }
                        }
                        else {
                            
                            print("승인 대기중")
                            
                            let storyboard = UIStoryboard(name: "Ack", bundle: nil)
                            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AckViewController")
                            view.modalPresentationStyle = .fullScreen
                            self.present(view, animated: true, completion: nil)
                        }
                    }
                    
                    
                } else {
                    print("Login: Login Failed!")
                    
                    alert(title: "Login Failed", message: "일치하는 회원정보가 없습니다. 아이디나 비밀번호를 확인해주십시오.", text: "확인")
                }
                
            break
                
                // 맴버 정보 가져옴
            case m_GlobalEngine.EG_GET_MEMBER_INFO:
                let jo:[String:Any] = Result.JSONResult
                let joMemberInfo:[String:Any] = Result.JSONResult["member_info"]! as! [String : Any]
                
                /*CaApplication.m_Info.dtCreated = jo["time_created"] as? Date
                CaApplication.m_Info.dtModified = jo["time_modified"] as? Date
                CaApplication.m_Info.dtLastLogin = jo["time_last_login"] as? Date
                CaApplication.m_Info.dtChangePassword = joMemberInfo["time_change_password"] as? Date*/
                
                CaApplication.m_Info.dtCreated = joMemberInfo["time_created"] as! String
                CaApplication.m_Info.dtModified = joMemberInfo["time_modified"] as? String ?? ""
                CaApplication.m_Info.dtLastLogin = joMemberInfo["time_last_login"] as! String
                CaApplication.m_Info.dtChangePassword = joMemberInfo["time_change_password"] as! String
                
                CaApplication.m_Info.bMainMember = joMemberInfo["member_main"]! as! Bool
                CaApplication.m_Info.nSeqSite = joMemberInfo["seq_site"]! as! Int
                CaApplication.m_Info.nSeqMember = joMemberInfo["seq_member"]! as! Int
                CaApplication.m_Info.strMemberName = joMemberInfo["member_name"]! as! String
                CaApplication.m_Info.strSiteName = joMemberInfo["site_name"]! as! String
                CaApplication.m_Info.strSiteAddress = joMemberInfo["site_address"]! as! String
                CaApplication.m_Info.nSiteBuiltYear = joMemberInfo["site_built_year"]! as! Int
                CaApplication.m_Info.nSiteBuiltMonth = joMemberInfo["site_built_month"]! as! Int
                CaApplication.m_Info.nSeqAptDong = joMemberInfo["seq_apt_dong"]! as! Int
                CaApplication.m_Info.strAptDongName = joMemberInfo["apt_dong_name"]! as! String
                CaApplication.m_Info.nSeqAptHo = joMemberInfo["seq_apt_ho"]! as! Int
                CaApplication.m_Info.strAptHoName = joMemberInfo["apt_ho_name"]! as! String
                CaApplication.m_Info.nAptHoArea = joMemberInfo["apt_ho_area"]! as! Int
                CaApplication.m_Info.strPhone = joMemberInfo["phone_num"]! as! String
                
                // 현재 Null 값이 전송돼 오류가 발생하기에 주석처리 해놓음. 값이 없을 때 Null을 보내는 문제 상무님이랑 해결 필요
                //CaApplication.m_Info.strMail = joMemberInfo["mail"]! as! String
                
                CaApplication.m_Info.bNotiAll = joMemberInfo["noti_all"]! as! Bool
                CaApplication.m_Info.bNotiKwh = joMemberInfo["noti_kwh"]! as! Bool
                CaApplication.m_Info.bNotiWon = joMemberInfo["noti_won"]! as! Bool
                CaApplication.m_Info.bNotiPriceLevel = joMemberInfo["noti_price_level"]! as! Bool
                CaApplication.m_Info.bNotiUsageAtTime = joMemberInfo["noti_usage_at_time"]! as! Bool
                CaApplication.m_Info.dThresholdKwh = joMemberInfo["threshold_kwh"]! as! Double
                CaApplication.m_Info.dThresholdWon = joMemberInfo["threshold_won"]! as! Double
                CaApplication.m_Info.nNextPriceLevelPercent = joMemberInfo["next_price_level_percent"]! as! Int
                CaApplication.m_Info.nUsageNotiType = joMemberInfo["usage_noti_type"]! as! Int
                CaApplication.m_Info.nUsageNotiHour = joMemberInfo["usage_noti_hour"]! as! Int
                CaApplication.m_Info.nSiteReadDay = joMemberInfo["site_read_day"]! as! Int
                CaApplication.m_Info.nSeqMeter = joMemberInfo["seq_meter"]! as! Int
                CaApplication.m_Info.strMid = joMemberInfo["meter_id"]! as! String
                CaApplication.m_Info.strMeterMac = joMemberInfo["meter_mac_address"]! as! String
                CaApplication.m_Info.strMeterMaker = joMemberInfo["meter_maker"]! as! String
                CaApplication.m_Info.strMeterModel = joMemberInfo["meter_model"]! as! String
                CaApplication.m_Info.nMeterState = joMemberInfo["meter_state"]! as! Int
                CaApplication.m_Info.nMeterType = joMemberInfo["meter_type"]! as! Int
                CaApplication.m_Info.nMeterValidInstr = joMemberInfo["meter_valid_instr_integer"]! as! Int
                CaApplication.m_Info.dtMeterInstalled = joMemberInfo["time_meter_installed"] as? Date
                CaApplication.m_Info.dtPriceModified = joMemberInfo["time_price_modified"] as? Date
                CaApplication.m_Info.strPriceComment = joMemberInfo["price_comment"]! as! String
                CaApplication.m_Info.nDiscountFamily = joMemberInfo["discount_id_family"]! as! Int
                CaApplication.m_Info.nDiscountSocial = joMemberInfo["discount_id_social"]! as! Int
                CaApplication.m_Info.nMonthlyWonMethod = joMemberInfo["monthly_won_method"]! as! Int
                
                // Family List
                var familyList: Array<[String:Any]> = Array()
                
                if jo["family_list"] != nil {
                    familyList = jo["family_list"] as! Array<[String:Any]>
                }
                
                print("Login: Family count=" + String(familyList.count))
                
                CaApplication.m_Info.alFamily.removeAll()
                
                for family in familyList {
                    let ca_family:CaFamily = CaFamily()
                    
                    ca_family.nSeqMember = family["seq_member"]! as! Int
                    ca_family.bMain = family["main_member"]! as! Bool
                    ca_family.strName = family["member_name"]! as! String
                    ca_family.strPhone = family["member_phone"]! as! String
                    ca_family.dtLastLogin = family["time_last_login"] as! String
                    
                    if ca_family.nSeqMember == CaApplication.m_Info.nSeqMember {continue}
                    
                    CaApplication.m_Info.alFamily.append(ca_family)
                }
                
                // Price List
                var priceList: Array<[String:Any]> = Array()
                
                if jo["price_list"] != nil {
                    priceList = jo["price_list"] as! Array<[String:Any]>
                }
                
                CaApplication.m_Info.alPrice.removeAll()
                
                for price in priceList {
                    let ca_price:CaPrice = CaPrice()
                    
                    ca_price.nLevel = price["pTerm"]! as! Int
                    ca_price.nFrom = price["nFrom"]! as! Int
                    ca_price.nTo = price["nTo"]! as! Int
                    ca_price.dBase = price["pBasic"]! as! Double
                    ca_price.dHeight = price["fHeight"]! as! Double
                    ca_price.dRate = price["pValue"]! as! Double
                    ca_price.strInterval = price["Interval"]! as! String
                    
                    CaApplication.m_Info.alPrice.append(ca_price)
                }
                
                // Discount family List
                var discountFamilyList: Array<[String:Any]> = Array()
                
                if jo["discount_family_list"] != nil {
                    discountFamilyList = jo["discount_family_list"] as! Array<[String:Any]>
                }
                
                CaApplication.m_Info.alDiscountFamily.removeAll()
                
                for discount in discountFamilyList {
                    let ca_discount:CaDiscount = CaDiscount()
                    
                    ca_discount.nDiscountId = discount["discount_id"]! as! Int
                    ca_discount.strDiscountName = discount["discount_name"]! as! String
                    
                    CaApplication.m_Info.alDiscountFamily.append(ca_discount)
                }
                
                // Discount social List
                var discountSocialList: Array<[String:Any]> = Array()
                
                if jo["discount_social_list"] != nil {
                    discountSocialList = jo["discount_social_list"] as! Array<[String:Any]>
                }
                
                CaApplication.m_Info.alDiscountSocial.removeAll()
                
                for discount in discountSocialList {
                    let ca_discount:CaDiscount = CaDiscount()
                    
                    ca_discount.nDiscountId = discount["discount_id"]! as! Int
                    ca_discount.strDiscountName = discount["discount_name"]! as! String
                    
                    CaApplication.m_Info.alDiscountSocial.append(ca_discount)
                }
                
                // Alarm List
                
                CaApplication.m_Info.alAlarm.removeAll()
                
                if jo["alarm_list"] != nil {
                    CaApplication.m_Info.setAlarmList(jo["alarm_list"] as! Array<[String:Any]>)
                }
                
                // Notice List
                CaApplication.m_Info.alNotice.removeAll()
                
                if jo["notice_top_list"] != nil || jo["notice_list"] != nil {
                    CaApplication.m_Info.setNoticeList(jo["notice_top_list"] as! Array<[String:Any]>, jo["notice_list"] as! Array<[String:Any]>)
                }
                
                // QnA List
                
                CaApplication.m_Info.alQna.removeAll()
                
                if jo["qna_list"] != nil {
                    CaApplication.m_Info.setQnaList(jo["qna_list"] as! Array<[String:Any]>)
                }
                
                done(sender: self)
                
            break
                
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
    
    // 로그인 버튼 클릭
    @IBAction func onLoginButtonClicked(_ sender: UIButton) {
        
        if txtId.text == "" {
            alert(title: "Login Failed", message: "아이디를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        if txtPw.text == "" {
            alert(title: "Login Failed", message: "비밀번호를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        
        m_strId = txtId.text!
        m_strPw = txtPw.text!
        m_strDeviceId = CaApplication.m_Info.strPushId
        
        CaApplication.m_Engine.CheckLogin(self.m_strId, self.m_strPw, self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onChangePasswordBtnClicked(_ sender: UIButton) {
        print("Main: ChangePasswordButton Clicked")
        
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ChangePasswordViewController") //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onJoinBtnClicked(_ sender: UIButton) {
        
        print("Main: JoinButton Clicked")

        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SignUpCandidateViewController") //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
}
