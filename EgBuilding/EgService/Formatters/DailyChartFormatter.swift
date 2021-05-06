//
//  xAxisValueFormatter.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/12/04.
//

import UIKit
import Foundation
import Charts

@objc(DailyChartFormatter)
public class DailyChartFormatter: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(24-Int(value))+"시"
    }
}
