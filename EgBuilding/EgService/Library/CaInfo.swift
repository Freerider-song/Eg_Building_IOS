//
//  CaInfo.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/15.
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
    
    //Login 유무
    public var isLogin: Bool = false
    
    //핸드폰 정보
    public var strPushId: String = ""
    
    //회원가입 정보
    public var bSubscribingAsMainMember: Bool = false
    public var nSeqAptHoSubscribing: Int = 0
    public var strMemberNameSubscribing: String = ""
    public var strPhoneSubscribing: String = ""
    
    //ChangePassword 정보
    public var nSeqMemberChanging: Int = 0
    public var strMemberIdChanging: String = ""
    
    
    //팝업 메세지
    public var strMessage: String = ""
    
    
    //push notification 정보
    //public var strPushTitle: String = ""
    //public var strPushBody: String = ""
    //public var strPushType: String = ""
    public var nSeqMemberAckRequester: Int = 0

    
    //Member 정보
    public var nSeqMember: Int = 0
    public var strMemberId: String = ""
    public var strPassword: String = ""
    public var strMemberName: String = ""
    public var strPhone: String = ""
    public var strMail: String = ""
    public var bMainMember: Bool = false
    public var dtCreated: String = ""
    public var dtModified: String = ""
    public var dtLastLogin: String = ""
    //date로 가져오는 경우 nil이 반환되는 문제. API에서 호출된 값이 date타입이 아닌 string임으로 string으로 받아야 함.
    public var dtChangePassword: String = ""
    public var nAckRequestTodayCount: Int = 0
    public var nAckResponseCodeLatest: Int = 0
    
    //Alarm 정보
    public var dtAuthRequested: Date? = nil
    public var dtAuthResponsed: Date? = nil
    
    //설정 정보
    public var bNotiAll: Bool = true
    public var bNotiKwh: Bool = true
    public var bNotiWon: Bool = true
    public var bNotiPriceLevel: Bool = true
    public var bNotiUsageAtTime: Bool = true
    public var dThresholdKwh: Double = 0.0
    public var dThresholdWon: Double = 0.0
    public var nNextPriceLevelPercent: Int = 0
    public var nUsageNotiType: Int = 3 //0=매일, 1=매주일요일, 2=매주월요일, 3=매월1일, 4=매월검침일
    public var nUsageNotiHour: Int = 9
    public let usageReportPeriodList = ["매일", "매주 일요일", "매주 월요일", "매달 1일", "매달 검침일"]
    public let usageReportTimeList = ["0시", "1시", "2시", "3시", "4시", "5시", "6시", "7시", "8시", "9시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시", "19시", "20시", "21시", "22시", "23시"]
    
    //단지 & Meter 정보
    public var nSeqSite: Int = 0
    public var strSiteAddress: String = ""
    public var strSiteName: String = ""
    public var nSiteBuiltYear: Int = 0
    public var nSiteBuiltMonth: Int = 0
    public var nSiteReadDay: Int = 1
    public var dxSite: Double = 0.0
    public var dySite: Double = 0.0
    public var nSeqAptDong: Int = 0
    public var strAptDongName: String = ""
    public var nSeqAptHo: Int = 0
    public var strAptHoName: String = ""
    public var nAptHoArea: Int = 0
    public var nSeqMeter: Int = 0
    public var strMeterMac: String = ""
    public var strMid: String = ""
    public var strMeterMaker: String = ""
    public var strMeterModel: String = ""
    public var nMeterState: Int = 0 //0=unknown, 1= 운영중, 2=보관중, 3=수리중
    public var nMeterType: Int = 0 //0=unknown, 1=p-type, 2=e-type, 3=g-type, 4=ae-type
    public var nMeterValidInstr: Int = 1
    public var dtMeterInstalled: Date? = nil
    public var dtPriceModified: Date? = nil
    public var strPriceComment: String = ""
    
    public var nAuthType: Int = m_GlobalEngine.AUTH_TYPE_UNKNOWN
    
    //이용약관 정보
    public var nWeb: Int = 0 //1=이용약관, 2=개인정보수집
    
    //D01YN 정보
    public var bYes: Bool = true
    public var strStoryBoardName: String = ""
    public var strViewControllerName: String = ""
    
    
    public var nDiscountFamily: Int = 0
    public var nDiscountSocial: Int = 0
    public var nMonthlyWonMethod: Int = 0
    
    // ArrayList
    public var alFamily: Array<CaFamily> = Array()
    public var alPrice: Array<CaPrice> = Array()
    public var alDiscountFamily: Array<CaDiscount> = Array()
    public var alDiscountSocial: Array<CaDiscount> = Array()
    public var alAlarm: Array<CaAlarm> = Array()
    public var alNotice: Array<CaNotice> = Array()
    public var alQna: Array<CaQna> = Array()
    
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
    
}
