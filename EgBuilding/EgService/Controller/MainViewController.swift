//
//  MainViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/23.
//

import UIKit

class MainViewController: CustomUIViewController {
    
    
    // Member Info
    @IBOutlet var lbSiteName: UILabel!
    @IBOutlet var lbDongHoName: UILabel!
    @IBOutlet var lbMemberName: UILabel!
    
    // Usage Info
    @IBOutlet var lbWon: UILabel!
    @IBOutlet var lbKwh: UILabel!
    @IBOutlet var ivDeltaWonPrevMonth: UIImageView!
    @IBOutlet var lbDeltaWonPrevMonth: UILabel!
    @IBOutlet var ivDeltaWonPrevYear: UIImageView!
    @IBOutlet var lbDeltaWonPrevYear: UILabel!
    @IBOutlet var lbWonExpected: UILabel!
    @IBOutlet var lbTimeUpdate: UILabel!
    @IBOutlet var btnRefresh: UIButton!
    
    @IBOutlet var lbPriceLevel: UILabel!
    @IBOutlet var lbDayNextPriceLevel: UILabel!
    @IBOutlet var lbKwhDaily: UILabel!
    @IBOutlet var ivTransformer: UIImageView!
    
    @IBOutlet var lbAlarmAll: UILabel!
    @IBOutlet var lbAlarmKwh: UILabel!
    @IBOutlet var lbAlarmWon: UILabel!
    @IBOutlet var lbAlarmPriceLevel: UILabel!
    @IBOutlet var lbUsageAtTime: UILabel!
    
    @IBOutlet var lbDiscountFamily: UILabel!
    @IBOutlet var lbDiscountSocial: UILabel!
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    //button
    @IBOutlet var btnTermsofUse: UIButton!
    @IBOutlet var btnPersonalInfomation: UIButton!
    
    //view
    @IBOutlet var totalView: UIView!
    @IBOutlet var gradeView: UIView!
    
    @IBOutlet var expectView: UIView!
    @IBOutlet var transformerView: UIView!
    
    @IBOutlet var averageView: UIView!
    @IBOutlet var totalAlarmView: UIView!
    @IBOutlet var discountView: UIView!
    
    // Image
    let arrowUp = UIImage(named: "arrow_up.png")
    let arrowDown = UIImage(named: "arrow_down.png")
    let circleCyanLight = UIImage(named: "circle_cyan_light.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("togdog Main viewDidLoad")
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 122/255, blue: 157/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("togdog Main viewWillAppear")
        
        if CaApplication.m_Info.isLogin {
            // 로그인 성공 시 View Setting
            viewSetting()
        } else {
            print("Main: View not Setting!")
        }
    }
    
    func viewSetting() {
        print("Main: View Setting")
        
        // 사용자 정보 세팅
        lbSiteName.text = CaApplication.m_Info.strSiteName
        lbDongHoName.text = "[" + CaApplication.m_Info.strAptDongName + "동 " + CaApplication.m_Info.strAptHoName + "호]"
        lbMemberName.text = CaApplication.m_Info.strMemberName + " 님"
        
        if CaApplication.m_Info.bNotiAll {
            lbAlarmAll.text = "전체 알림 (O)"
        }
        else {
            lbAlarmAll.text = "전체 알림 (X)"
        }
        
        lbDiscountFamily.text = CaApplication.m_Info.alDiscountFamily[CaApplication.m_Info.nDiscountFamily].strDiscountName
        lbDiscountSocial.text = CaApplication.m_Info.alDiscountSocial[CaApplication.m_Info.nDiscountSocial].strDiscountName
        
        
        
        let date = Date()
        
        // 정보 가져올 날짜
        let strFrom: String = CaApplication.m_Info.dfyyyyMM.string(from: date) + "01"
        let strTo: String = CaApplication.m_Info.dfyyyyMMddHHmm.string(from: date)
        
        // 정보 가져옴
        CaApplication.m_Engine.GetUsageOfOneMeter(CaApplication.m_Info.nSeqSite, CaApplication.m_Info.nSeqMeter, strFrom, strTo, false, self)
        
        // Design Settings
        
        btnTermsofUse.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        btnTermsofUse.layer.borderWidth = 2
        btnTermsofUse.layer.cornerRadius = 10
        
        btnPersonalInfomation.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        btnPersonalInfomation.layer.borderWidth = 2
        btnPersonalInfomation.layer.cornerRadius = 10
        totalView.layer.cornerRadius = 10
        gradeView.layer.cornerRadius = 10
        expectView.layer.cornerRadius = 10
        averageView.layer.cornerRadius = 10
        transformerView.layer.cornerRadius = 10
        totalAlarmView.layer.cornerRadius = 10
        discountView.layer.cornerRadius = 10
        
        
    }
    
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
            case m_GlobalEngine.EG_GET_USAGE_OF_ONE_METER:
                let jo:[String:Any] = Result.JSONResult
                
