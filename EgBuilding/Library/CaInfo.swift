//
//  CaInfo.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2021/04/22.
//

import Foundation

public class CaInfo {
    
    public let KWH_TO_GAS: Double = 0.46625
    
    
    
    public let dfStd = DateFormatter() //yyyy-MM-dd HH:mm:ss
    public let dfyyyyMMddHHmmStd = DateFormatter() //yyyy-MM-dd HH:mm
    public let dfyyyyMMddHHmm = DateFormatter() //yyyyMMddHHmm
    public let dfyyyyMMddHHmmss = DateFormatter() //yyyyMMddHHmmss
    public let dfyyyyMMdd = DateFormatter() //yyyyMMdd
    public let dfyyyyMMddStd = DateFormatter() //yyyy-MM-dd
    public let dfyyyyMM = DateFormatter() //yyyyMM
    public let dfyyyyMMStd = DateFormatter() //yyyy-MM
    public let dfyyyy = DateFormatter() //yyyy
    public let dfMM = DateFormatter() //MM
    public let dfdd = DateFormatter() //dd
    public let dfMMddHHmmss = DateFormatter()
    public let dfHH = DateFormatter()
    public let dfyyMMdd = DateFormatter()
    
    public var isLogin : Bool = false
    
    public var m_nResultCode: Int = 0
    public var m_nSeqAdmin: Int = 0
    public var m_nTeamType: Int = 0
    public var nPushPlanElem: Int = 0

    public var m_strAdminName: String = ""
    public var m_strAdminPhone: String = ""
    public var m_nUnreadNoticeCount: Int = 0
    public var m_nUnreadAlarmCount: Int = 0
    //public var m_dtLastLogin: Date? = nil
    //public var m_dtCreated: Date? = nil
    //public var m_dtModified: Date? = nil
    //public var m_dtChangePassword: Date? = nil
    public var m_dtLastLogin: String = ""
    public var m_dtCreated: String = ""
    public var m_dtModified: String = ""
    public var m_dtChangePassword: String = ""
    public var m_nSeqTeam: Int=0
    public var m_strTeamName: String=""
    public var m_bNotiAll: Bool=true
    public var m_bNotiKwh: Bool=true
    public var m_bNotiWon: Bool=true
    public var m_bNotiSavingStandard: Bool=true
    public var m_bNotiSavingGoal: Bool = true
    public var m_bNotiUsageAtTime: Bool = true
    public var m_dThresholdThisMonthKwh: Double=0.0
    public var m_dThresholdThisMonthWon: Double=0.0
    public var m_nHourNotiThisMonthUsage: Int=0

    public var m_nSeqSite: Int = 0;
    public var m_nSiteType: Int = 0;
    public var m_strSiteName: String = "";
    public var m_nBuiltYear: Int = 0;
    public var m_nBuiltMonth: Int = 0;
    public var m_strFloorInfo: String = "";
    public var m_strHomePage: String = "";
    public var m_strSiteFax: String = "";
    public var m_strSitePhone: String = "";
    public var m_strSiteAddress: String = "";
    public var m_dSiteDx: Double = 0.0;
    public var m_dSiteDy: Double = 0.0;
    public var m_dKwContracted: Double = 0.0;
    public var m_nReadDay: Int = 0;
    public var m_nSeqSavePlanActive: Int = 0;

    public var m_nSeqSavePlan: Int = 0;
    public var m_nSeqSaveRef: Int = 0;
    public var m_strSavePlanName: String = "";
    public var m_strSaveRefName: String = "";
    public var m_dSaveKwhTotalFromElem: Double = 0.0;
    public var m_dSaveWonTotalFromElem: Double = 0.0;
    public var m_dSaveKwhTotalFromMeter: Double = 0.0;
    public var m_dSaveWonTotalFromMeter: Double = 0.0;
    public var m_dKwhRefForAllMeter: Double = 0.0;
    public var m_dKwhPlanForAllMeter: Double = 0.0;
    public var m_dKwhRealForAllMeter: Double = 0.0;
    public var m_dWonRefForAllMeter: Double = 0.0;
    public var m_dWonPlanForAllMeter: Double = 0.0;
    public var m_dWonRealForAllMeter: Double = 0.0;
    //public var m_dtSavePlanCreated: Date? = nil
    //public var m_dtSavePlanEnded: Date? = nil
    public var m_dtSavePlanCreated: String = ""
    public var m_dtSavePlanEnded: String = ""
    public var m_nActCount: Int = 0
    public var m_nActCountWithHistory: Int = 0

