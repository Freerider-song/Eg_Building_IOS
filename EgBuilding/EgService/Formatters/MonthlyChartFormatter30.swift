//
//  MonthlyChartFormatter30.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/12/08.
//

import UIKit
import Foundation
import Charts

@objc(MonthlyChartFormatter30)
public class MonthlyChartFormatter30: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value==0 ? "다음달 1일" : String(31-Int(value))+"일"
    }
}
