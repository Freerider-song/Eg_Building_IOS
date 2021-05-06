//
//  CaEngine.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/13.
//

import Foundation
import UIKit

public class CaEngine{
    
    //App 화면
    public let EG_CHECK_LOGIN: Int = 1001 //어떤 api인지 확인하기위한 리턴값
    public let EG_GET_MEMBER_INFO: Int = 1002
    public let EG_GET_USAGE_OF_ONE_METER = 1003
    public let EG_GET_USAGE_OF_ONE_DAY = 1004
    public let EG_GET_USAGE_OF_ONE_MONTH = 1005
    public let EG_GET_USAGE_OF_ONE_YEAR = 1006
    
    public let EG_GET_SITE_LIST = 1008
    public let EG_GET_APT_DONG_LIST = 1009
    public let EG_GET_APT_HO_LIST = 1010
    public let EG_SET_MEMBER_INFO = 1011
    public let EG_IS_EXISTING_MEMBER_ID = 1012
    public let EG_SET_ALARM_INFO = 1013
    public let EG_SET_PASSWORD = 1014
    public let EG_GET_NOTICE_LIST = 1015
    public let EG_GET_OVERED_KWH = 1016
    public let EG_GET_OVERED_WON = 1017
    public let EG_GET_UNSUBSCRIBE = 1018
    
    
    public let EG_GET_MEMBER_CANDIDATE_INFO = 1020
    public let EG_CREATE_MEMBER_MAIN = 1022
    public let EG_CREATE_MEMBER_SUB = 1023
    public let EG_REQUEST_ACK_MEMBER = 1024
    public let EG_RESPONSE_ACK_MEMBER = 1025
    public let EG_GET_MEMBER_ID_SEQ = 1026
    public let EG_CHANGE_PASSWORD = 1027
    public let EG_GET_USAGE_CURRENT_OF_ONE_SITE = 1032
    public let EG_CHANGE_MEMBER_SETTING = 1033
    public let EG_GET_ALARM_LIST = 1034
    public let EG_SET_ALARM_LIST_AS_READ = 1035
    public let EG_SET_NOTICE_LIST_AS_READ = 1036
    public let EG_GET_FAQ_LIST = 1037
    public let EG_GET_QNA_LIST = 1038
    public let EG_SET_QNA_LIST_AS_READ = 1039
    public let EG_CREATE_QUESTION = 1040
    
    //Auth Type
    public let AUTH_TYPE_UNKNOWN: Int = 1000
    public let AUTH_TYPE_SUBSCRIBE: Int = 1001
    public let AUTH_TYPE_CHANGE_PASSWORD: Int = 1002
    
    //Alarm 정보
    public let ALARM_TYPE_UNKNOWN: Int = 0
    public let ALARM_TYPE_REQUEST_ACK_MEMBER = 1001
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_ACCEPTED = 1002
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_REJECTED = 1003
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_CANCELED = 1004
    public let ALARM_TYPE_NOTI_KWH = 1101
    public let ALARM_TYPE_NOTI_WON = 1102
    public let ALARM_TYPE_NOTI_PRICE_LEVEL = 1103
    public let ALARM_TYPE_NOTI_USAGE = 1104
    public let ALARM_TYPE_NOTI_TRANS = 1110
    
    //Pref 정보
    public let PREF_MEMBER_ID: String = "MEMBER_ID"
    public let PREF_PASSWORD: String = "PASSWORD"
    
    let NO_CMD_ARGS: Dictionary<String,Any> = [String:Any]()
    
    init() {
    }
    
    // ShowWaitDialog를 Root View가 아닌, 다른 View 띄우자마자 호출하면 View가 사라지는 문제가 있음
    // 따라서, View가 바로 호출될 때 실행되는 API (ex.GetUsageOfOneDay)는, 유동적으로 ShowWaitDialog를 호출해야 됨
    // View가 호출될 떄는 ShowWaitDialog를 False로, 이후 다시 호출될 떄는 True로 함
    func executeCommand(_ Arg: CaArg, _ nCallMethod: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        // nCallMethod: 어떤 api인지 알려주는 거
        let Task: CaTask = CaTask(Arg, nCallMethod, bShowWaitDialog, viewControl) //Catask api통신위해 만든 객체
        Task.run() //서버와 연결
        //bshowwaitdialog 로딩중인 dialog을 보여주느냐 마느냐, true이면 api 통신중에 동그라미가 보임, 통신이 끝나면 동그라미가 사라지는데
        //그과정 다른 view까지 삭제됨. view를 띄우면서 api를 호출할땐 false, view를 띄우지 않고, 기존 뷰에서 업데이트만 할때는 새로고침하면 그대로 보여주면됨 true
    }
    