    //
    // GetSaveResult
    public var m_nTotalSaveActCount: Int = 0;
    public var m_nTotalSaveActWithHistoryCount: Int = 0;
    public var m_dAvgKwhForAllMeter: Double = 0.0;
    public var m_dAvgWonForAllMeter: Double = 0.0;


    public var m_strAdminId: String = "";
    public var m_strPassword: String = "";
   


    //public var m_dtNoticeCreatedMaxForNextRequest: Date? = nil
    public var m_dtNoticeCreatedMaxForNextRequest: String = ""
    public var m_dtAlarmCreatedMaxForNextRequest: String = ""


    public var m_strPushId: String = "";



    public var m_alNotice: Array<CaNotice> = Array()
    public var m_alPlan: Array<CaPlan> = Array()
    public var m_alMeter: Array<CaMeter> = Array()
    public var m_alAlarm: Array<CaAlarm> = Array()


    //oneMeter 정보
    public var nTransState: Int = -1
    //public var dfKwh: 
    
    // 공지사항 요청 시간
    public var dtNoticeCreatedMaxForNextRequest: Date? = nil
    public var dtAlarmCreatedMaxForNextRequest: Date? = nil
    
    init() {
        dfStd.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dfyyyyMMddHHmmStd.dateFormat = "yyyy-MM-dd HH:mm"
        dfyyyyMMddHHmm.dateFormat = "yyyyMMddHHmm"
        dfyyyyMMddHHmmss.dateFormat = "yyyyMMddHHmmss"
        dfyyyyMMddStd.dateFormat = "yyyy-MM-dd"
        dfyyyyMMdd.dateFormat = "yyyyMMdd"
        dfyyyyMM.dateFormat = "yyyyMM"
        dfyyyyMMStd.dateFormat = "yyyy-MM"
        dfyyyy.dateFormat = "yyyy"
        dfMM.dateFormat = "MM"
        dfdd.dateFormat = "dd"
        dfHH.dateFormat = "HH"
        dfMMddHHmmss.dateFormat = "MM-dd HH:mm:ss"
        dfyyMMdd.dateFormat = "yyMMdd"
    }
    
