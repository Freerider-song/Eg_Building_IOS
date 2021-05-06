//
//  CaEngine.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2021/04/22.
//

import Foundation
import UIKit

public class CaEngine{
    
  

    //API 요청
    public let CB_CHECK_BLD_LOGIN = 1001;
    public let CB_GET_BLD_ADMIN_INFO = 1002;
    public let CB_CHANGE_ADMIN_PASSWORD = 1003;
    public let CB_REQUEST_AUTH_CODE = 1004;
    public let CB_CHECK_AUTH_CODE = 1005;
    public let CB_CHECK_ADMIN_CANDIDATE = 1006;
    public let CB_GET_ADMIN_USAGE_CURRENT = 1007;
    public let CB_GET_ADMIN_ALARM_LIST = 1008;
    public let CB_GET_BLD_NOTICE_LIST = 1009;
    public let CB_SET_BLD_NOTICE_AS_READ = 1010;
    public let CB_GET_SAVE_RESULT_DAILY = 1011;
    public let CB_GET_SAVE_RESULT = 1012;
    public let CB_GET_USAGE_FOR_ALL_METER_DAY = 1013;
    public let CB_GET_USAGE_FOR_ALL_METER_MONTH = 1014;
    public let CB_GET_USAGE_FOR_ALL_METER_YEAR = 1015;
    public let CB_CHANGE_ADMIN_BLD_SETTINGS = 1016;
    public let CB_GET_BLD_ALARM_LIST = 1017;
    public let CB_SET_SAVE_ACT_BEGIN = 1018;
    public let CB_SET_SAVE_ACT_END = 1019;



    public let AUTH_TYPE_UNKNOWN = 1000;
    public let AUTH_TYPE_SUBSCRIBE = 1001;
    public let AUTH_TYPE_CHANGE_PASSWORD = 1002;



    public let ALARM_TYPE_UNKNOWN = 0;
    public let ALARM_TEST = 2;
    public let ALARM_NEW_NOTICE = 3001; // 새 공지사항발생
    public let ALARM_PLAN_ELEM_BEGIN = 3002; //절감항목 시작
    public let ALARM_PLAN_ELEM_END = 3003; // 절감항목종료
    public let ALARM_SAVE_ACT_MISSED = 3004; // 미시행절감조치 있음 알림
    public let ALARM_THIS_MONTH_USAGE_AT = 3005; //정해진 시간에 사용량과 사용요금 알림
    public let ALARM_THIS_MONTH_KWH_OVER = 3006; //설정한 사용량 임계치 초과 알림
    public let ALARM_THIS_MONTH_WON_OVER = 3007; //설정한 사용요금 임계치 초과 알림
    public let ALARM_METER_KWH_OVER_SAVE_REF = 3008; //계측기별 사용량이 절감기준 사용량 초과
    public let ALARM_METER_KWH_OVER_SAVE_PLAN = 3009;// 계측기별 사용량이 절감목표 사용량 초과

    
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
    
    
    func CheckBldLogin(_ AdminId: String, _ Password: String, _ Os:String, _ DeviceId: String, _ Version: String, _ viewControl: AnyObject){
        print("ENGINE", "Id=" + AdminId + ", Password=" + Password)

        let Arg = CaArg("CheckBldLogin", NO_CMD_ARGS)
        Arg.addArg("AdminId", AdminId)
        Arg.addArg("Password", Password)
        Arg.addArg("Os", Os)
        Arg.addArg("DeviceId", DeviceId)
        Arg.addArg("Version", Version)

        executeCommand(Arg, CB_CHECK_BLD_LOGIN, true, viewControl)
    }

    func GetBldAdminInfo(_ SeqAdmin: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
 

        let Arg = CaArg("GetBldAdminInfo", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)

        executeCommand(Arg, CB_GET_BLD_ADMIN_INFO, bShowWaitDialog, viewControl)
    }

    func ChangeAdminPassword(_ Id: String, _ PasswordNew: String, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
       
        let Arg = CaArg("ChangeAdminPassword", NO_CMD_ARGS)
        Arg.addArg("Id", Id)
        Arg.addArg("PasswordNew", PasswordNew)

        executeCommand(Arg, CB_CHANGE_ADMIN_PASSWORD, true, viewControl)
    }

    func RequestAuthCode(_ Id: String, _ Phone: String,_ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        
        let Arg = CaArg("RequestAuthCode", NO_CMD_ARGS)
        Arg.addArg("Id", Id)
        Arg.addArg("Phone", Phone)

        executeCommand(Arg, CB_REQUEST_AUTH_CODE,bShowWaitDialog, viewControl)
    }

    func CheckAuthCode(_ Phone: String, _ AuthCode: String, _ SecTimeLimit: Int,_ bShowWaitDialog: Bool,_ viewControl: AnyObject){
    

        let Arg = CaArg("CheckAuthCode", NO_CMD_ARGS)
        Arg.addArg("Phone", Phone)
        Arg.addArg("AuthCode", AuthCode)
        Arg.addArg("SecTimeLimit", SecTimeLimit)

        executeCommand(Arg, CB_CHECK_AUTH_CODE, bShowWaitDialog, viewControl)
    }

