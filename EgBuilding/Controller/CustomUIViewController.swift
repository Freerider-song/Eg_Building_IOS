//
//  CustomUIViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
//

import UIKit

class CustomUIViewController: UIViewController {

    var bKeyboardOn: Bool = false
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func viewPop(_ noti: Notification) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func onResult(_ Result: CaResult) {
        
    }
    
    func alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    
    func showPopUpConfirm(message : String) {
        CaApplication.m_Info.strMessage = message
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
        
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: true, completion: nil)
    }
    

}