    public func setAlarmList(_ ja: Array<[String:Any]>){
        
        //m_alAlarm.removeAll()
        
        for joAlarm in ja {
            let alarm: CaAlarm = CaAlarm()
            
            alarm.nSeqAlarm = joAlarm["seq_alarm"]! as! Int
            alarm.nAlarmType = joAlarm["alarm_type"]! as! Int //1=관리사무소, 2=EG서비스 3=구청관리자
            alarm.nSeqSavePlanElem = joAlarm["seq_save_plan_elem"]! as! Int
            alarm.strContent = joAlarm["content"]! as! String
            alarm.strTitle = joAlarm["title"]! as! String
            alarm.bRead = (joAlarm["is_read"] as! Int) == 1
            alarm.dtCreated = joAlarm["time_created"] as! String
            
            
            if (alarm.bRead){
                alarm.dtRead = joAlarm["time_read"] as! String
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //notice.dtCreated가 String 타입이므로 dtNoticeCreatedMaxForNextRequest에는 date형식으로 변환 후 입력
            dtAlarmCreatedMaxForNextRequest = dateFormatter.date(from: alarm.dtCreated)
            
            
            m_alAlarm.append(alarm)
        }
        
        
        print("setAlarmList has succeed")
        
    }
    
    public func setNoticeList(_ noticeTopList: Array<[String:Any]>, _ noticeNormalList: Array<[String:Any]>){
        
        // 상단 고정 Notice 추가
        var alTop:Array<CaNotice> = Array()
        
        for top in noticeTopList {
            let notice:CaNotice = CaNotice()
            
            notice.nSeqNotice = top["seq_notice"]! as! Int
            notice.nWriterType = top["writer_type"]! as! Int //1=관리사무소, 2=EG서비스 3=구청관리자
            notice.strTitle = top["title"]! as! String
            notice.strContent = top["content"]! as! String
            notice.bTop = true
            //notice.dtCreated = top["time_created"] as? Date
            notice.dtCreated = top["time_created"] as! String
            
            if ((top["time_read"] as? String) == nil){
                notice.bRead = false
            }
            else {
                notice.bRead = true
                notice.dtRead = top["time_read"] as! String             }
            
            alTop.append(notice)
        }
        
        //기존 공지사항 중 상단 고정 아닌 것들 저장
        var alNormal:Array<CaNotice> = Array()
        
        for notice in m_alNotice {
            if notice.bTop {continue}
            alNormal.append(notice)
        }
        
        m_alNotice.removeAll()  //새로 불러온 공지사항 저장을 위해 alNotice 초기화 후 다시 저장
        
        for notice in alTop {
            m_alNotice.append(notice)
        }
        
        for notice in alNormal {
            m_alNotice.append(notice)
        }
        
        // 새로 추가된 공지사항 append
        for normal in noticeNormalList {
            let notice:CaNotice = CaNotice()
            
            notice.nSeqNotice = normal["seq_notice"]! as! Int
            notice.nWriterType = normal["writer_type"]! as! Int
            notice.strTitle = normal["title"]! as! String
            notice.strContent = normal["content"]! as! String
            notice.bTop = false
            //notice.dtCreated = normal["time_created"] as? Date
            notice.dtCreated = normal["time_created"] as! String
            
            if ((normal["time_read"] as? String) == nil) {
                notice.bRead = false
            }
            else {
                notice.bRead = true
                notice.dtRead = normal["time_read"] as! String
            }
            
            m_alNotice.append(notice)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //notice.dtCreated가 String 타입이므로 dtNoticeCreatedMaxForNextRequest에는 date형식으로 변환 후 입력
            dtNoticeCreatedMaxForNextRequest = dateFormatter.date(from: notice.dtCreated)
            
        }
        
        
        
        print("setnotice has succeed")
        
    }
    
    public func getAlarmReadListString() -> String {
        var strResult: String = ""
        
        for alarm in m_alAlarm {
            if alarm.bReadStateChanged {
                strResult = strResult + "\(alarm.nSeqAlarm),"
            }
        }
        if strResult.isEmpty {return strResult}
        
        let firstIndex = strResult.index(strResult.startIndex, offsetBy: 0)
        let lastIndex = strResult
            .index(strResult.endIndex, offsetBy: -1)
        strResult = "\(strResult[firstIndex..<lastIndex])"
        
        return strResult
    }
    
    public func getNoticeReadListString() -> String {
        var strResult: String = ""
        
        for notice in m_alNotice {
            if notice.bReadStateChanged {
                strResult = strResult + "\(notice.nSeqNotice),"
            }
        }
        if strResult.isEmpty {return strResult}
        
        let firstIndex = strResult.index(strResult.startIndex, offsetBy: 0)
        let lastIndex = strResult
            .index(strResult.endIndex, offsetBy: -1)
        strResult = "\(strResult[firstIndex..<lastIndex])"
        
        return strResult
    }
    
    public func setPlanList(_ planList: Array<[String:Any]>) {
        
        m_alPlan.removeAll()
        
        for plan in planList {
            
            let ca_plan:CaPlan = CaPlan()
            
            ca_plan.nSeqPlanElem =  plan["seq_plan_elem"] as! Int
            ca_plan.nSeqMeter = plan["seq_meter"]! as! Int
            ca_plan.strMid = plan["mid"]! as! String
            ca_plan.strMeterDescr = plan["meter_descr"]! as! String
            ca_plan.nHourFrom = plan["hour_from"]! as! Int
            ca_plan.nHourTo = plan["hour_to"]! as! Int
            ca_plan.dKwhRef = plan["kwh_ref"]! as! Double
            ca_plan.dKwhPlan = plan["kwh_plan"]! as! Double
            ca_plan.dKwhReal = plan["kwh_real"]! as! Double
            
            let jaAct: Array<[String:Any]> = plan["list_act"] as! Array<[String:Any]>
            
        
            for act in jaAct {
                let ca_act: CaAct = CaAct()
                
                ca_act.nSeqAct = act["seq_act"] as! Int
                ca_act.strActContent = act["act_content"] as! String
                
                let jaActHistory: Array<[String: Any]> = act["list_act_history"] as! Array<[String:Any]>
                for actHistory in jaActHistory {
                    let ca_actHistory: CaActHistory = CaActHistory()
                    
                    ca_actHistory.nSeqActHistory = actHistory["seq_act_history"] as! Int
                    ca_actHistory.nSeqAdminBegin = actHistory["seq_admin_begin"] as! Int
                    ca_actHistory.nSeqAdminEnd = actHistory["seq_admin_end"] as! Int
                    ca_actHistory.dtBegin = actHistory["time_begin"] as! String
                    ca_actHistory.dtEnd = actHistory["time_end"] as! String
                    
                    
                    ca_act.alActHistory.append(ca_actHistory)
                }
                //ca_act.bChecked Check
                var flag: Bool = false
                
                let date = Date()
                let today: String = CaApplication.m_Info.dfyyyyMMdd.string(from: date)
                for i in 0..<ca_act.alActHistory.count{
                    let actHistory = ca_act.alActHistory[i]
                    let dtBegin = CaApplication.m_Info.dfStd.date(from: actHistory.dtBegin)!
                    if(today == CaApplication.m_Info.dfyyyyMMdd.string(from: dtBegin)){
                    
                        flag = true
                        break
                    }
                }
                if flag == false {
                    
                    ca_act.bChecked = false
                    
                }
                ca_plan.alAct.append(ca_act)
                
                
                }
            
            for i in 0..<ca_plan.alAct.count {
                let act = ca_plan.alAct[i]
                if !act.bChecked {
                    ca_plan.bAllChecked = false
                    break
                }
                
            }
            
            
            m_alPlan.append(ca_plan)
        }
        print("CaInfo: setPlan activated...")
        print(m_alPlan)
    }
    
    public func setMeterList(_ meterList: Array<[String:Any]>) {
        
        m_alMeter.removeAll()
        
        for meter in meterList {
            
            let ca_meter: CaMeter = CaMeter()
            
            ca_meter.nSeqMeter =  meter["seq_meter"] as! Int
            
            ca_meter.strMid = meter["mid"]! as! String
            ca_meter.strDescr = meter["descr"]! as! String
            ca_meter.dKwhRef = meter["kwh_ref"]! as! Double
            
            ca_meter.dKwhPlan = meter["kwh_plan"]! as! Double
            //ca_meter.dKwhReal = meter["kwh_real"]! as! Double
            
            let jaUsage: Array<[String:Any]> = meter["list_usage"] as! Array<[String:Any]>
            
        
            for usage in jaUsage {
                let ca_usage: CaMeterUsage = CaMeterUsage()
                
                ca_usage.nYear = usage["year"] as! Int
                ca_usage.nMonth = usage["month"] as! Int
                ca_usage.nDay = usage["day"] as! Int
                ca_usage.bHoliday = usage["is_holiday"] as! Bool
                ca_usage.dKwh = usage["kwh"] as! Double
                ca_usage.dWon = usage["won"] as! Double
                
                ca_meter.alMeterUsage.append(ca_usage)
            }
            
            
            m_alMeter.append(ca_meter)
        }
        print("CaInfo: setMeter complished...")
        print(m_alMeter)
    }
 
    // 숫자 3자리마다 , 출력
    public func decimal(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        return result
    }
    
    // 소수 첫째
    public func decimal(value: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: round(value*10)/10))!
        
        return result
    }
}