    func GetBldNoticeList(_ SeqAdmin: Int, _ TimeCreatedMax: String,_ CountNotice: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
        let Arg = CaArg("GetBldNoticeList", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("TimeCreatedMax", TimeCreatedMax)
        Arg.addArg("CountNotice", CountNotice)

        executeCommand(Arg, CB_GET_BLD_NOTICE_LIST, bShowWaitDialog, viewControl)
    }

    func SetBldNoticeListAsRead(_ SeqAdmin: Int, _ strSeqNoticeList: String, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
        

        let Arg = CaArg("SetBldNoticeListAsRead", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("SeqNoticeList", strSeqNoticeList)

        executeCommand(Arg, CB_SET_BLD_NOTICE_AS_READ, bShowWaitDialog, viewControl)
    }

    func GetSaveResultDaily(_ SeqSavePlanActive: Int,_ DateTarget: String, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
        

        let Arg = CaArg("GetSaveResultDaily", NO_CMD_ARGS)
        Arg.addArg("SeqSavePlan", SeqSavePlanActive)
        Arg.addArg("DateTarget", DateTarget)

        executeCommand(Arg, CB_GET_SAVE_RESULT_DAILY, bShowWaitDialog, viewControl)
    }

    func GetSaveResult(_ SeqSavePlanActive: Int, _ DateFrom: String, _ DateTo: String, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){

        let Arg = CaArg("GetSaveResult", NO_CMD_ARGS)
        Arg.addArg("SeqSavePlan", SeqSavePlanActive)
        Arg.addArg("DateFrom", DateFrom)
        Arg.addArg("DateTo", DateTo)

        executeCommand(Arg, CB_GET_SAVE_RESULT, bShowWaitDialog, viewControl)
    }

    func GetUsageForAllMeterDay(_ SeqSite: Int, _ Year: Int, _ Month: Int, _ Day: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
     

        let Arg =  CaArg("GetUsageForAllMeterDay", NO_CMD_ARGS)
        Arg.addArg("SeqSite", SeqSite)
        Arg.addArg("Year", Year)
        Arg.addArg("Month", Month)
        Arg.addArg("Day", Day)

        executeCommand(Arg, CB_GET_USAGE_FOR_ALL_METER_DAY, bShowWaitDialog, viewControl)
    }

    func GetUsageForAllMeterMonth(_ SeqSite: Int, _ Year: Int, _ Month: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
      

        let Arg = CaArg("GetUsageForAllMeterMonth", NO_CMD_ARGS)
        Arg.addArg("SeqSite", SeqSite)
        Arg.addArg("Year", Year)
        Arg.addArg("Month", Month)


        executeCommand(Arg, CB_GET_USAGE_FOR_ALL_METER_MONTH,bShowWaitDialog, viewControl)
    }

    func GetUsageForAllMeterYear(_ SeqSite: Int, _ Year: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
        

        let Arg = CaArg("GetUsageForAllMeterYear", NO_CMD_ARGS)
        Arg.addArg("SeqSite", SeqSite)
        Arg.addArg("Year", Year)

        executeCommand(Arg, CB_GET_USAGE_FOR_ALL_METER_YEAR,bShowWaitDialog, viewControl)
    }

    func ChangeAdminBldSettings(_ SeqAdmin:Int, _ NotiAll:Bool, _ NotiThisMonthKwh:Bool, _ NotiThisMonthWon: Bool,_ NotiThisMonthUsageAtTime: Bool,
                                _ NotiMeterKwhOverSaveRef: Bool,_ NotiMeterKwhOverSavePlan: Bool, _ ThresholdThisMonthKwh: Double,
                                _ ThresholdThisMonthWon:Double, _ HourNotiThisMonthUsage: Int, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){
        

        let Arg = CaArg("ChangeAdminBldSettings", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("NotiAll", NotiAll ? 1 : 0)
        Arg.addArg("NotiThisMonthKwh", NotiThisMonthKwh ? 1 : 0)
        Arg.addArg("NotiThisMonthWon", NotiThisMonthWon ? 1 : 0)
        Arg.addArg("NotiThisMonthUsageAtTime", NotiThisMonthUsageAtTime ? 1 : 0)
        Arg.addArg("NotiMeterKwhOverSaveRef", NotiMeterKwhOverSaveRef ? 1 : 0)
        Arg.addArg("NotiMeterKwhOverSavePlan", NotiMeterKwhOverSavePlan ? 1 : 0)
        Arg.addArg("ThresholdThisMonthKwh", ThresholdThisMonthKwh)
        Arg.addArg("ThresholdThisMonthWon", ThresholdThisMonthWon)
        Arg.addArg("HourNotiThisMonthUsage", HourNotiThisMonthUsage)

        executeCommand(Arg, CB_CHANGE_ADMIN_BLD_SETTINGS,  bShowWaitDialog, viewControl)
    }

    func GetBldAlarmList(_ SeqAdmin: Int, _ CountMax: Int,_ bShowWaitDialog: Bool, _ viewControl: AnyObject){

        let Arg = CaArg("GetBldAlarmList", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("CountMax", CountMax)

        executeCommand(Arg, CB_GET_BLD_ALARM_LIST, bShowWaitDialog, viewControl)
    }

    func SetSaveActBegin(_ SeqSaveAct: Int, _ SeqAdmin: Int, _ DateTarget: String, _ bShowWaitDialog: Bool,_ viewControl: AnyObject){


        let Arg = CaArg("SetSaveActBegin", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("SeqSaveAct", SeqSaveAct)
        Arg.addArg("DateTarget", DateTarget)

        executeCommand(Arg, CB_SET_SAVE_ACT_BEGIN, bShowWaitDialog, viewControl)
    }

    func SetSaveActEnd(_ SeqSaveActHistory: Int, _ SeqAdmin: Int, _ yyyyMMdd: String,_ bShowWaitDialog: Bool, _ viewControl: AnyObject){

        let Arg = CaArg("SetSaveActEnd", NO_CMD_ARGS)
        Arg.addArg("SeqAdmin", SeqAdmin)
        Arg.addArg("SeqSaveActHistory", SeqSaveActHistory)
        Arg.addArg("yyyyMMdd", yyyyMMdd)

        executeCommand(Arg, CB_SET_SAVE_ACT_END, bShowWaitDialog, viewControl);
    }
    
}

var m_GlobalEngine = CaEngine()
