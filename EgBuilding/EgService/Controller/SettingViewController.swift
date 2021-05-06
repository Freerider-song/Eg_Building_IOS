//
//  SettingViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/02/01.
//

import UIKit


class UserCell: UITableViewCell {
    
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellPhone: UILabel!
    @IBOutlet weak var cellLoginDate: UILabel!
    @IBOutlet weak var cellCancelBtn: UIButton!

    
    @IBAction func onCancelBtnClicked(_ sender: UIButton) {
        let buttonTag = sender.tag
        print("tag is \(buttonTag)")
    }
}

class SettingViewController: CustomUIViewController, UITextFieldDelegate {

   //view 선언
    @IBOutlet weak var PIView: UIView!
    @IBOutlet weak var AlarmView: UIView!
    @IBOutlet weak var FeeView: UIView!
    @IBOutlet weak var AptView: UIView!
    @IBOutlet weak var UserTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //text, label, btn 선언
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblApt: UILabel!
    @IBOutlet weak var lblDong: UILabel!
    @IBOutlet weak var lblHo: UILabel!
    @IBOutlet weak var txtUsagekWh: UITextField!
    @IBOutlet weak var txtUsageFee: UITextField!
    @IBOutlet weak var txtNextGrade: UITextField!
    @IBOutlet weak var txtUsageReport: UITextField!
    @IBOutlet weak var txtDiscountFamily: UITextField!
    @IBOutlet weak var txtDiscountSocial: UITextField!
    @IBOutlet weak var lblReadDay: UILabel!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblReadPeriod: UILabel!
    
    @IBOutlet weak var btnAlarmAll: UIButton!
    @IBOutlet weak var btnAlarmKwh: UIButton!
    @IBOutlet weak var btnAlarmWon: UIButton!
    @IBOutlet weak var btnAlarmPriceLevel: UIButton!
    
    @IBOutlet weak var btnAlarmUsageAtTime: UIButton!
    
    //pickerview 선언
    
    var reportPickerView = UIPickerView()
    var discountFamilyPickerView = UIPickerView()
    var discountSocialPickerView = UIPickerView()
    let usageReportPeriodList = ["매일", "매주 일요일", "매주 월요일", "매달 1일", "매달 검침일"]
    let usageReportTimeList = ["0시", "1시", "2시", "3시", "4시", "5시", "6시", "7시", "8시", "9시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시", "19시", "20시", "21시", "22시", "23시"]
    var usagePeriod: String = ""
    var usageTime: String = ""
    
    // cainfo에 있는 정보 local로 호출
    var bAlarmAll = CaApplication.m_Info.bNotiAll
    var bAlarmKwh = CaApplication.m_Info.bNotiKwh
    var bAlarmWon = CaApplication.m_Info.bNotiWon
    var bAlarmPriceLevel = CaApplication.m_Info.bNotiPriceLevel
    var bAlarmUsageAtTime = CaApplication.m_Info.bNotiUsageAtTime
    
    var nDiscountFamily = CaApplication.m_Info.nDiscountFamily
    var nDiscountSocial = CaApplication.m_Info.nDiscountSocial
    
    var dThresholdKwh = CaApplication.m_Info.dThresholdKwh
    var dThresholdWon = CaApplication.m_Info.dThresholdWon
    var nNextPriceLevelPercent = CaApplication.m_Info.nNextPriceLevelPercent
    var nUsageNotiType = CaApplication.m_Info.nUsageNotiType
    var nUsageNotiHour = CaApplication.m_Info.nUsageNotiHour
    
    var bFinishWhenChangeSaved: Bool = false
    
    //keyboard
    var restoreFrameValue: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PIView.layer.cornerRadius = 10
        AlarmView.layer.cornerRadius = 10
        FeeView.layer.cornerRadius = 10
        AptView.layer.cornerRadius = 10
        UserTableView.layer.cornerRadius = 10
        
        //button 외관
        txtUsageReport.layer.borderColor = CGColor(red: 20, green: 118, blue: 156, alpha: 1)
        txtUsageReport.layer.borderWidth = 2
        txtUsageReport.layer.cornerRadius = 20
        
        // 개인정보
        lblID.text = CaApplication.m_Info.strMemberId
        //lblChangePassword.text = CaApplication.m_Info.dfyyyyMMddHHmmStd.string(from: (CaApplication.m_Info.dtChangePassword!))
        lblChangePassword.text = CaApplication.m_Info.dtChangePassword
        lblPhone.text = CaApplication.m_Info.strPhone
        lblName.text = CaApplication.m_Info.strMemberName
        lblApt.text = CaApplication.m_Info.strSiteName
        lblDong.text = CaApplication.m_Info.strAptDongName
        lblHo.text = CaApplication.m_Info.strAptHoName
        
