//
//  NoticeListViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit

class NoticeCell: UITableViewCell {
 
    @IBOutlet weak var noticeImage: UIImageView!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet var roundView: UIView!
    @IBOutlet var lblTimeCreated: UILabel!
    @IBOutlet var lblWriter: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
}


class NoticeListViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var tableView: UITableView!
    
    //image 지정
    let noticeSite = UIImage(named: "notice_site.png")
    let noticeEg = UIImage(named: "notice_eg.png")
    // 추가 공지사항 데이터
    var dataArray:Array<[String:Any]> = []
    
    //var dtCreatedMax = CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!)
 
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        
        let date = Date()
        let getTime = CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: date)
        
        CaApplication.m_Info.m_alNotice.removeAll()
        CaApplication.m_Engine.GetBldNoticeList(CaApplication.m_Info.m_nSeqAdmin, getTime, 5, false, self)
        
        
      
        //let alNotice = CaApplication.m_Info.alNotice
      

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10 //set corner radius here
           
        }
        
        //색션의 row 갯수
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return CaApplication.m_Info.m_alNotice.count
        }
        
        
        //
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let myCell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
            
            let notice = CaApplication.m_Info.m_alNotice[indexPath.row]
            
            myCell.lblTitle?.text = notice.strTitle
            myCell.lblTimeCreated.text = notice.dtCreated
        
        
            if notice.nWriterType == 1 || notice.nWriterType == 3 {
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
            //myCell.contentView.backgroundColor = UIColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
            
            //myCell.layer.backgroundColor = CGColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
            
            myCell.roundView.layer.cornerRadius = 20
            
            //상단 고정 공지사항 테두리 EG_DarkYellow, 입력된 bTop에 오류 존재
            
            if notice.bTop == true {
                myCell.roundView.layer.borderWidth = 3
                myCell.roundView.layer.borderColor = CGColor(red: 244/255, green: 195/255, blue: 34/255, alpha: 1)
            }
            else {myCell.roundView.layer.borderWidth = 2
                myCell.roundView.layer.borderColor = CGColor.init(red: 0.51, green: 0.48, blue: 0.48, alpha: 1)}
                
            
            return myCell
        }
        
        //셀 선택했을시 notice로 넘어가기
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //선택된 셀 음영 제거
            tableView.deselectRow(at: indexPath, animated: true)
            
        
            let storyboard = UIStoryboard(name: "Notice", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "NoticeViewController") as? NoticeViewController
            
            let notice = CaApplication.m_Info.m_alNotice[indexPath.row]
            
            
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
            view?.nNoticeType = notice.nWriterType
            view?.dtCreated = notice.dtCreated
            
            //화면전환
            //팝업 형식으로
            view?.modalPresentationStyle = .overCurrentContext
            self.present(view!, animated: false, completion: nil)
            
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
                            self.getNoticeList(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!), 5, false)
                            if self.dataArray.isEmpty {
                                self.fetchingMore = true
                            }
                            self.fetchingMore = false
                            self.tableView.reloadData()
                            self.lblTotal.text = "*총 " + String(CaApplication.m_Info.m_alNotice.count) + " 건"
                        })
                            
                        }
                        
                }
      
            }
        
        
       
        
        func viewSetting() {
            print("Main: View Setting")
           
            lblTotal.text = "*총 " + String(CaApplication.m_Info.m_alNotice.count) + " 건"
            
            
        }
        
        func setNoticeReadStateToDb() {
            let strSeqNoticeList = CaApplication.m_Info.getNoticeReadListString()
            
            if strSeqNoticeList.isEmpty {return}
            else {
                CaApplication.m_Engine.SetBldNoticeListAsRead(CaApplication.m_Info.m_nSeqAdmin, strSeqNoticeList, false, self)
            }
        }

        
            //추가 공지사항 불러오는 API 호출
            func getNoticeList(_ timeCreatedMax: String, _ countNotice: Int, _ bShowWaitDialog:Bool) {
                
                CaApplication.m_Engine.GetBldNoticeList(CaApplication.m_Info.m_nSeqAdmin, timeCreatedMax, countNotice, bShowWaitDialog, self)
                //CaApplication.m_Engine.GetBldNoticeList(CaApplication.m_Info.m_nSeqAdmin, timeCreatedMax, countNotice, bShowWaitDialog, self)
            }
            
            // API 결과 도착했을 시 호출됨
            override func onResult(_ Result: CaResult) {
                switch Result.callback {
                case m_GlobalEngine.CB_GET_BLD_NOTICE_LIST:
                        let jo:[String:Any] = Result.JSONResult
                        
                        dataArray = jo["notice_list"] as! Array<[String:Any]>
                        
                
                        
                        // Notice List
                        if jo["notice_top_list"] != nil || jo["notice_list"] != nil {
                            CaApplication.m_Info.setNoticeList(jo["notice_top_list"] as! Array<[String:Any]>, jo["notice_list"] as! Array<[String:Any]>)
                            
                        }
                    
                    viewSetting()
                    tableView.reloadData()
                        print("Result has arrived...")
                    
                    
                    case m_GlobalEngine.CB_SET_BLD_NOTICE_AS_READ:
                        print("Result of SetNoticeListAsRead Received...")
                        
                    default:
                        print("Default!")
                }
            }

       
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        setNoticeReadStateToDb()
        self.dismiss(animated: true, completion: nil)
    }
    
    }

