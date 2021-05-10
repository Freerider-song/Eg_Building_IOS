//
//  SettingViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/10.
//

import UIKit

class SettingViewController: CustomUIViewController, UISearchTextFieldDelegate {

    @IBOutlet weak var txtThresholdKwh: UITextField!
    @IBOutlet weak var txtThresholdWon: UITextField!
    @IBOutlet weak var txtAlarmUsageAtTime: UITextField!
    @IBOutlet weak var btnAlarmAll: UIButton!
    @IBOutlet weak var btnAlarmKwh: UIButton!
    @IBOutlet weak var btnAlarmWon: UIButton!
    @IBOutlet weak var btnAlarmUsageAtTime: UIButton!
    @IBOutlet weak var btnAlarmKwhRef: UIButton!
    @IBOutlet weak var btnAlarmKwhPlan: UIButton!
    
    @IBOutlet weak var lbSiteName: UILabel!
    @IBOutlet weak var lbCompletionDay: UILabel!
    @IBOutlet weak var lbSiteFloor: UILabel!
    @IBOutlet weak var lbSiteAddress: UILabel!
    @IBOutlet weak var lbHomePage: UILabel!
    
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbChangePassword: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    
    //pickerview 선언
    
    var reportPickerView = UIPickerView()
    
    let usageReportTimeList = ["매일 00시", "매일 01시", "매일 02시", "매일 03시", "매일 04시", "매일 05시", "매일 06시", "매일 07시", "매일 08시", "매일 09시", "매일 10시", "매일 11시", "매일 12시", "매일 13시", "매일 14시", "매일 15시", "매일 16시", "매일 17시", "매일 18시", "매일 19시", "매일 20시", "매일 21시", "매일 22시", "매일 23시"]

    var usageTime: String = ""
    
    // cainfo에 있는 정보 local로 호출
    var bAlarmAll = CaApplication.m_Info.m_bNotiAll
    var bAlarmKwh = CaApplication.m_Info.m_bNotiKwh
    var bAlarmWon = CaApplication.m_Info.m_bNotiWon
    var bAlarmKwhRef = CaApplication.m_Info.m_bNotiSavingStandard
    var bAlarmKwhPlan = CaApplication.m_Info.m_bNotiSavingGoal
    var bAlarmUsageAtTime = CaApplication.m_Info.m_bNotiUsageAtTime
    
   
    
    var dThresholdKwh = CaApplication.m_Info.m_dThresholdThisMonthKwh
    var dThresholdWon = CaApplication.m_Info.m_dThresholdThisMonthWon
    
    var nNotiHour = CaApplication.m_Info.m_nHourNotiThisMonthUsage
    
    var bFinishWhenChangeSaved: Bool = false
    
    //keyboard
    var restoreFrameValue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAlarmInfo()
        
        txtThresholdKwh.text = String(format: "%.1f", dThresholdKwh)
        //txtUsageFee.text = CaApplication.m_Info.decimal(value: dThresholdWon)
        txtThresholdWon.text = String(dThresholdWon)
        txtAlarmUsageAtTime.text = usageReportTimeList[nNotiHour]
        
        lbSiteName.text = CaApplication.m_Info.m_strSiteName
        lbCompletionDay.text = String(CaApplication.m_Info.m_nBuiltYear) + " - " + String(CaApplication.m_Info.m_nBuiltMonth)
        lbSiteFloor.text = CaApplication.m_Info.m_strFloorInfo
        lbSiteAddress.text = CaApplication.m_Info.m_strSiteAddress
        lbHomePage.text = CaApplication.m_Info.m_strHomePage
        
        lbId.text = CaApplication.m_Info.m_strAdminId
        lbChangePassword.text = CaApplication.m_Info.m_dtChangePassword
        lbName.text = CaApplication.m_Info.m_strAdminName
        lbPhone.text = CaApplication.m_Info.m_strAdminPhone
        
        
        
        
        
