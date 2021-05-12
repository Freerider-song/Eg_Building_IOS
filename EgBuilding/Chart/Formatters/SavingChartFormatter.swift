//
//  SavingChartFormatter.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/12.
//

import UIKit
import Foundation
import Charts

@objc(SavingChartFormatter)
public class SavingChartFormatter: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(Int(value))+"일"
    }
}
