//
//  CaFamily.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/19.
//

import Foundation

public class CaFamily {
    public var nSeqMember: Int = 0
    public var bMain: Bool = false
    public var strName: String = ""
    public var strPhone: String = ""
    public var dtLastLogin: String = ""
    
    /*public func getLastLogin() -> String {
        if dtLastLogin == nil {return ""}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtLastLogin!)
    }*/
}
