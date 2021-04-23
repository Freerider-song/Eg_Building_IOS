//
//  CaMeter.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/23.
//

import Foundation

public class CaMeter{
    
    public var nSeqMeter: Int = 0
    public var strMid : String = ""
    public var strDescr: String = ""
    
   
    public var dKwhRef : Double = 0.0
    public var dKwhPlan : Double = 0.0
    public var dKwhReal : Double = 0.0
    public var dWonRef : Double = 0.0
    public var dWonPlan : Double = 0.0
    public var dWonReal : Double = 0.0
   
    
    public var alMeterUsage : Array<CaMeterUsage> = Array()
    
}
