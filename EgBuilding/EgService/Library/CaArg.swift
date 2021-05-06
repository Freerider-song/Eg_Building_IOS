//
//  CaArg.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/13.
//

import Foundation

public class CaArg{
    
    var command: String
    var args: Dictionary<String, Any>
    
    init(_ strCommand: String, _ cmdArgs: Dictionary<String, Any>) {
        self.command = strCommand
        self.args = cmdArgs
    }
    
    func addArg(_ strKey: String, _ value: String){
        self.args[strKey] = value
    }
    
    func addArg(_ strKey: String, _ value: Int){
        self.args[strKey] = value
    }
    
    func addArg(_ strKey: String, _ value: Double){
        self.args[strKey] = value
    }
    
    func addArg(_ strKey: String, _ value: Bool){
        self.args[strKey] = (value ? "1":"0")
    }
}
