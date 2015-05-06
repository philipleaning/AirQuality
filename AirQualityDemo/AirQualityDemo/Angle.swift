//
//  Angle.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 06/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Angle {
    var degrees: Double {
        didSet {
            degrees %= 360.0
        }
    }
    
    init(degrees: Double) {
        self.degrees = degrees
    }
    
    init(radians: Double) {
        self.degrees = 180 * radians / M_PI
    }
    
    var radians: Double {
        get {
            return M_PI * degrees / 180
        }
        set {
            degrees = 180 * newValue / M_PI
        }
    }
}

prefix func -(angle: Angle) -> Angle {
    return Angle(degrees: -angle.degrees)
}

func + (lhs: Angle, rhs: Angle) -> Angle {
    return Angle(degrees: lhs.degrees + rhs.degrees)
}

func - (lhs: Angle, rhs: Angle) -> Angle {
    return Angle(degrees: lhs.degrees - rhs.degrees)
}

func * (left: Double, right: Angle) -> Angle {
    return Angle(degrees: left * right.degrees)
}

func += (inout left: Angle, right: Angle) {
    left = left + right
}

extension Angle: Printable {
    var description: String {
        return "degrees \(degrees)"
    }
}


func cos(angle: Angle) -> Double {
    return cos(angle.radians)
}

func sin(angle: Angle) -> Double {
    return sin(angle.radians)
}

func tan(angle: Angle) -> Double {
    return tan(angle.radians)
}

func acosToAngle(double: Double) -> Angle {
    let value: Double = acos(double)
    return Angle(radians: value)
}

func asinToAngle(double: Double) -> Angle {
    let value: Double = asin(double)
    return Angle(radians: value)
}

func atanToAngle(double: Double) -> Angle {
    let value: Double = atan(double)
    return Angle(radians: value)
}



func getAngleFromDate(date: NSDate) -> Angle {
    let componentHour   = NSCalendar.currentCalendar()
        .component(NSCalendarUnit.HourCalendarUnit,   fromDate: date)
    
    let componentMinute = NSCalendar.currentCalendar()
        .component(NSCalendarUnit.MinuteCalendarUnit, fromDate: date)
    
    // Minutes from noon or midnight
    let minuteTime = Double(componentHour * 60 + componentMinute)
    let degreesPerMinute: Double = 360.0 / (60 * 12)
    
    return Angle(degrees: (270.0 + minuteTime * degreesPerMinute) % 360)
}

extension CGPoint {
    init(date: NSDate, radius: CGFloat, center: CGPoint) {
        self.x = center.x + radius * CGFloat(cos(getAngleFromDate(date)))
        self.y = center.y + radius * CGFloat(sin(getAngleFromDate(date)))
    }
    
    init(angle: Angle, radius: CGFloat, center: CGPoint) {
        self.x = center.x + radius * CGFloat(cos(angle))
        self.y = center.y + radius * CGFloat(sin(angle))
    }
}

extension CGPoint {
    func clockwiseFrom(secondPoint: CGPoint, relativeTo center: CGPoint) -> Bool {
        return crossProduct(CGVector(startPoint: center,endPoint: self), CGVector(startPoint: center,endPoint: secondPoint)) >= 0
    }
}

extension CGVector {
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.dx = endPoint.x - startPoint.x
        self.dy = endPoint.y - startPoint.y
    }
}

func crossProduct(vectorA: CGVector, vectorB: CGVector) -> CGFloat {
    return vectorA.dx * vectorB.dy - vectorB.dx * vectorA.dy
}
