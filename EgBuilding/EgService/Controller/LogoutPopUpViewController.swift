//
//  LogoutPopUpViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/02/03.
//

import UIKit

class LogoutPopUpViewController: CustomUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func OnYesBtnClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func OnNoBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
