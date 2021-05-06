//
//  SignUpCandidateViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/18.
//

import UIKit


class SignUpCandidateViewController: CustomUIViewController, UITextFieldDelegate {
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var dongTextField: UITextField!
    @IBOutlet weak var hoTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    var sitePickerView = UIPickerView()
    var dongPickerView = UIPickerView()
    var hoPickerView = UIPickerView()
    
    var alSite: Array<CaItem> = Array()
    var alDong: Array<CaItem> = Array()
    var alHo: Array<CaItem> = Array()
    
    var selectedSite: Int = 0
    var selectedDong: Int = 0
    
    var restoreFrameValue: CGFloat = 0.0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CaApplication.m_Info.nSeqAptHoSubscribing = 0
        
        
        
        siteTextField.inputView = sitePickerView
        dongTextField.inputView = dongPickerView
        hoTextField.inputView = hoPickerView
        
        siteTextField.placeholder = "단지 선택"
        dongTextField.placeholder = "동 선택"
        hoTextField.placeholder = "호 선택"
        
        sitePickerView.delegate = self
        sitePickerView.dataSource = self
        dongPickerView.delegate = self
        dongPickerView.dataSource = self
        hoPickerView.delegate = self
        hoPickerView.dataSource = self

        sitePickerView.tag = 1
        dongPickerView.tag = 2
        hoPickerView.tag = 3
        
        getSiteList(false)
        
        //textField keyboard problem
        nameTextField.delegate = self
        numberTextField.delegate = self
        siteTextField.delegate = self
        dongTextField.delegate = self
        hoTextField.delegate = self
        
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
    
    func getPhoneNumberAfterCheckPermission() {
        print("getPhoneNumberAfterCheckPermission called...")
        
    }

    //아파트 정보 불러오는 API 호출
    func getSiteList(_ bShowWaitDialog:Bool) {
        CaApplication.m_Engine.GetSiteList(bShowWaitDialog: bShowWaitDialog, self)
    }
    
    func getAptDongList(_ nSeqSite: Int, _ bShowWaitDialog:Bool) {
        CaApplication.m_Engine.GetAptDongList(nSeqSite, bShowWaitDialog, self)
    }
    
    func getAptHoList( _ nSeqSite: Int, _ nSeqDong: Int, _ bShowWaitDialog:Bool) {
        CaApplication.m_Engine.GetAptHoList(nSeqSite, nSeqDong, bShowWaitDialog, self)
    }
    
    //동의서 작성한 세대 대표 회원 가입 정보 확인
    func getMemberCandidateInfo(_ bShowWaitDialog:Bool){
        CaApplication.m_Engine.GetMemberCandidateInfo(CaApplication.m_Info.nSeqAptHoSubscribing, CaApplication.m_Info.strMemberNameSubscribing, CaApplication.m_Info.strPhoneSubscribing, bShowWaitDialog, self)
    }
    
    
    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        
            case m_GlobalEngine.EG_GET_SITE_LIST:
                let jo:[String:Any] = Result.JSONResult
                
                var siteList: Array<[String:Any]> = Array()
                
                if jo["site_list"] != nil {
                    siteList = jo["site_list"] as! Array<[String:Any]>
                }
                
                for site in siteList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = site["seq_site"]! as! Int
                    
                    item.strName = site["name"]! as! String
                    
