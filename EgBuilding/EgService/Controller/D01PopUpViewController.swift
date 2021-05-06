//
//  D01PopUpViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/20.
//

import UIKit

class D01PopUpViewController: CustomUIViewController {
    @IBOutlet weak var strMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strMessage.text = CaApplication.m_Info.strMessage
        // Do any additional setup after loading the view.
    }
   
    @IBAction func OnConfirmBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
