//
//  AlarmPopUpViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/02/04.
//

import UIKit

class AlarmPopUpViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbAckResponse: UILabel!
    
    var strTitle = ""
    var strContent = ""
    var nAckResponse: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.text = strTitle
        lbContent.text = strContent
        
        switch (nAckResponse) {
        case 0:
            lbAckResponse.text = "승인 대기중"
            
        case 1:
            lbAckResponse.text = "승인함"
            
        case 2:
            lbAckResponse.text = "거절함"
            

        default:
            lbAckResponse.text = "미정"
        }
        

       
    }
 
    @IBAction func onConfirmBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
