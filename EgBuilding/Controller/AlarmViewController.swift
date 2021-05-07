//
//  AlarmViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit


class AlarmCheckCell: UITableViewCell {
    @IBOutlet var btnCheckBox: UIButton!
    
}
class AlarmViewController: CustomUIViewController, UITableViewDelegate, UITableViewDataSource{
  

    @IBOutlet var lbMeter: UILabel!
    @IBOutlet var lbSavingTime: UILabel!
    @IBOutlet var lbKwhPlan: UILabel!
    @IBOutlet var tableView: UITableView!
    var nSeqPlanElem: Int = 0
    var plan: CaPlan = CaPlan()
    
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if nSeqPlanElem > 0 {
            for i in 0..<CaApplication.m_Info.m_alPlan.count {
                if CaApplication.m_Info.m_alPlan[i].nSeqPlanElem == nSeqPlanElem {
                    plan = CaApplication.m_Info.m_alPlan[i]
                    
                    lbMeter.text = plan.strMeterDescr
                    lbSavingTime.text = "절감 시간  " + String(plan.nHourFrom) + "시 ~ " + String(plan.nHourTo) + "시"
                    lbKwhPlan.text = "절감 목표  " + String(plan.nPercentToSave) + " %  ( " + String(format: "%.1f", plan.dKwhPlan) + " kWh )"
                    
                    
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plan.alAct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCheckCell", for: indexPath) as! AlarmCheckCell
        
        let act = plan.alAct[indexPath.row]
        let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
        
        
        Cell.btnCheckBox.setTitle(act.strActContent, for: .normal)
        
        var flag: Bool = false
    
        for i in 0..<act.alActHistory.count {
            let actHistory = act.alActHistory[i]
            let dtBegin: Date = CaApplication.m_Info.dfStd.date(from: actHistory.dtBegin)!
            let strBegin: String = CaApplication.m_Info.dfyyyyMMdd.string(from: dtBegin)
            if(today == strBegin){
                Cell.btnCheckBox.isSelected = true
                flag = true
                break
            }
        }
        if flag == false {
            Cell.btnCheckBox.isSelected = false
        }
        
        
        
        return Cell
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
        self.present(view!, animated: true, completion: nil)
        
    }
    
  
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onExecuteBtnClicked(_ sender: UIButton) {
    }
}