                let dWon: Double = jo["won_curr"]! as! Double
                lbWon.text = CaApplication.m_Info.decimal(value: Int(round(dWon)))
                
                let dKwh: Double = jo["kwh_curr"]! as! Double
                lbKwh.text = "[사용량 : " + CaApplication.m_Info.decimal(value: dKwh) + "KWh]"
                
                let strTimeUpdate: String = jo["to_curr"]! as! String
                let dtTimeUpdate: Date = CaApplication.m_Info.dfyyyyMMddHHmm.date(from: strTimeUpdate)!
                lbTimeUpdate.text = CaApplication.m_Info.dfyyyyMMddHHmmStd.string(from: dtTimeUpdate)
                
                let dWonExpected: Double = jo["won_expected"]! as! Double
                lbWonExpected.text = CaApplication.m_Info.decimal(value: Int(round(dWonExpected)))
                //lbWonExpected.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                
             
                let dWonPrevMonth: Double = jo["won_prev_month"]! as! Double
                let dWonprevYear: Double = jo["won_prev_year"]! as! Double
                
                setDeltaWonPrevMonth(dWon - dWonPrevMonth)
                setDeltaWonPrevYear(dWon - dWonprevYear)
                
                lbPriceLevel.text = "\(jo["price_level"] as! Int)구간"
                
                lbDayNextPriceLevel.text = jo["next_price_level_info"] as! String
                
                lbKwhDaily.text = String(format: "%.1f", jo["price_level"] as! Double)
                
                CaApplication.m_Info.nTransState = jo["trans_state"] as! Int
                
                switch (CaApplication.m_Info.nTransState) {
                    case 0:
                        ivTransformer.image = UIImage(named: "trans_normal.png")
                        
                    case 1:
                        ivTransformer.image = UIImage(named: "trans_warning.png")
                
                    case 2:
                        ivTransformer.image = UIImage(named: "trans_danger.png")
                    
                    default:
                        ivTransformer.image = UIImage(named: "trans_unknown.png")
                    }
                
                if CaApplication.m_Info.bNotiKwh {
                    
                    lbAlarmKwh.text = "사용량 [ \(CaApplication.m_Info.dThresholdKwh) kWh ] 도달시 (O)"
                }
                else {
                    lbAlarmKwh.text = "사용량 [ \(CaApplication.m_Info.dThresholdKwh) kWh ] 도달시 (X)"
                }
                
                if CaApplication.m_Info.bNotiWon {
                    
                    lbAlarmWon.text = "사용요금 [ \(CaApplication.m_Info.dThresholdWon) 원 ] 도달시 (O)"
                }
                else {
                    lbAlarmWon.text = "사용요금 [ \(CaApplication.m_Info.dThresholdWon) 원 ] 도달시 (X)"
                }
                
