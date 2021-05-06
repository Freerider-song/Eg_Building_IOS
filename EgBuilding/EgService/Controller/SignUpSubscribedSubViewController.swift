//
//  SignUpSubscribedSubViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/20.
//

import UIKit

class SignUpSubscribedSubViewController: CustomUIViewController {
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 20
        btnExit.layer.cornerRadius = 20
        
        lblInfo.text = "회원가입이 완료되었으며 [" + CaApplication.m_Info.strSiteName + " " + CaApplication.m_Info.strAptDongName + "동" + CaApplication.m_Info.strAptHoName + "호] 대표자님께 승인 요청을 보냈습니다. 대표자님게서 승인하신 후 로그인하시면 서비스를 이용하실 수 있습니다."
    
    }
    

  
    @IBAction func OnLogInButtonClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    //IOS에서는 홈으로 나가는 것을 프로그래밍적으로 구현하지 않기를 바람.
    @IBAction func OnExitBtnClicked(_ sender: UIButton) {
        
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
}
