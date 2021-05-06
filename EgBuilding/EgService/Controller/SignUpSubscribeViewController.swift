//
//  SignUpSubscribeViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/20.
//

import UIKit

class SignUpSubscribeViewController: CustomUIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtNewPw: UITextField!
    @IBOutlet weak var txtCheckPw: UITextField!
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    
    var restoreFrameValue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //키보드 가림 문제 해결
        txtId.delegate = self
        txtNewPw.delegate = self
        txtCheckPw.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    

    // API 결과 도착했을 시 호출됨
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.EG_CREATE_MEMBER_MAIN:
                
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqMember: Int = jo["seq_member"] as! Int
                let nResultCode: Int = jo["result_code"] as! Int
                print("CreateMemberMain Result...")
                
                if nResultCode == 0 {
                    let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SignUpSubscribedMainViewController")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                }
                
                else if nResultCode == 1 {
                    CaApplication.m_Info.strMessage = "이미 존재하는 아이디입니다. 다른 아이디를 입력해주세요."
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                }
                
                else {
                    CaApplication.m_Info.strMessage = "계정 생성에 실패했습니다."
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                }
            case m_GlobalEngine.EG_CREATE_MEMBER_SUB:
                
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqMember: Int = jo["seq_member"] as! Int
                let nResultCode: Int = jo["result_code"] as! Int
                print("CreateMemberSub Result...")
                
                if nResultCode == 0 {
                    
                    CaApplication.m_Engine.RequestAckMember(nSeqMember, false, self)
                    
                    let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SignUpSubscribedSubViewController")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                }
                
                else if nResultCode == 1 {
                    CaApplication.m_Info.strMessage = "이미 존재하는 아이디입니다. 다른 아이디를 입력해주세요."
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                }
                
                else {
                    CaApplication.m_Info.strMessage = "계정 생성에 실패했습니다."
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                }
            case m_GlobalEngine.EG_REQUEST_ACK_MEMBER:
    
                print("Response of. equest Ack Member")
            
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
    
    
    //체크 박스 크
    @IBAction func OnBox1BtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func OnBox2BtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
    @IBAction func OnWeb1BtnClicked(_ sender: UIButton) {
        
        //에러
        CaApplication.m_Info.nWeb = 1
        
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "WebViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    @IBAction func OnWeb2BtnClicked(_ sender: UIButton) {
        
        CaApplication.m_Info.nWeb = 2
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "WebViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    @IBAction func OnNextBtnClicked(_ sender: UIButton) {
        //초기화
        CaApplication.m_Info.strMessage = ""
        
        if txtId.text == "" {
            CaApplication.m_Info.strMessage = "아이디를 입력해주세요"
        }
        else {
            if txtNewPw.text == "" || txtCheckPw.text == "" {
                CaApplication.m_Info.strMessage = "새 비밀번호와 확인 비밀번호를 모두 입력해주세요"
            }
            else {
                if txtNewPw.text != txtCheckPw.text {
                    CaApplication.m_Info.strMessage = "새 비밀번호와 확인 비밀번호가 서로 다릅니다. 다시 입력해주세요."
                }
                else {
                    if !Button1.isSelected || !Button2.isSelected {
                        CaApplication.m_Info.strMessage = "모든 약관에 동의해주세요"
                    }
                }
            }
        }
        
        if CaApplication.m_Info.strMessage == "" {
            if CaApplication.m_Info.bSubscribingAsMainMember {
                CaApplication.m_Engine.CreateMemberMain(CaApplication.m_Info.nSeqAptHoSubscribing, CaApplication.m_Info.strMemberNameSubscribing, CaApplication.m_Info.strPhoneSubscribing, txtId.text!, txtNewPw.text!, false, self)
                
            }
            else {
                CaApplication.m_Engine.CreateMemberSub(CaApplication.m_Info.nSeqAptHoSubscribing, CaApplication.m_Info.strMemberNameSubscribing, CaApplication.m_Info.strPhoneSubscribing, txtId.text!, txtNewPw.text!, false, self)
            }
        }
        else {
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: true, completion: nil)
        }
    }
    
}