                    alSite.append(item)
                }
                

            case m_GlobalEngine.EG_GET_APT_DONG_LIST:
                let jo:[String:Any] = Result.JSONResult
                
                var dongList: Array<[String:Any]> = Array()
                
                if jo["dong_list"] != nil {
                    dongList = jo["dong_list"] as! Array<[String:Any]>
                }
                //초기화 작업
                alDong.removeAll()
                
                for dong in dongList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = dong["seq_dong"]! as! Int
                    
                    item.strName = dong["dong_name"]! as! String
                    
                    alDong.append(item)
                }
                
                
            case m_GlobalEngine.EG_GET_APT_HO_LIST:
                let jo:[String:Any] = Result.JSONResult
                var hoList: Array<[String:Any]> = Array()
                
                if jo["ho_list"] != nil {
                    hoList = jo["ho_list"] as! Array<[String:Any]>
                }
                
                alHo.removeAll()
                
                for ho in hoList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = ho["seq_ho"]! as! Int
                    
                    item.strName = ho["ho_name"]! as! String
                    
                    alHo.append(item)
                }
            case m_GlobalEngine.EG_GET_MEMBER_CANDIDATE_INFO:
                
                let jo:[String:Any] = Result.JSONResult
                var bCandidate: Int = 0
                var nHoState: Int = 0
                bCandidate = jo["is_candidate"] as! Int
                nHoState = jo["ho_state"] as! Int
                
                if bCandidate == 1 {
                    if nHoState == 1 {
                        print("동의서에 명시된 세대 대표이며 아직 미등록 상태")
                        CaApplication.m_Info.bSubscribingAsMainMember = true
                        CaApplication.m_Info.nAuthType = CaApplication.m_Engine.AUTH_TYPE_SUBSCRIBE
                       
                        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AuthViewController") //as? ChangePasswordViewController
                        view.modalPresentationStyle = .fullScreen
                        self.present(view, animated: true, completion: nil)
                        
                        
                    }
                    else if nHoState == 2 {
                        print("동일 정보로 이미 등록됨. 로그인 창으로.")
                        CaApplication.m_Info.strMessage = "세대 대표로 이미 등록되어 있습니다. 로그인하세요."
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                        
                        // 팝업창 뜨면서 세대 대표로 이미 등록되어 있습니다. 로그인하세요.
                    }
                    else if nHoState == 3 {
                        print("다른 분이 세대 대표로 이미 등록되어 잇음. 관리실 문의")
                        CaApplication.m_Info.strMessage = "다른 분이 세대 대표로 이미 등록되어 있습니다. 관리실에 문의하세요."
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                    }
                    else {
                        print("unknown nHostate" + String(nHoState))
                    }
                    
                }
                else {
                    if nHoState == 1{
                        print("세대 대표 먼저 등록해야함")
                        CaApplication.m_Info.strMessage = "세대 대표자의 가입 이후에 가입하시기 바랍니다."
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                        // 팝업
                    }
                    else if nHoState == 3{
                        print("세대원으로 가입 진행")
                        CaApplication.m_Info.bSubscribingAsMainMember = false
                        CaApplication.m_Info.nAuthType = CaApplication.m_Engine.AUTH_TYPE_SUBSCRIBE
                        
                        CaApplication.m_Info.strMessage = "본인인증을 하고 세대원으로 가입하시겠습니까?"
                        
                        CaApplication.m_Info.strStoryBoardName = "Auth"
                      
                        CaApplication.m_Info.strViewControllerName = "AuthViewController"
                        
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01YNPopUpViewController")
                        
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
             
                        
                    }
                }
                
                
            default:
                print("Default!")
        }
    }
    
    
    @IBAction func OnBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //회원가입 버튼을 눌렀을 때
    @IBAction func OnStartAuthBtnClicked(_ sender: UIButton) {
        print("Start Auth Button Clicked")
        
        CaApplication.m_Info.strMemberNameSubscribing = nameTextField.text!
        CaApplication.m_Info.strPhoneSubscribing = numberTextField.text!
        
        var strMessage: String = ""
        
        if CaApplication.m_Info.nSeqAptHoSubscribing == 0 {
            //alert(title: "본인인증 실패", message: "거주하는 아파트의 동과 호를 선택해주세요.", text: "확인")
            strMessage = "거주하는 아파트의 동과 호를 선택해주세요."
            
        }
        else if nameTextField.text == "" {
            //alert(title: "본인인증 실패", message: "이름을 입력해주세요.", text: "확인")
            strMessage = "이름을 입력해주세요."
        }
        else if numberTextField.text == "" {
            //alert(title: "본인인증 실패", message: "휴대폰 번호를 입력해주세요.", text: "확인")
            strMessage = "휴대폰 번호를 입력해주세요."
        }
        
        if strMessage == "" {
            getMemberCandidateInfo(false)
        }
        else {
            CaApplication.m_Info.strMessage = strMessage
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController") //as? ChangePasswordViewController
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: true, completion: nil)
            //팝업창에 strMessage 띄우기
        }
        
    }
}

extension SignUpCandidateViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            
            return alSite.count
        case 2:
            return alDong.count
        case 3:
            return alHo.count
        default:
            return 1
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        
        case 1:
            let item = alSite[row]
            return item.strName
            
        case 2:
            // 동이 존재하지 않는 단지가 존재
            if !alDong.isEmpty{
            let item = alDong[row]
            
                return item.strName}
            else {
                
                //dongTextField.text = ""
                //hoTextField.text = ""
                return "none"
            }
    
        case 3:
            if !alHo.isEmpty && !alDong.isEmpty{
            let item = alHo[row]
                return item.strName}
            else {
                //hoTextField.text = ""
                return "none"
            }
            
        default:
            return "Data not found"
    }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let item = alSite[row]
            
            selectedSite = item.nSeq
           
            
            // to prevent mismatch on submission
            CaApplication.m_Info.nSeqAptHoSubscribing = 0

            getAptDongList(selectedSite, false)
            
            siteTextField.text = item.strName
            siteTextField.resignFirstResponder()
            CaApplication.m_Info.strSiteName = item.strName
            
            
        case 2:
            if !alDong.isEmpty{
                let item = alDong[row]
                
                selectedDong = item.nSeq
                
                // to prevent mismatch on submission
                CaApplication.m_Info.nSeqAptHoSubscribing = 0
                getAptHoList(selectedSite, selectedDong, false)
                
                dongTextField.text = item.strName
                dongTextField.resignFirstResponder()
                CaApplication.m_Info.strAptDongName = item.strName
            }
            else {
                alHo.removeAll()
                dongTextField.text = ""
                dongTextField.resignFirstResponder()}
                
        case 3:
            if !alHo.isEmpty && !alDong.isEmpty{
                let item = alHo[row]
                    
                CaApplication.m_Info.nSeqAptHoSubscribing = item.nSeq
                    
                hoTextField.text = item.strName
                hoTextField.resignFirstResponder()
                CaApplication.m_Info.strAptHoName = item.strName
                    
            }
            else {
                CaApplication.m_Info.nSeqAptHoSubscribing = 0
                hoTextField.text = ""
                hoTextField.resignFirstResponder()
                
            }
                
            
        default:
            print("Data Not found")
            
    }
}

}
