//
//  ChangePasswordViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/18.
//

import UIKit

class ChangePasswordViewController: CustomUIViewController {
    @IBOutlet var btnAuth: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    @IBAction func OnCancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnAuthBtnClicked(_ sender: UIButton) {
        
        CaApplication.m_Info.nAuthType = CaApplication.m_Engine.AUTH_TYPE_CHANGE_PASSWORD
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AuthViewController") //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
        
        
    }
}
