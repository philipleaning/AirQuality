//
//  AirSensor.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 06/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//

import UIKit


protocol CCMOSSSensor {
    func getLatestValues() -> (mins: CGFloat, value: CGFloat)
}

class testSensor: CCMOSSSensor {
    
    var startTime: NSDate = NSDate()
    
    func getLatestValues() -> (mins: CGFloat, value: CGFloat) {
        let minutesPassed = CGFloat(NSDate().timeIntervalSinceDate(startTime) / 60.0)
        return (mins: minutesPassed, value: 3.0 + randomCGFloat()/CGFloat(10))
        
    }
}