        txtThresholdWon.delegate = self
        txtThresholdKwh.delegate = self
        
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
    
    
    func setAlarmInfo() {
        
        if (bAlarmAll) {
            btnAlarmAll.setImage(UIImage(named: "check_yes.png"), for: .normal)
            
            if bAlarmKwh {
                btnAlarmKwh.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwh.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            if bAlarmWon {
                btnAlarmWon.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWon.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            if bAlarmKwhRef {
                btnAlarmKwhRef.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwhRef.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            if bAlarmKwhPlan {
                btnAlarmKwhPlan.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwhPlan.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            if bAlarmUsageAtTime {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            txtThresholdKwh.isUserInteractionEnabled = true
            txtThresholdWon.isUserInteractionEnabled = true
            
           
        }
        else {
            btnAlarmAll.setImage(UIImage(named: "check_no.png"), for: .normal)
            
            if bAlarmKwh {
                btnAlarmKwh.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwh.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            if bAlarmWon {
                btnAlarmWon.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWon.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            if bAlarmKwhRef {
                btnAlarmKwhRef.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwhRef.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            if bAlarmKwhPlan {
                btnAlarmKwhPlan.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmKwhPlan.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            if bAlarmUsageAtTime {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            txtThresholdKwh.isUserInteractionEnabled = false
            txtThresholdWon.isUserInteractionEnabled = false
       
        }
        
    }
    
   func isSettingChanged() -> Bool {
        if bAlarmAll != CaApplication.m_Info.m_bNotiAll {return true}
        if bAlarmKwh != CaApplication.m_Info.m_bNotiKwh {return true}
        if bAlarmWon != CaApplication.m_Info.m_bNotiWon {return true}
        if bAlarmKwhRef != CaApplication.m_Info.m_bNotiSavingStandard {return true}
        if bAlarmKwhPlan != CaApplication.m_Info.m_bNotiSavingGoal {return true}
        if bAlarmUsageAtTime != CaApplication.m_Info.m_bNotiUsageAtTime {return true}
     
        dThresholdKwh = Double(txtThresholdKwh.text!)!
        dThresholdWon = Double(txtThresholdWon.text!)!
    
        
        if dThresholdKwh - CaApplication.m_Info.m_dThresholdThisMonthKwh > 0.1 {return true}
        if dThresholdWon - CaApplication.m_Info.m_dThresholdThisMonthWon > 0.1 {return true}
        if nNotiHour != CaApplication.m_Info.m_nHourNotiThisMonthUsage {return true}
        
        return false
    
        
    }
    func requestChangeAdminBldSettings() {
        CaApplication.m_Engine.ChangeAdminBldSettings(CaApplication.m_Info.m_nSeqAdmin, bAlarmAll, bAlarmKwh, bAlarmWon, bAlarmUsageAtTime, bAlarmKwhRef, bAlarmKwhPlan, dThresholdKwh, dThresholdWon, nNotiHour, false, self)
       
    }
    
    func processSettingChange() {
        
        //yes or no alert이용하기로 결정
    
        let msg = UIAlertController(title: "확인", message: "변경한 설정값을 저장하시겠습니까?", preferredStyle: .alert)
                
                //Alert에 부여할 Yes이벤트 선언
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    requestChangeAdminBldSettings()
                })
                
                //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "아니요", style: .default, handler: { (action) -> Void in if self.bFinishWhenChangeSaved {self.dismiss(animated: true, completion: nil)}})
                
                
                //Alert에 이벤트 연결
                msg.addAction(YES)
                msg.addAction(NO)

                //Alert 호출
                self.present(msg, animated: true, completion: nil)
            }
    
    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.CB_CHANGE_ADMIN_BLD_SETTINGS:
                print("Result of ChangeAdminSettings received...")
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqSettings = jo["seq_settings_found"] as! Int
                
                if nSeqSettings == 0 {
                    
                    alert(title: "실패", message: "설정값 저장에 실패하였습니다.", text: "확인")
                }
                
                else {
                    CaApplication.m_Info.m_bNotiAll = bAlarmAll
                    CaApplication.m_Info.m_bNotiKwh = bAlarmKwh
                    CaApplication.m_Info.m_bNotiWon = bAlarmWon
                    CaApplication.m_Info.m_bNotiSavingStandard = bAlarmKwhRef
                    CaApplication.m_Info.m_bNotiSavingGoal = bAlarmKwhPlan
                   
        
                    CaApplication.m_Info.m_dThresholdThisMonthKwh = dThresholdKwh
                    CaApplication.m_Info.m_dThresholdThisMonthWon = dThresholdWon
               
                    CaApplication.m_Info.m_nHourNotiThisMonthUsage = nNotiHour
                    
                    //bFinishWhenChangeSave 이용하는 코드
                    
                    alert(title: "성공", message: "설정값 저장에 성공하였습니다.", text: "확인")
                }

            
            default:
                print("Default!")
        }
    }
    
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        
        print("back button clicked")
        
        if (isSettingChanged()) {
            bFinishWhenChangeSaved = true
            processSettingChange()
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onAlarmAll(_ sender: UIButton) {
        bAlarmAll = !bAlarmAll
        setAlarmInfo()
    }
    
    @IBAction func onAlarmKwh(_ sender: UIButton) {
        bAlarmKwh = !bAlarmKwh
        setAlarmInfo()
    }
    
    @IBAction func onAlarmWon(_ sender: UIButton) {
        bAlarmWon = !bAlarmWon
        setAlarmInfo()
    }
    
    @IBAction func onAlarmUsageAtTime(_ sender: UIButton) {
        bAlarmUsageAtTime = !bAlarmUsageAtTime
        setAlarmInfo()
    }
    @IBAction func onAlarmKwhRef(_ sender: Any) {
        bAlarmKwhRef = !bAlarmKwhRef
        setAlarmInfo()
    }
    @IBAction func onAlarmKwhPlan(_ sender: UIButton) {
        bAlarmKwhPlan = !bAlarmKwhPlan
        setAlarmInfo()
    }
    
    @IBAction func onChangePasswordBtn(_ sender: UIButton) {
        print("change password btn clicked...")
        
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        
        //데이터 전달
        let view = storyboard.instantiateViewController(identifier: "ChangePasswordInputViewController") as! ChangePasswordInputViewController
        view.modalPresentationStyle = .fullScreen
        view.strId = self.lbId.text!
        
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onLogoutBtn(_ sender: UIButton) {
        
        let msg = UIAlertController(title: "로그아웃", message: "로그아웃을 하시면, 로그인 정보가 초기화됩니다. 정말로 로그아웃 하시겠습니까?", preferredStyle: .alert)
                
                //Alert에 부여할 Yes이벤트 선언
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                })
                
                //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "아니요", style: .default, handler: { (action) -> Void in
                                self.dismiss(animated: true, completion: nil)})
                
                
                //Alert에 이벤트 연결
                msg.addAction(YES)
                msg.addAction(NO)

                //Alert 호출
                self.present(msg, animated: true, completion: nil)
    }
}

extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usageReportTimeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usageReportTimeList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nNotiHour = row
    }
    
}
