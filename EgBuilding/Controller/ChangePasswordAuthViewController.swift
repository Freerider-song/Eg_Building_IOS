//
//  ChangePasswordAuthViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/23.
//

import UIKit

class ChangePasswordAuthViewController: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var txtId: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var txtAuthCode: UITextField!
    @IBOutlet var btnAuthCheck: UIButton!
    @IBOutlet var txtTimer: UILabel!
    
    var restoreFrameValue : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetting()
        // 키보드 입력
        txtId.delegate = self
        txtPhone.delegate = self
        txtAuthCode.delegate = self
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
    

    func viewSetting(){
        txtId.layer.cornerRadius = 25
        txtId.layer.borderWidth = 2.0
        txtId.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        
        txtPhone.layer.cornerRadius = 25
        txtPhone.layer.borderWidth = 2.0
        txtPhone.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        txtAuthCode.layer.cornerRadius = 25
        txtAuthCode.layer.borderWidth = 2.0
        txtAuthCode.layer.borderColor = CGColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        
        btnRequest.layer.cornerRadius = 15
        btnRequest.layer.masksToBounds = false
        
        btnAuthCheck.layer.cornerRadius = 15
        btnAuthCheck.layer.masksToBounds = false
    
        txtTimer.isHidden = true
        
    }
    
    var limitTime: Int = 180
    
    @objc func getSetTime(){
        secToTime(sec: limitTime)
        limitTime -= 1
    }
    
    func secToTime(sec: Int) {
        
        let minute = (sec % 3600) / 60
        let second = (sec % 3600 ) % 60
        
        if second < 10 {
            txtTimer.text = String(minute) + ":" + "0"+String(second)
        }
        else {
            txtTimer.text = String(minute) + ":" + String(second)
        }
        
        if limitTime != 0 {
            perform(#selector(getSetTime), with: nil, afterDelay:  1.0)
        }
        
        else if limitTime == 0 {
            txtTimer.isHidden = true
        }
    }
    
    @IBAction func onBtnBackClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnRequestClicked(_ sender: UIButton) {
        
        if (txtId.text == ""){
            alert(title: "Error", message: "아이디가 입력되지 않았습니다.", text: "확인")
            return
        }
        if txtPhone.text == "" {
            alert(title: "Error", message: "휴대폰 번호가 입력되지 않았습니다.", text: "확인")
            return
        }
        
        CaApplication.m_Engine.RequestAuthCode(txtId.text!, txtPhone.text!, false ,self)
        
    }
    
    @IBAction func onBtnCheckClicked(_ sender: Any) {
        
        CaApplication.m_Engine.CheckAuthCode(txtPhone.text!, txtAuthCode.text!, 180,false, self)
        
    }
    
    override func onResult(_ Result: CaResult) {
        switch  Result.callback {
        case m_GlobalEngine.CB_REQUEST_AUTH_CODE:
            let jo:[String: Any] = Result.JSONResult
            let nResultCode = jo["result_code"] as! Int
            
            if nResultCode == 1 {
                let msg = UIAlertController(title: "성공", message: "휴대폰으로 6자리 인증번호가 전송됩니다. 인증번호를 입력하신 후에 확인을 눌러주세요.", preferredStyle: .alert)
                        
                        //Alert에 부여할 Yes이벤트 선언
                        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
                            
                            self.txtTimer.isHidden = false
                            self.getSetTime()
                        })
                        
                        //Alert에 이벤트 연결
                        msg.addAction(YES)
                       

                        //Alert 호출
                        self.present(msg, animated: true, completion: nil)
            }
            else {
                alert(title: "실패", message: "문자인증에 실패했습니다. 정확한 번호로 다시 요청해주세요.", text: "확인")
                
                return
            }
            
            break
            
        case m_GlobalEngine.CB_CHECK_AUTH_CODE:
            
            let jo:[String: Any] = Result.JSONResult
            let nResultCode = jo["result_code"] as! Int
            
            if nResultCode == -2 {
                alert(title: "실패", message: "인증코드를 요청한 번호가 아닙니다. 처음부터 다시 진행해주세요", text: "확인")
                
                return
            }
            
            else if nResultCode == 0 {
                alert(title: "실패", message: "문자 인증번호가 잘못되었습니다. 다시 입력해주세요.", text: "확인")
                
                return
            }
            
            else if nResultCode == 1 {
                let msg = UIAlertController(title: "성공", message: "인증이 완료되었습니다. 다음 단계로 진행합니다.", preferredStyle: .alert)
                        
                        //Alert에 부여할 Yes이벤트 선언
                        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
                            
                            let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
                            
                            //데이터 전달
                            let view = storyboard.instantiateViewController(identifier: "ChangePasswordInputViewController") as! ChangePasswordInputViewController
                            view.modalPresentationStyle = .fullScreen
                            view.strId = self.txtId.text!
                            
                            self.present(view, animated: true, completion: nil)
                        })
                        
                        //Alert에 이벤트 연결
                        msg.addAction(YES)
                       

                        //Alert 호출
                        self.present(msg, animated: true, completion: nil)
            }
            
            else {
                alert(title: "실패", message: "시간이 초과되었습니다. 다시 시도해주세요.", text: " 확인")
            }
 
        default:
            print("PasswordAuth: Error!")
       
        }
    }
    
    
}