        //알림설정
        txtUsagekWh.text = String(format: "%.1f", dThresholdKwh)
        //txtUsageFee.text = CaApplication.m_Info.decimal(value: dThresholdWon)
        txtUsageFee.text = String(dThresholdWon)
        txtNextGrade.text = String(nNextPriceLevelPercent)
        txtUsageReport.text = usageReportPeriodList[nUsageNotiType] + " " + usageReportTimeList[nUsageNotiHour]
        //btnAlarmAll.layer.zPosition = 999;

        setAlarmInfo()
        
        //우리 아파트 정보
        lblSiteName.text = CaApplication.m_Info.strSiteName
        lblReadDay.text = "매달  \(CaApplication.m_Info.nSiteReadDay)일"
        
        if (CaApplication.m_Info.nSiteReadDay==1){
            lblReadPeriod.text = "* 요금 계산 기간 : 지난달 1일 ~ 지난달 말일"
        }
        else {
            lblReadPeriod.text = "* 요금 계산 기간 : 지난달 \(CaApplication.m_Info.nSiteReadDay)일 ~ 이번달 \(CaApplication.m_Info.nSiteReadDay - 1) 일"
        }
        
        //pickerview
        
        txtDiscountFamily.text = CaApplication.m_Info.alDiscountFamily[nDiscountFamily].strDiscountName
        txtDiscountSocial.text = CaApplication.m_Info.alDiscountSocial[nDiscountSocial].strDiscountName
        
        txtDiscountSocial.inputView = discountSocialPickerView
        txtDiscountFamily.inputView = discountFamilyPickerView
        txtUsageReport.inputView = reportPickerView
        
        if !CaApplication.m_Info.bMainMember {
            txtDiscountFamily.inputView = nil
            txtDiscountSocial.inputView = nil
            txtDiscountSocial.isUserInteractionEnabled = false
            txtDiscountFamily.isUserInteractionEnabled = false
        }
        
        discountFamilyPickerView.delegate = self
        discountSocialPickerView.delegate = self
        reportPickerView.delegate = self
        
        reportPickerView.tag = 1
        discountFamilyPickerView.tag = 2
        discountSocialPickerView.tag = 3
        
        //tableView Setting
        
        UserTableView.delegate = self
        UserTableView.dataSource = self
        
        //keyboard problem
        
        txtUsagekWh.delegate = self
        txtUsageFee.delegate = self
        txtUsageReport.delegate = self
        txtNextGrade.delegate = self
        txtDiscountFamily.delegate = self
        txtDiscountSocial.delegate = self
        
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        
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
            if bAlarmPriceLevel {
                btnAlarmPriceLevel.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmPriceLevel.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            if bAlarmUsageAtTime {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            txtUsagekWh.isUserInteractionEnabled = true
            txtUsageFee.isUserInteractionEnabled = true
            txtUsageReport.isUserInteractionEnabled = true
            txtNextGrade.isUserInteractionEnabled = true
           
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
            if bAlarmPriceLevel {
                btnAlarmPriceLevel.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmPriceLevel.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            if bAlarmUsageAtTime {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageAtTime.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            txtUsagekWh.isUserInteractionEnabled = false
            txtUsageFee.isUserInteractionEnabled = false
            txtUsageReport.isUserInteractionEnabled = false
            txtNextGrade.isUserInteractionEnabled = false
        }
        
    }
    
   func isSettingChanged() -> Bool {
        if bAlarmAll != CaApplication.m_Info.bNotiAll {return true}
        if bAlarmKwh != CaApplication.m_Info.bNotiKwh {return true}
        if bAlarmWon != CaApplication.m_Info.bNotiWon {return true}
        if bAlarmPriceLevel != CaApplication.m_Info.bNotiPriceLevel {return true}
        if bAlarmUsageAtTime != CaApplication.m_Info.bNotiUsageAtTime {return true}
        
        if nDiscountFamily != CaApplication.m_Info.nDiscountFamily {return true}
        if nDiscountSocial != CaApplication.m_Info.nDiscountSocial {return true}
        
        dThresholdKwh = Double(txtUsagekWh.text!)!
        dThresholdWon = Double(txtUsageFee.text!)!
    
        
        if dThresholdKwh - CaApplication.m_Info.dThresholdKwh > 0.1 {return true}
        if dThresholdWon - CaApplication.m_Info.dThresholdWon > 0.1 {return true}
        if nNextPriceLevelPercent != CaApplication.m_Info.nNextPriceLevelPercent {return true}
        if nUsageNotiType != CaApplication.m_Info.nUsageNotiType {return true}
        if nUsageNotiHour != CaApplication.m_Info.nUsageNotiHour {return true}
        
        return false
    
        
    }
    
    func processSettingChange() {
        
        //yes or no alert이용하기로 결정
    
        let msg = UIAlertController(title: "확인", message: "변경한 설정값을 저장하시겠습니까?", preferredStyle: .alert)
                
                //Alert에 부여할 Yes이벤트 선언
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    self.requestChangeMemberSettings()
                })
                
                //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "아니요", style: .default, handler: { (action) -> Void in if self.bFinishWhenChangeSaved {self.dismiss(animated: true, completion: nil)}})
                
                
                //Alert에 이벤트 연결
                msg.addAction(YES)
                msg.addAction(NO)

                //Alert 호출
                self.present(msg, animated: true, completion: nil)
            }
    
