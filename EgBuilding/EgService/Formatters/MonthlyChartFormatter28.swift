//
//  MonthlyChartFormatter28.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/12/08.
//

import UIKit
import Foundation
import Charts

@objc(MonthlyChartFormatter28)
public class MonthlyChartFormatter28: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value==0 ? "다음달 1일" : String(29-Int(value))+"일"
    }
}
