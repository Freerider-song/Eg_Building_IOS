//
//  SiteStateViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/02/05.
//

import UIKit

class SiteStateViewController: CustomUIViewController {

    //view 선언
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var transformerView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    //레이블 및 이미지 선언
    @IBOutlet weak var lbKwh: UILabel!
    @IBOutlet weak var lbDeltaKwh: UILabel!
    @IBOutlet weak var lbDeltaGas: UILabel!
    @IBOutlet weak var ivDeltaKwh: UIImageView!
    @IBOutlet weak var ivDeltaGas: UIImageView!
    @IBOutlet weak var lbTimeUpdate: UILabel!
    @IBOutlet weak var ivTransState: UIImageView!
    @IBOutlet weak var lbTransState: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondView.layer.cornerRadius = 10
        transformerView.layer.cornerRadius = 10
        detailView.layer.cornerRadius = 10
        
        CaApplication.m_Engine.GetUsageCurrentOfOneSite(CaApplication.m_Info.nSeqSite, false, self)
    }
    
    func setDataEtc(_ strTimeUpdate: String, _ dKwhMonthCurrYear: Double, _ dKwhMonthPrevYear: Double, _ nTransState: Int){
        
        lbKwh.text = String(format: "%.1f", dKwhMonthCurrYear)
        
        var dDeltaKwh: Double = 0.0
        if dKwhMonthPrevYear == 0.0 {dDeltaKwh = 0.0}
        else {dDeltaKwh = (dKwhMonthCurrYear - dKwhMonthPrevYear)/dKwhMonthPrevYear}
        
        let dDeltaGas: Double = dDeltaKwh * CaApplication.m_Info.KWH_TO_GAS
        
        lbDeltaKwh.text = String(format: "%.1f", dDeltaKwh.magnitude)
        lbDeltaGas.text = String(format: "%.1f", dDeltaGas.magnitude)
        
        if dDeltaKwh > 0 {
            ivDeltaKwh.image = UIImage(named: "arrow_up.png")
            ivDeltaGas.image = UIImage(named: "arrow_up.png")
        }
        else if dDeltaKwh < 0 {
            ivDeltaKwh.image = UIImage(named: "arrow_down.png")
            ivDeltaGas.image = UIImage(named: "arrow_down.png")
        }
        else {
            ivDeltaKwh.image = UIImage(named: "circle_cyan_light.png")
            ivDeltaGas.image = UIImage(named: "circle_cyan_light.png")
        }
        
        let dtTimeUpdate: Date = CaApplication.m_Info.dfStd.date(from: strTimeUpdate)!
        lbTimeUpdate.text = CaApplication.m_Info.dfyyyyMMddHHmmStd.string(from: dtTimeUpdate)
        
        
    }
    
    func setTransState(_ nTransState: Int){
        switch nTransState {
        case 0:
            ivTransState.image = UIImage(named: "trans_normal.png")
            lbTransState.text = "우리 아파트의 변압기 온도와 상태가 안정적입니다"
        case 1:
            ivTransState.image = UIImage(named: "trans_warning.png")
            lbTransState.text = "현재 우리 아파트의 전기 사용이 많아서 주의가 필요합니다"
        case 2:
            ivTransState.image = UIImage(named: "trans_danger.png")
            lbTransState.text = "현재 우리 아파트의 전기 사용이 과도하여 변압기 상태가 위험합니다"
        default:
            ivTransState.image = UIImage(named: "trans_unknown.png")
            lbTransState.text = "우리 아파트의 변압기 상태 정보가 수집되지 않고 있어 확인중입니다"
        }
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            case m_GlobalEngine.EG_GET_USAGE_CURRENT_OF_ONE_SITE:
                
                print("Result of GetUsageCurrentofOneSite Received...")
                let jo:[String:Any] = Result.JSONResult
                
                let strTimeUpdate = jo["time_curr"]! as! String
                
                //let dKwhFromYear = jo["site_kwh_from_year"] as! Double
                let dKwhFromMonth = jo["site_kwh_from_month"] as! Double
                //let dKwhFromWeek = jo["site_kwh_from_week"] as! Double
                //let dKwhFromDay = jo["site_kwh_from_day"] as! Double
                
                //let dKwhFromYearPrevYear = jo["site_kwh_from_year_prev_year"] as! Double
                let dKwhFromMonthPrevYear = jo["site_kwh_from_month_prev_year"] as! Double
                //let dKwhFromWeekPrevYear = jo["site_kwh_from_week_prev_year"] as! Double
                //let dKwhFromDayPrevYear = jo["site_kwh_from_day_prev_year"] as! Double
                
                var nTransState: Int = -1
                
                let jaTrans: Array<[String:Any]> = jo["trans_list"] as! Array<[String:Any]>
                for i in 0...jaTrans.count - 1 {
                    let joTrans = jaTrans[i]
                    let nTransStateCurr = joTrans["trans_state"] as! Int
                    if (nTransStateCurr > nTransState) {nTransState = nTransStateCurr}
                }
                setDataEtc(strTimeUpdate, dKwhFromMonth, dKwhFromMonthPrevYear, nTransState)
                setTransState(nTransState)
                
                
            
            default:
                print("Unknown type result received : \(Result.callback)")
        }
    }
    @IBAction func onRefreshBtnClicked(_ sender: UIButton) {
        
        let date = Date()
        
        let strFrom: String = CaApplication.m_Info.dfyyyyMM.string(from: date) + "01"
        let strTo: String = CaApplication.m_Info.dfyyyyMMddHHmm.string(from: date)
        
        CaApplication.m_Engine.GetUsageOfOneMeter(CaApplication.m_Info.nSeqSite, CaApplication.m_Info.nSeqMeter, strFrom, strTo, true, self)
        
    }
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
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
