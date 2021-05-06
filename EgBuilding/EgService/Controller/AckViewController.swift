//
//  AckViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/26.
//

import UIKit

class AckViewController: CustomUIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSend.layer.cornerRadius = 20
        btnExit.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        switch (CaApplication.m_Info.nAckResponseCodeLatest){
        case 0:
            if CaApplication.m_Info.nAckRequestTodayCount < 2 {
                lblMessage.text = "승인 대기중입니다. 승인 요청을 다시 보낼 수 있습니다."
            }
            else {
                lblMessage.text = "승인 대기중입니다. 오늘의 승인요청 횟수를 초과하여 다시 보내려면 내일 시도하십시오"
            }
        case 2:
            if CaApplication.m_Info.nAckRequestTodayCount < 2 {
                lblMessage.text = "승인이 거절되었습니다. 승인 요청을 다시 보낼 수 있습니다."
            }
            else {
                lblMessage.text = "승인이 거절되었습니다. 오늘의 승인요청 횟수를 초과하여 다시 보내려면 내일 시도하십시오"
            }
        case 3:
            if CaApplication.m_Info.nAckRequestTodayCount < 2 {
                lblMessage.text = "승인이 철회되었습니다. 승인 요청을 다시 보낼 수 있습니다."
            }
            else {
                lblMessage.text = "승인이 철회되었습니다. 오늘의 승인요청 횟수를 초과하여 다시 보내려면 내일 시도하십시오"
            }
        default:
            lblMessage.text = "앱을 사용하시려면 승인 요청을 보내서 세대 대표의 승인을 받아야 합니다"
        }
    }
    @IBAction func OnRequestBtnClicked(_ sender: UIButton) {
        CaApplication.m_Engine.RequestAckMember(CaApplication.m_Info.nSeqMember, false, self)
    }
    
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
    
            case m_GlobalEngine.EG_REQUEST_ACK_MEMBER:
                let jo:[String:Any] = Result.JSONResult
                
                let nAckRequestTodayCount: Int = jo["ack_request_today_count"] as! Int
        
                
                if nAckRequestTodayCount >= 2 {
                    
                    lblMessage.text = "승인 대기중입니다. 오늘의 승인요청 횟수를 초과하여 다시 보내려면 내일 시도하십시오"
                    
                }
                
            default:
                print("Unknown type result received")
        }
    }
    @IBAction func OnExitBtnClicked(_ sender: UIButton) {
        
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
}