                if CaApplication.m_Info.bNotiPriceLevel {
                    
                    lbAlarmPriceLevel.text = "다음누진등급 [ \(CaApplication.m_Info.nNextPriceLevelPercent) % ] 도달시 (O)"
                }
                else {
                    lbAlarmPriceLevel.text = "다음누진등급 [ \(CaApplication.m_Info.nNextPriceLevelPercent) % ] 도달시 (X)"
                }
                
                lbUsageAtTime.text = "사용량 보고 [ \(CaApplication.m_Info.usageReportPeriodList[CaApplication.m_Info.nUsageNotiType] + " " +  CaApplication.m_Info.usageReportTimeList[CaApplication.m_Info.nUsageNotiHour]) ]"
                   
            default:
                print("Main: Error!")
        }
    }
    
    // 지난 달 대비 금액 설정
    func setDeltaWonPrevMonth(_ dDeltaWon: Double) {
        
        lbDeltaWonPrevMonth.text = CaApplication.m_Info.decimal(value: abs(Int(round(dDeltaWon))))
        
        if dDeltaWon>0 {
            ivDeltaWonPrevMonth.image = self.arrowUp
        } else if dDeltaWon<0 {
            ivDeltaWonPrevMonth.image = self.arrowDown
        } else {
            ivDeltaWonPrevMonth.image = self.circleCyanLight
        }
    }
    
    // 지난 년도 대비 금액 설정
    func setDeltaWonPrevYear(_ dDeltaWon: Double) {
        
        lbDeltaWonPrevYear.text = CaApplication.m_Info.decimal(value: abs(Int(round(dDeltaWon))))
        
        if dDeltaWon>0 {
            ivDeltaWonPrevYear.image = self.arrowUp
        } else if dDeltaWon<0 {
            ivDeltaWonPrevYear.image = self.arrowDown
        } else {
            ivDeltaWonPrevYear.image = self.circleCyanLight
        }
    }
    
    // 앱 종료, 추가 작업 필요
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    @IBAction func onAlarmBtnClicked(_ sender: UIButton) {
        
        print("alarm button clicked...")
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    // 새로고침 버튼 클릭
    @IBAction func onRefreshBtnClicked(_ sender: UIButton) {
        
        let date = Date()
        
        let strFrom: String = CaApplication.m_Info.dfyyyyMM.string(from: date) + "01"
        let strTo: String = CaApplication.m_Info.dfyyyyMMddHHmm.string(from: date)
        
        CaApplication.m_Engine.GetUsageOfOneMeter(CaApplication.m_Info.nSeqSite, CaApplication.m_Info.nSeqMeter, strFrom, strTo, true, self)
    }
    
    // 일일 사용량 버튼 클릭
    @IBAction func onUsageDailyBtnClicked(_ sender: UIButton) {
        print("Main: UsageDailyButton Clicked")
        
        let storyboard = UIStoryboard(name: "UsageDaily", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageDailyViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    // 월별 사용량 버튼 클릭
    @IBAction func onUsageMonthlyBtnClicked(_ sender: UIButton) {
        print("Main: UsageMonthlyButton Clicked")
        
        let storyboard = UIStoryboard(name: "UsageMonthly", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageMonthlyViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    // 연도별 사용량 버튼 클릭
    @IBAction func onUsageYearlyBtnClicked(_ sender: UIButton) {
        print("Main: UsageYearlyButton Clicked")
        
        let storyboard = UIStoryboard(name: "UsageYearly", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageYearlyViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    @IBAction func onChangeSettingsBtnClicked(_ sender: UIButton) {
        print("Main: Change Settings button Clicked...")
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SettingViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onTermsofUseBtnClicked(_ sender: UIButton) {
        print("Main: Terms Of Use button Clicked")
        
        CaApplication.m_Info.nWeb = 1
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "WebViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onPIButtonClicked(_ sender: UIButton) {
        print("Main: Personal Information button Clicked")
        CaApplication.m_Info.nWeb = 2
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "WebViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}
