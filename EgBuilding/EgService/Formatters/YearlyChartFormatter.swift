//
//  YearlyChartFormatter.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/12/08.
//
import UIKit
import Foundation
import Charts

@objc(YearlyChartFormatter)
public class YearlyChartFormatter: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value==0 ? "다음년 1월" : String(13-Int(value))+"월"
    }
}
