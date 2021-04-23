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
    
    public var isLogin : Bool = false
    
    public var m_nResultCode: Int = 0
    public var m_nSeqAdmin: Int = 0
    public var m_nTeamType: Int = 0

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
        dfMMddHHmmss.dateFormat = "MM-dd HH:mm:ss"
    }
    /*
    
    public func removeFamilyMember(_ nSeqMember: Int) -> Bool {
        for ca_family in alFamily{
            if ca_family.nSeqMember == nSeqMember{
            alFamily.removeAll(where: { $0.nSeqMember == nSeqMember})
                return true
        }
        }
        return false
    }
    
    public func setResponseCodeForMemberSub(_ nSeqMemberSub: Int, _ nAck: Int) -> Void {
        for ca_alarm in alAlarm{
            if ca_alarm.nSeqMemberAckRequester == nSeqMemberSub{
                ca_alarm.nResponse = nAck
        }
        }
      
    }
    
    public func getAlarmReadListString() -> String {
        var strResult: String = ""
        
        for alarm in alAlarm {
            if alarm.bReadStateChanged {
                strResult = strResult + "\(alarm.nSeqAlarm) ,"
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
        
        for notice in alNotice {
            if notice.bReadStateChanged {
                strResult = strResult + "\(notice.nSeqNotice) ,"
            }
        }
        if strResult.isEmpty {return strResult}
        
        let firstIndex = strResult.index(strResult.startIndex, offsetBy: 0)
        let lastIndex = strResult
            .index(strResult.endIndex, offsetBy: -1)
        strResult = "\(strResult[firstIndex..<lastIndex])"
        
        return strResult
    }
    
    public func getUnreadAlarmCount() -> Int {
        var nCount: Int = 0
        
        for alarm in alAlarm {
            if !alarm.bRead {nCount += 1}
        }
        return nCount
    }
    
    public func getUnreadNoticeCount() -> Int {
        var nCount: Int = 0
        
        for notice in alNotice {
            if !notice.bRead {nCount += 1}
        }
        return nCount
    }
    
    public func setAlarmList(_ alarmList: Array<[String:Any]>) {
        
        alAlarm.removeAll()
        
        for alarm in alarmList {
            let ca_alarm:CaAlarm = CaAlarm()
            
            ca_alarm.nSeqAlarm = alarm["seq_alarm"]! as! Int
            ca_alarm.nAlarmType = alarm["alarm_type"]! as! Int
            ca_alarm.nResponse = alarm["ack_response"]! as! Int
            ca_alarm.strTitle = alarm["title"]! as! String
            ca_alarm.strContent = alarm["content"]! as! String
            if alarm["is_read"]! as! Int == 0 {ca_alarm.bRead = false}
            else { ca_alarm.bRead = true}

            
            ca_alarm.dtCreated = alarm["time_created"] as! String
            ca_alarm.nSeqMemberAckRequester = alarm["seq_member_ack_requester"]! as! Int
            
            if ca_alarm.bRead {
                ca_alarm.dtRead = alarm["time_read"] as! String
            }
            else {ca_alarm.dtRead = ""}
            
            alAlarm.append(ca_alarm)
        }
    }
    
    public func setNoticeList(_ noticeTopList: Array<[String:Any]>, _ noticeNormalList: Array<[String:Any]>){
        
        // 상단 고정 Notice 추가
        var alTop:Array<CaNotice> = Array()
        
        for top in noticeTopList {
            let notice:CaNotice = CaNotice()
            
            notice.nSeqNotice = top["seq_notice"]! as! Int
            notice.nNoticeType = top["writer_type"]! as! Int //1=관리사무소, 2=EG서비스 3=구청관리자
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
        
        for notice in alNotice {
            if notice.bTop {continue}
            alNormal.append(notice)
        }
        
        alNotice.removeAll()  //새로 불러온 공지사항 저장을 위해 alNotice 초기화 후 다시 저장
        
        for notice in alTop {
            alNotice.append(notice)
        }
        
        for notice in alNormal {
            alNotice.append(notice)
        }
        
        // 새로 추가된 공지사항 append
        for normal in noticeNormalList {
            let notice:CaNotice = CaNotice()
            
            notice.nSeqNotice = normal["seq_notice"]! as! Int
            notice.nNoticeType = normal["writer_type"]! as! Int
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
            
            alNotice.append(notice)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //notice.dtCreated가 String 타입이므로 dtNoticeCreatedMaxForNextRequest에는 date형식으로 변환 후 입력
            dtNoticeCreatedMaxForNextRequest = dateFormatter.date(from: notice.dtCreated)
            
        }
        
        
        
        print("setnotice has succeed")
        
    }
    
    public func setQnaList(_ qnaList: Array<[String:Any]>) {
        
        alQna.removeAll()
        
        for qna in qnaList {
            let ca_qna:CaQna = CaQna()
            
            ca_qna.nSeqQna = qna["seq_qna"]! as! Int
            ca_qna.strQuestion = qna["question"]! as! String
            //ca_qna.strAnswer = qna["answer"]! as! String
            ca_qna.dtQuestion = qna["time_question"] as? Date
            ca_qna.dtAnswer = qna["time_answer"] as? Date
            ca_qna.dtAnswerRead = qna["time_answer_read"] as? Date
            
            alQna.append(ca_qna)
        }
    }
    
   /* public func setFamilyList(_ familyList: Array<[String:Any]>) {
        
        alFamily.removeAll()
        
        for family in familyList {
            let ca_family: CaFamily = CaFamily()
            
            ca_family.dtLastLogin = family["time_last_login"] as? Date
            ca_family.strPhone = family["member_phone"] as! String
            ca_family.strName = family["member_name"] as! String
            ca_family.nSeqMember = family["seq_member"] as! Int
            if family["main_member"] as! Int == 1 {
                ca_family.bMain = true
            }
            else {
                ca_family.bMain = false
            }
        }
    }*/
    
    // 숫자 3자리마다 , 출력
    public func decimal(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        return result
    }
    
    // 숫자 3자리마다 , 출력
    public func decimal(value: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: round(value*10)/10))!
        
        return result
    }
    */
}
