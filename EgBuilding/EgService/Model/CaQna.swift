//
//  CaQna.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/20.
//

import Foundation

public class CaQna {
    
    public var nSeqQna: Int = 0
    public var strQuestion: String = ""
    public var strAnswer: String = ""
    public var dtQuestion: Date? = nil
    public var dtAnswer: Date? = nil
    public var dtAnswerRead: Date? = nil
    public var bReadStateChanged: Bool = false
    
    public func isAnswered() -> Bool {
        return dtAnswer != nil
    }
    
    public func isAnswerRead() -> Bool {
        return dtAnswerRead != nil
    }
    
    public func getQnaState() -> String {
        if isAnswered() {return "[답변완료]"}
        else {return "[답변대기]"}
    }
    
    public func getTimeQna() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strQuestion:String = dateformatter.string(from: dtQuestion!)
        
        if isAnswered() {
            let dateformatterAnswer = DateFormatter()
            dateformatterAnswer.dateFormat = "MM-dd HH:mm"
            
            return "[문의] " + strQuestion + "    [답변] " + strAnswer
        }
        else {
            return "[문의] " + strQuestion
        }
    }
    
    public func getTimeQuestion() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strTime:String = dateformatter.string(from: dtQuestion!)
        
        return "[문의] " + strTime
    }
    
    public func getTimeAnswer() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strTime:String = dateformatter.string(from: dtAnswer!)
        
        return "[답변] " + strTime
    }
}
