//
//  D01YNPopUpViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/26.
//

import UIKit

class D01YNPopUpViewController: CustomUIViewController {

    @IBOutlet weak var strMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strMessage.text = CaApplication.m_Info.strMessage
        
    }
    @IBAction func OnYesBtnClicked(_ sender: UIButton) {
        CaApplication.m_Info.bYes = true
        print("strstoryboardname: \(CaApplication.m_Info.strStoryBoardName)")
        if CaApplication.m_Info.strStoryBoardName == ""{
        self.dismiss(animated: true, completion: nil)}
        else{
        let storyboard = UIStoryboard(name: CaApplication.m_Info.strStoryBoardName, bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: CaApplication.m_Info.strViewControllerName) //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)}
        
        CaApplication.m_Info.strStoryBoardName = ""
        CaApplication.m_Info.strViewControllerName = ""
    }
    
    @IBAction func OnNoBtnClicked(_ sender: UIButton) {
        CaApplication.m_Info.bYes = false
        self.dismiss(animated: true, completion: nil)
    }
}
