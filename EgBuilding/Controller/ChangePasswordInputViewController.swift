//
//  ChangePasswordInputViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/23.
//

import UIKit

class ChangePasswordInputViewController: CustomUIViewController, UITextFieldDelegate{

    @IBOutlet var txtId: UITextField!
   
    @IBOutlet var txtPwNew: DesignableUITextField!
    @IBOutlet var txtPwConfirm: UITextField!
    
    var strId: String = ""
    
    //let m_Pref : CaPref = CaPref()
    
    
    
    var restoreFrameValue : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetting()

     
        txtId.delegate = self
        txtPwNew.delegate = self
        txtPwConfirm.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func viewSetting(){
        
        txtId.text = strId
        
        txtId.layer.cornerRadius = 25
        txtId.layer.borderWidth = 2
        txtId.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        txtPwNew.layer.cornerRadius = 25
        txtPwNew.layer.borderWidth = 2
        txtPwNew.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        txtPwConfirm.layer.cornerRadius = 25
        txtPwConfirm.layer.borderWidth = 2
        txtPwConfirm.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
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
    

    
    @IBAction func onBtnChangePwClicked(_ sender: UIButton) {
        if (txtPwNew.text == "" || txtPwConfirm.text == "") {
            alert(title: "Error", message: "새 비밀번호와 확인 비밀번호를 모두 입력해주세요", text: "확인")
        }
        
        else if txtPwNew.text != txtPwConfirm.text {
            alert(title: "Error", message: "새 비밀번호와 확인 비밀번호가 서로 다릅니다. 다시 입력해주세요", text: "확인")
           
        }
        
        else if txtId.text == "" {
            alert(title: "Error", message: "아이디를 입력해주세요", text: "확인")
            
        }
        
        else {
            CaApplication.m_Engine.ChangeAdminPassword(txtId.text!, txtPwNew.text!, false,self)
        }
    }
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case m_GlobalEngine.CB_CHANGE_ADMIN_PASSWORD:
            let jo:[String: Any] = Result.JSONResult
            let nSeqAdmin = jo["seq_admin"] as! Int
            
            if(nSeqAdmin == 0) {
                alert(title: "Error", message: "비밀번호 변경에 실패했습니다.", text: "확인")
            }
            
            else {
                let msg = UIAlertController(title: "성공", message: "비밀번호를 변경하였습니다. 로그인 화면으로 돌아갑니다.", preferredStyle: .alert)
                        
                        //Alert에 부여할 Yes이벤트 선언
                        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
                            
                            self.m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, "")
                            
                            let storyboard = UIStoryboard(name: "Login", bundle: nil)
                            
                            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                            view.modalPresentationStyle = .fullScreen
                            self.present(view, animated: true, completion: nil)
                            
                            
                        })
                        
                        //Alert에 이벤트 연결
                        msg.addAction(YES)
                       

                        //Alert 호출
                        self.present(msg, animated: true, completion: nil)
            }
        default:
            print("PasswordInput: Error!")
        }
    }
}
