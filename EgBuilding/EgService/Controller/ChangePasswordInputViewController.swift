//
//  ChangePasswordInputViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/18.
//

import UIKit

class ChangePasswordInputViewController: CustomUIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtNewPw: UITextField!
    @IBOutlet weak var txtCheckPw: UITextField!
    
    let m_Pref: CaPref = CaPref()
    
    var restoreFrameValue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textField keyboard problem
        txtId.delegate = self
        txtNewPw.delegate = self
        txtCheckPw.delegate = self
        
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
    
    
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
            
            //이건 아이디 찾는건뎅
            case m_GlobalEngine.EG_CHANGE_PASSWORD:
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqMember: Int = jo["seq_member"] as! Int
                
                if nSeqMember == 0 {
                    
                    CaApplication.m_Info.strMessage = "비밀번호 변경에 실패했습니다"
                    let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D01PopUpViewController")
                    view.modalPresentationStyle = .overCurrentContext
                    self.present(view, animated: true, completion: nil)
                    
                }
                else{
                    
                    print("비밀번호 변경에 성공했습니다.")
                    
                    m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, txtNewPw.text!)
                    
                    //여기에도 팝업창 띄우고 확인 누르고 로그인 창으로 가는 과정 필요.
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                    
                }
                
            default:
                print("Default!")
        }
    }
    

    @IBAction func OnChangBtnClicked(_ sender: UIButton) {
        
        CaApplication.m_Info.strMessage = ""
        
        if txtId.text == ""{
            CaApplication.m_Info.strMessage = "아이디를 입력해주세요"
        }
        else if txtNewPw.text == "" || txtCheckPw.text == "" {
            CaApplication.m_Info.strMessage = "새 비밀번호와 확인 비밀번호를 모두 입력해주세요"
        }
        else if txtNewPw.text != txtCheckPw.text {
            CaApplication.m_Info.strMessage = "새 비밀번호와 확인 비밀번호가 서로 다릅니다. 다시 입력해주세요"
        }
        
        if CaApplication.m_Info.strMessage == "" {
            //changepassword api
            CaApplication.m_Engine.ChangePassword(CaApplication.m_Info.nSeqMemberChanging, txtNewPw.text!, false, self)
            
        }
        else {
            
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: true, completion: nil)
            
        }
    }
    
}
