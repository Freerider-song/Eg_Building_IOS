//
//  NoticeListViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/06.
//

import UIKit


//table view cell에 대한 클래스


class NoticeCell: UITableViewCell {
    @IBOutlet weak var noticeImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTimeCreated: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet var roundView: UIView!
    
}

class NoticeListViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var secondView: UIView!
    
    // 추가 공지사항 데이터
    var dataArray:Array<[String:Any]> = []
    
    //image 지정
    let noticeSite = UIImage(named: "notice_site.png")
    let noticeEg = UIImage(named: "notice_eg.png")

    
    
    var dtCreatedMax = Int(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!))
 
    var fetchingMore = false
    

    
    //let alNotice = CaApplication.m_Info.alNotice
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10 //set corner radius here
       
    }
    
    //색션의 row 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApplication.m_Info.alNotice.count
    }
    
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        
        let notice = CaApplication.m_Info.alNotice[indexPath.row]
        
        myCell.lblTitle?.text = notice.strTitle
        myCell.lblTimeCreated.text = notice.dtCreated
    
    
        if notice.nNoticeType == 1 || notice.nNoticeType == 3 {
            myCell.noticeImage.image = noticeSite
        }
        else {
            myCell.noticeImage.image = noticeEg
        }
       
        if notice.bRead {
            myCell.newImage.isHidden = true
        }
        else {
            myCell.newImage.isHidden = false
        }
        
        
        //코너 둥글게
        myCell.contentView.backgroundColor = UIColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        
        myCell.layer.backgroundColor = CGColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        
        myCell.roundView.layer.cornerRadius = 20
        
        //상단 고정 공지사항 테두리 EG_DarkYellow, 입력된 bTop에 오류 존재 
        
        if notice.bTop == true {
            myCell.roundView.layer.borderWidth = 3
            myCell.roundView.layer.borderColor = CGColor(red: 244/255, green: 195/255, blue: 34/255, alpha: 1)
        }
        else {myCell.roundView.layer.borderWidth = 0}
            
        
        return myCell
    }
    
    //셀 선택했을시 notice로 넘어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
    
        let storyboard = UIStoryboard(name: "Notice", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "NoticeViewController") as? NoticeViewController
        
        let notice = CaApplication.m_Info.alNotice[indexPath.row]
        
        
        // CaInfo에 있는 정보까지 수정이 되는 건지는 모르겠다. check필요
        notice.bRead = true
        notice.bReadStateChanged = true
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        notice.dtRead = dateFormatter.string(from: now)
        setNoticeReadStateToDb()
        tableView.reloadData()
      
        
        
        //noticeViewController로 정보 전달
        
        view?.strTitle = notice.strTitle
        view?.strContent = notice.strContent //
        view?.nNoticeType = notice.nNoticeType
        view?.dtCreated = notice.dtCreated
        
        //화면전환
        
        view?.modalPresentationStyle = .fullScreen
        self.present(view!, animated: true, completion: nil)
        
    }
    //추가 데이터 로드
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
        {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = tableView.contentSize.height - 1
            
            if offsetY > contentHeight - scrollView.frame.height
            {
                if !fetchingMore
                {   print("fetch more")
                    fetchingMore = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        //var dtCreatedMax = Int(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!))
                                                    self.getNoticeList(Int(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!))!, 10, false)
                        if self.dataArray.isEmpty {
                            self.fetchingMore = true
                        }
                        self.fetchingMore = false
                        self.tableView.reloadData()
                        self.lblTotal.text = "*총 " + String(CaApplication.m_Info.alNotice.count) + " 건"
                    })
                        
                    }
                    
            }
  
        }
    
    
   
    
    func viewSetting() {
        print("Main: View Setting")
       
        lblTotal.text = "*총 " + String(CaApplication.m_Info.alNotice.count) + " 건"
        
    }
    
    func setNoticeReadStateToDb() {
        let strSeqNoticeList = CaApplication.m_Info.getNoticeReadListString()
        
        if strSeqNoticeList.isEmpty {return}
        else {
            CaApplication.m_Engine.SetNoticeListAsRead(CaApplication.m_Info.nSeqMember, strSeqNoticeList, false, self)
        }
    }

    
        //추가 공지사항 불러오는 API 호출
        func getNoticeList(_ timeCreatedMax: Int, _ countNotice: Int, _ bShowWaitDialog:Bool) {
            CaApplication.m_Engine.GetNoticeList(CaApplication.m_Info.nSeqMember, timeCreatedMax, countNotice, bShowWaitDialog, self)
        }
        
        // API 결과 도착했을 시 호출됨
        override func onResult(_ Result: CaResult) {
            switch Result.callback {
                case m_GlobalEngine.EG_GET_NOTICE_LIST:
                    let jo:[String:Any] = Result.JSONResult
                    
                    dataArray = jo["notice_list"] as! Array<[String:Any]>
                    
            
                    
                    // Notice List
                    if jo["notice_top_list"] != nil || jo["notice_list"] != nil {
                        CaApplication.m_Info.setNoticeList(jo["notice_top_list"] as! Array<[String:Any]>, jo["notice_list"] as! Array<[String:Any]>)
                        
                    }
                    print("Result has arrived...")
                case m_GlobalEngine.EG_SET_NOTICE_LIST_AS_READ:
                    print("Result of SetNoticeListAsRead Received...")
                    
                default:
                    print("Default!")
            }
        }

   
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        setNoticeReadStateToDb()
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func onAlarmBtnClicked(_ sender: UIButton) {
        
    
        print("alarm button clicked...")
        
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
}
