//
//  CaAlarm.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/04/23.
//

import Foundation

public class CaAlarm {
    
    public var nSeqAlarm: Int = 0
    public var nAlarmType: Int = m_GlobalEngine.ALARM_TYPE_UNKNOWN
    public var nSeqSavePlanElem: Int = 0
    public var strTitle: String = ""
    public var strContent: String = ""
    
    public var dtCreated: String = ""
    public var dtRead: String = ""
    public var bRead: Bool = true
    
    public var bReadStateChanged: Bool = false
    
    public var bClickable = false
 
    
    /*public func getTimeCreated() -> String {
        if dtCreated == nil {return ""}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtCreated!)
    }*/
}
