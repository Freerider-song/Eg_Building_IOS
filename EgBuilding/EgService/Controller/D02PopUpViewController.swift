//
//  D02PopUpViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/19.
//

import UIKit

class D02PopUpViewController: CustomUIViewController {
    @IBOutlet weak var strMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strMessage.text = CaApplication.m_Info.strMessage
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func OnConfirmBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
