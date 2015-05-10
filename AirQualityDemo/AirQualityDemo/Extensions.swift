//
//  Extensions.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 10/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//

import UIKit

func randomDouble() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX)
}

func randomCGFloat() -> CGFloat {
    return CGFloat(randomDouble())
}