    func CheckLogin(_ strMemberId: String, _ strPassword: String, _ viewControl: AnyObject){
        print("CaEngine: CheckLogin Called")
        
        let Arg = CaArg("CheckLogin", NO_CMD_ARGS)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
        Arg.addArg("DeviceId", CaApplication.m_Info.strPushId)
        Arg.addArg("Os", "IOS")
        Arg.addArg("Version", 1911181)
        
        executeCommand(Arg, EG_CHECK_LOGIN, true, viewControl)
    }
    
    func GetMemberInfo(_ nSeqMember: Int, _ viewControl: AnyObject){
        print("CaEngine: GetMemberInfo Called")
        
        let Arg = CaArg("GetMemberInfo", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        
        executeCommand(Arg, EG_GET_MEMBER_INFO, true, viewControl)
    }
    
    func GetUsageOfOneMeter(_ nSeqSite: Int, _ nSeqMeter: Int, _ strFromyyyyMMdd: String, _ strToyyyyMMddhhmm: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetUsageOfOneMeter Called")
        
        let Arg = CaArg("GetUsageOfOneMeter", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqMeter", nSeqMeter)
        Arg.addArg("From", strFromyyyyMMdd)
        Arg.addArg("To", strToyyyyMMddhhmm)
        
        executeCommand(Arg, EG_GET_USAGE_OF_ONE_METER, bShowWaitDialog, viewControl)
    }
    
    func GetUsageOfOneDay(_ nSeqSite: Int, _ nSeqMeter: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetUsageOfOneDay Called")
        
        let Arg = CaArg("GetUsageOfOneDay", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqMeter", nSeqMeter)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, EG_GET_USAGE_OF_ONE_DAY, bShowWaitDialog, viewControl)
    }
    
    func GetUsageOfOneMonth(_ nSeqSite: Int, _ nSeqMeter: Int, _ nYear: Int, _ nMonth: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetUsageOfOneMonth Called")
        
        let Arg = CaArg("GetUsageOfOneMonth", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqMeter", nSeqMeter)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, EG_GET_USAGE_OF_ONE_MONTH, bShowWaitDialog, viewControl)
    }
    
    func GetUsageOfOneYear(_ nSeqSite: Int, _ nSeqMeter: Int, _ nYear: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetUsageOfOneYear Called")
        
        let Arg = CaArg("GetUsageOfOneYear", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqMeter", nSeqMeter)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, EG_GET_USAGE_OF_ONE_YEAR, bShowWaitDialog, viewControl)
    }
    
    func GetUsageCurrentOfOneSite(_ nSeqSite: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetUsageCurrentOfOneSite Called")
        
        let Arg = CaArg("GetUsageCurrentOfOneSite", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
     
        executeCommand(Arg, EG_GET_USAGE_CURRENT_OF_ONE_SITE, bShowWaitDialog, viewControl)
    }
    
    
    func GetNoticeList(_ nSeqMember: Int, _ timeCreatedMax: Int, _ nCountNotice: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetNoticeList Called")
        
        let Arg = CaArg("GetNoticeList", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("TimeCreatedMax", timeCreatedMax)
        Arg.addArg("CountNotice", nCountNotice)
        
        
        executeCommand(Arg, EG_GET_NOTICE_LIST, bShowWaitDialog, viewControl)
    }
    
    func GetAlarmList(_ nSeqMember: Int,_ nCountNotice: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetAlarmList Called")
        
        let Arg = CaArg("GetAlarmList", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("CountMax", nCountNotice)
        
        
        executeCommand(Arg, EG_GET_ALARM_LIST, bShowWaitDialog, viewControl)
    }
    
    func SetAlarmListAsRead(_ nSeqMember: Int,_ strSeqAlarmList: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: SetAlarmListAsRead Called")
        
        let Arg = CaArg("SetAlarmListAsRead", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("SeqAlarmList", strSeqAlarmList)
        
        
        executeCommand(Arg, EG_SET_ALARM_LIST_AS_READ, bShowWaitDialog, viewControl)
    }
    
    func SetNoticeListAsRead(_ nSeqMember: Int,_ strSeqNoticeList: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: SetNoticeListAsRead Called")
        
        let Arg = CaArg("SetNoticeListAsRead", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("SeqNoticeList", strSeqNoticeList)
        
        executeCommand(Arg, EG_SET_NOTICE_LIST_AS_READ, bShowWaitDialog, viewControl)
    }
    
    func GetSiteList(bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetSiteList Called")
        
        let Arg = CaArg("GetSiteList", NO_CMD_ARGS)
       
        executeCommand(Arg, EG_GET_SITE_LIST, bShowWaitDialog, viewControl)
    }
    
    func GetAptDongList(_ nSeqSite: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetAptDongList Called")
        
        let Arg = CaArg("GetAptDongList", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
    
        
        executeCommand(Arg, EG_GET_APT_DONG_LIST, bShowWaitDialog, viewControl)
    }
    
    func GetAptHoList(_ nSeqSite: Int, _ nSeqDong: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetAptHoList Called")
        
        let Arg = CaArg("GetAptHoList", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqDong", nSeqDong)
    
        executeCommand(Arg, EG_GET_APT_HO_LIST, bShowWaitDialog, viewControl)
    }
    
    func GetMemberCandidateInfo(_ nSeqHo: Int, _ strName: String, _ strPhone: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetMemberCandidateInfo Called")
        
        let Arg = CaArg("GetMemberCandidateInfo", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
    
        executeCommand(Arg, EG_GET_MEMBER_CANDIDATE_INFO, bShowWaitDialog, viewControl)
    }
    
    func CreateMemberMain(_ nSeqHo: Int, _ strName: String, _ strPhone: String, _ strMemberId: String, _ strPassword: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: CreateMemberMain Called")
        
        let Arg = CaArg("CreateMemberMain", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
    
        executeCommand(Arg, EG_CREATE_MEMBER_MAIN, bShowWaitDialog, viewControl)
    }
    
    func CreateMemberSub(_ nSeqHo: Int, _ strName: String, _ strPhone: String, _ strMemberId: String, _ strPassword: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: CreateMemberSub Called")
        
        let Arg = CaArg("CreateMemberSub", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
    
        executeCommand(Arg, EG_CREATE_MEMBER_SUB, bShowWaitDialog, viewControl)
    }
    
    func RequestAckMember(_ nSeqMemberAckRequester: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: RequestAckMember Called")
        
        let Arg = CaArg("RequestAckMember", NO_CMD_ARGS)
        
        Arg.addArg("SeqMemberAckRequester", nSeqMemberAckRequester)
        
        executeCommand(Arg, EG_REQUEST_ACK_MEMBER, bShowWaitDialog, viewControl)
    }
    
    func ResponseAckMember(_ nSeqMemberSub: Int, _ nAck: Int, _bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: ResponseAckMember Called")
        
        let Arg = CaArg("ResponseAckMember", NO_CMD_ARGS)
        Arg.addArg("SeqMemberSub", nSeqMemberSub)
        Arg.addArg("Ack", nAck)
        
        executeCommand(Arg, EG_RESPONSE_ACK_MEMBER, _bShowWaitDialog, viewControl)
    }
    
    func GetMemberIdSeq(_ strName: String, _ strPhone: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetMemberIdSeq Called")
        
        let Arg = CaArg("GetMemberIdSeq", NO_CMD_ARGS)
        
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
    
        executeCommand(Arg, EG_GET_MEMBER_ID_SEQ, bShowWaitDialog, viewControl)
    }
    
    func ChangePassword(_ nSeqMember: Int, _ strPasswordNew: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: ChangePassword Called")
        
        let Arg = CaArg("ChangePassword", NO_CMD_ARGS)
        
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("PasswordNew", strPasswordNew)
    
        executeCommand(Arg, EG_CHANGE_PASSWORD, bShowWaitDialog, viewControl)
    }
    
    func ChangeMemberSettings(_ nSeqMember: Int, _ bNotiAll: Bool, _ bNotiKwh: Bool, _ bNotiWon: Bool, _ bNotiPriceLevel: Bool, _ bNotiUsage: Bool, _ nDiscountFamily: Int, _ nDiscountSocial: Int, _ dThresholdKwh: Double, _ dThresholdWon: Double, _ nNextPriceLevelPercent: Int, _ nUsageNotiType: Int, _ nUsageNotiHour: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: ChangeMemberSettings Called")
        
        let Arg = CaArg("ChangeMemberSettings", NO_CMD_ARGS)
        
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("NotiAll", bNotiAll ? 1 : 0)
        Arg.addArg("NotiKwh", bNotiKwh ? 1 : 0)
        Arg.addArg("NotiWon", bNotiWon ? 1 : 0)
        Arg.addArg("NotiPriceLevel", bNotiPriceLevel ? 1 : 0)
        Arg.addArg("NotiUsage", bNotiUsage ? 1 : 0)
        Arg.addArg("DiscountFamily", nDiscountFamily)
        Arg.addArg("DiscountSocial", nDiscountSocial)
        Arg.addArg("ThresholdKwh", dThresholdKwh)
        Arg.addArg("ThresholdWon", dThresholdWon)
        Arg.addArg("NextPriceLevelPercent", nNextPriceLevelPercent)
        Arg.addArg("UsageNotiType", nUsageNotiType)
        Arg.addArg("UsageNotiHour", nUsageNotiHour)
    
        executeCommand(Arg, EG_CHANGE_MEMBER_SETTING, bShowWaitDialog, viewControl)
    }
    
    
    
    
    
}

var m_GlobalEngine = CaEngine()
