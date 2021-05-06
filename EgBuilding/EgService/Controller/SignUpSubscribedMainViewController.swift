//
//  SignUpSubscribedMainViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/20.
//

import UIKit

class SignUpSubscribedMainViewController: CustomUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func OnLogInBtnClicked(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    
    }
    
    
}
