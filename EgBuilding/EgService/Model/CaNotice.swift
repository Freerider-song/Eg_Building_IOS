//
//  CaNotice.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/19.
//

import Foundation

public class CaNotice{
    
    public var nSeqNotice: Int = 0
    public var strTitle: String = ""
    public var strContent: String = ""
    public var bTop: Bool = false
    public var nNoticeType: Int = 0 // 1 = 단지, 2 = EG서비스, 3= 구청관리
    
    //public var dtCreated: Date? = nil
    public var dtCreated: String = ""
    public var dtRead: String = ""
    public var bRead: Bool = false
    
    public var bReadStateChanged: Bool = false
    
    /*public func getTimeCreated() -> String {
        if dtCreated == nil {return "날짜없음"}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtCreated!)
    }*/
    
}