    func requestChangeMemberSettings() {
        CaApplication.m_Engine.ChangeMemberSettings(CaApplication.m_Info.nSeqMember, bAlarmAll, bAlarmKwh, bAlarmWon, bAlarmPriceLevel, bAlarmUsageAtTime, nDiscountFamily, nDiscountSocial, dThresholdKwh, dThresholdWon, nNextPriceLevelPercent, nUsageNotiType, nUsageNotiHour, false, self)
    }
    
    func requestAckCancel(_ nSeqMemberSub: Int) {
        CaApplication.m_Engine.ResponseAckMember(nSeqMemberSub, 3, _bShowWaitDialog: false, self)
    }
    
    func processAckCancel(_ nSeqMemberSub: Int, _ strNameSub: String) {

        let msg = UIAlertController(title: "확인", message: "\(strNameSub)님의 승인을 철회하시겠습니까?", preferredStyle: .alert)
                
                //Alert에 부여할 Yes이벤트 선언
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    self.requestAckCancel(nSeqMemberSub)
                })
                
                //Alert에 부여할 No이벤트 선언
                let NO = UIAlertAction(title: "아니요", style: .cancel)
                
                
                //Alert에 이벤트 연결
                msg.addAction(YES)
                msg.addAction(NO)

                //Alert 호출
                self.present(msg, animated: true, completion: nil)
        
        
    }
    
    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.EG_CHANGE_MEMBER_SETTING:
                print("Result of ChangeMemberSettings received...")
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqMember = jo["seq_member"] as! Int
                
                if nSeqMember == 0 {
                    
                    CaApplication.m_Info.strMessage = "설정값 저장에 실패했습니다"
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                }
                
                else {
                    CaApplication.m_Info.bNotiAll = bAlarmAll
                    CaApplication.m_Info.bNotiKwh = bAlarmKwh
                    CaApplication.m_Info.bNotiWon = bAlarmWon
                    CaApplication.m_Info.bNotiPriceLevel = bAlarmPriceLevel
                    CaApplication.m_Info.bNotiUsageAtTime = bAlarmUsageAtTime
                    
                    CaApplication.m_Info.nDiscountFamily = nDiscountFamily
                    CaApplication.m_Info.nDiscountSocial = nDiscountSocial
                    
                    CaApplication.m_Info.dThresholdKwh = dThresholdKwh
                    CaApplication.m_Info.dThresholdWon = dThresholdWon
                    CaApplication.m_Info.nNextPriceLevelPercent = nNextPriceLevelPercent
                    CaApplication.m_Info.nUsageNotiType = nUsageNotiType
                    CaApplication.m_Info.nUsageNotiHour = nUsageNotiHour
                    
                    //bFinishWhenChangeSave 이용하는 코드
                    
                    CaApplication.m_Info.strMessage = "설정값 저장에 성공했습니다"
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                    
                }
            case m_GlobalEngine.EG_RESPONSE_ACK_MEMBER:
                print("Result of ResponseAckMember Received...")
                let jo:[String:Any] = Result.JSONResult
                
                let nResultCode = jo["result_code"] as! Int
                if nResultCode == 1 {
                    let nAckType = jo["ack_type"] as! Int// 1=승인 2=거절 3= 철회
                    
                    if nAckType == 3 {
                        let nSeqMemberSub = jo["seq_member_sub"] as! Int
                        
                        if CaApplication.m_Info.removeFamilyMember(nSeqMemberSub){
                            self.UserTableView.reloadData()
                        }
                    }
                }
            
            default:
                print("Default!")
        }
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
    
    @IBAction func OnBackBtnClicked(_ sender: UIButton) {
        print("back button clicked")
        
        if (isSettingChanged()) {
            bFinishWhenChangeSaved = true
            processSettingChange()
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    
    @IBAction func OnAlarmBtnClicked(_ sender: UIButton) {
        print("alarm button clicked...")
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func OnChangePasswordBtnClicked(_ sender: UIButton) {
        print("Change Password Button Clicked...")
        let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ChangePasswordViewController") //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func OnSaveBtnClicked(_ sender: UIButton) {
        print("Save buttonClicked...")
        print("save button clicked..")
        
       if (isSettingChanged()){
            bFinishWhenChangeSaved=false
            processSettingChange()
            
        }
        else {
            CaApplication.m_Info.strMessage = "변경된 설정값이 없습니다."
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func OnLogoutBtnClicked(_ sender: UIButton) {
        print("Logout Button Clicked...")
        
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LogoutPopUpViewController")
        view.modalPresentationStyle = .overFullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func OnAlarmAllBtnClicked(_ sender: UIButton) {
        print("total alarm buttton clicked")
        bAlarmAll = !bAlarmAll
        setAlarmInfo()
    }
    
    @IBAction func OnAlarmKwhBtnClicked(_ sender: UIButton) {
        print("kwh btn")
        bAlarmKwh = !bAlarmKwh
        setAlarmInfo()
    }
    
    @IBAction func OnAlarmWonBtnClicked(_ sender: UIButton) {
        print("won btn")
        bAlarmWon = !bAlarmWon
        setAlarmInfo()
    }
    
    @IBAction func OnAlarmPriceLevelBtnClicked(_ sender: UIButton) {
        print("price btn")
        bAlarmPriceLevel = !bAlarmPriceLevel
        setAlarmInfo()
    }
    
    @IBAction func OnAlarmUsageAtTimeBtnClicked(_ sender: UIButton) {
        print("usage butn")
        bAlarmUsageAtTime = !bAlarmUsageAtTime
        setAlarmInfo()
    }
    @IBAction func OnTotalAlarmBtnClicked(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        print("total alarm buttton clicked")
        bAlarmAll = !bAlarmAll
        setAlarmInfo()
    }
    @IBAction func OnUsagekWhBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bAlarmKwh = !bAlarmKwh
        setAlarmInfo()
    }
    @IBAction func OnUsageFeeBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bAlarmWon = !bAlarmWon
        setAlarmInfo()
    }
    @IBAction func OnGradeBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bAlarmPriceLevel = !bAlarmPriceLevel
        setAlarmInfo()
    }
    @IBAction func OnReportBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bAlarmUsageAtTime = !bAlarmUsageAtTime
        setAlarmInfo()
        
    }
    
}


//picker view 설정
extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            if component == 0 {
                return usageReportPeriodList.count
                    } else {
                        return usageReportTimeList.count
                    }
            
        case 2:
            return CaApplication.m_Info.alDiscountFamily.count
            
        case 3:
            return CaApplication.m_Info.alDiscountSocial.count
            
        default:
            return 1
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1:
            return 2
        
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        
        case 1:
            if component == 0 {
                        return usageReportPeriodList[row]
                    } else {
                        return usageReportTimeList[row]
                    }
            
        case 2:
            
            let family = CaApplication.m_Info.alDiscountFamily[row]
            return family.strDiscountName
    
        case 3:
            
            let social = CaApplication.m_Info.alDiscountSocial[row]
            return social.strDiscountName
            
        default:
            return "Data not found"
    }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            if component == 0 {
                usagePeriod = usageReportPeriodList[row]
                nUsageNotiType = row
                print("usagenotitype is \(nUsageNotiType)")
            } else {
                usageTime = usageReportTimeList[row]
                nUsageNotiHour = row
                txtUsageReport.text = usagePeriod + " " + usageTime
                txtUsageReport.resignFirstResponder()
            }
            
        case 2:
            let family = CaApplication.m_Info.alDiscountFamily[row]
            nDiscountFamily = row
            txtDiscountFamily.text = family.strDiscountName
                txtDiscountFamily.resignFirstResponder()
            
        
        case 3:
            let social = CaApplication.m_Info.alDiscountSocial[row]
            nDiscountSocial = row
            txtDiscountSocial.text = social.strDiscountName
                txtDiscountSocial.resignFirstResponder()
            
        default:
            print("Data Not found")
            
    }
}

}

//table view setting
extension SettingViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApplication.m_Info.alFamily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
       
        let User =
            CaApplication.m_Info.alFamily[indexPath.row]
        
        if User.dtLastLogin != "" {
        
        let dtTimeUpdate: Date = CaApplication.m_Info.dfStd.date(from: User.dtLastLogin)!
        myCell.cellLoginDate.text = CaApplication.m_Info.dfMMddHHmmss.string(from: dtTimeUpdate)
        }
        else {
            myCell.cellLoginDate.text = ""
        }
        
        

        myCell.cellName.text = User.strName
        myCell.cellPhone.text = User.strPhone
        myCell.cellCancelBtn.layer.cornerRadius = 10
        
        
        
        if !CaApplication.m_Info.bMainMember {
            myCell.cellCancelBtn.isHidden = true
        }
        

        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
        let User =
            CaApplication.m_Info.alFamily[indexPath.row]
        
        processAckCancel(User.nSeqMember, User.strName)

    }
    
}
