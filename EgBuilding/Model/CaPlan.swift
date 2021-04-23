//
//  CaPlan.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/23.
//

import Foundation

public class CaPlan{
    
    public var nSeqPlanElem: Int = 0
    public var nSeqMeter: Int = 0
    public var strMid : String = ""
    public var strMeterDescr: String = ""
    public var bTop : Bool = false
    public var nHourFrom : Int = 0
    public var nHourTo : Int = 0
    public var nPercentToSave : Int = 0
    public var dSaveKwh : Double = 0.0
    public var dSaveWon : Double = 0.0
    public var dKwhRef : Double = 0.0
    public var dKwhPlan : Double = 0.0
    public var dKwhReal : Double = 0.0
    public var dWonRef : Double = 0.0
    public var dWonPlan : Double = 0.0
    public var dWonReal : Double = 0.0
    
    public var bAllChecked : Bool = true
    
  
    public var alAct : Array<CaAct> = Array()
    
}
