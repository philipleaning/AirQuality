//
//  GraphView.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 06/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//

import UIKit

@IBDesignable public class GraphView: UIView {
    
    //Customisable graph properties
    public var timeWidth: CGFloat = 10.0/60.0
    public var timeAxisNumberOfValues: Int = 4
    @IBInspectable public var yAxisMax:CGFloat = 10.0
    @IBInspectable public var yAxisMin:CGFloat = 0.0
    public var textHeight:CGFloat = 20.0
    public var textWidth:CGFloat = 20.0
    public var minutesStored: CGFloat = 3*60
    
    //Private variables
    var pointsArray: [(time: CGFloat, yValue: CGFloat)] = []
    
    var startTime: CGFloat {
        return endTime - timeWidth
    }
    
    var endTime: CGFloat {
        if pointsArray.isEmpty { return 1.0 }
        else { return pointsArray.last!.time }
    }
    
    //Drawing properties
    var totalViewHeight: CGFloat = 10.0
    var totalViewWidth: CGFloat = 100.0
    var leftMargin:CGFloat = 20.0
    var rightMargin:CGFloat = 20.0
    
    //Computed drawing area
    var drawingAreaRect: CGRect {
        return CGRect(x: leftMargin, y: 0.0, width: totalViewWidth-leftMargin-rightMargin, height: totalViewHeight)
    }
    
    
    //Init for loading for IB
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Init for rendering in IB
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Populate pointsArray with dummy data
        for  i in 0...1 {addPoint(timeInMinutes: CGFloat(i), yValue: 0.5) }
        for i in 2...10 {addPoint(timeInMinutes: CGFloat(i), yValue: CGFloat(i)*0.8)}
    }
    
    //Drawing routines (called when setNeedsDisplay = true)
    override public func drawRect(rect: CGRect) {
        //Set bounds for whole graph
        totalViewHeight = rect.height - textHeight
        totalViewWidth = rect.width
        
        //Plot pointsArray as a bezierCurve
        let curve = UIBezierPath()
        for (index, point) in enumerate(pointsArray) {
            //Calculate the next point in screen co-ords
            let nextPoint = CGPoint(x: drawingAreaRect.origin.x + (point.time-startTime)/timeWidth * drawingAreaRect.width, y: totalViewHeight * (1 - (point.yValue-yAxisMin)/(yAxisMax - yAxisMin)))
            //Adjust this point so anything below the axis is not shown (actually, drawn behind axis line)
            let drawnPoint = CGPoint(x: nextPoint.x, y: min(drawingAreaRect.height, nextPoint.y))
            if index == 0 {curve.moveToPoint(drawnPoint)}
            else {curve.addLineToPoint(drawnPoint)}
        }
        
        UIColor.redColor().setStroke()
        curve.stroke()
        
        drawAxisLines()
        
        //Draw y axis text labels in rects
        let maxTextRect = CGRect(x: totalViewWidth - textWidth*1.6, y: 0.0, width: textWidth*1.6, height: textHeight)
        drawDouble(double: Double(yAxisMax), inRect: maxTextRect)
        
        let minTextRect = CGRect(x: totalViewWidth - textWidth, y: totalViewHeight - textHeight, width: textWidth, height: textHeight)
        drawDouble(double: Double(yAxisMin), inRect: minTextRect)
        
        drawTimeAxisLabels()
    }
    
    public func addPoint(#timeInMinutes: CGFloat, #yValue: CGFloat) {
        //Add point to store
        pointsArray += [(time: CGFloat(timeInMinutes), yValue: CGFloat(yValue))]
        //Remove points outside required range
        for (index, point) in enumerate(pointsArray) {
            if point.time < startTime {
                pointsArray.removeAtIndex(index)
            }
            break
        }
    }
    
    func drawDouble(double aDouble: Double, inRect theRect: CGRect) {
        let text: NSString = NSString(string: String(format:"%2.1f", aDouble))
        let font = UIFont(name: "Helvetica", size: 15.0)
        
        if let actualFont = font {
            let textFontAttributes = [
                NSFontAttributeName: actualFont,
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle()
            ]
            text.drawInRect(theRect, withAttributes: textFontAttributes)
        }
        
    }
    
    func drawString(string aString: String, inRect theRect: CGRect) {
        let text: NSString = NSString(string: aString)
        let font = UIFont(name: "Helvetica", size: 15.0)
        
        if let actualFont = font {
            let textFontAttributes = [
                NSFontAttributeName: actualFont,
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle()
            ]
            text.drawInRect(theRect, withAttributes: textFontAttributes)
        }
        
    }
    
    func drawTimeAxisLabels() {
        /* Old labelling style, N evenly space labels
        let rectSpacing: CGFloat = drawingAreaRect.width / CGFloat(timeAxisNumberOfValues - 1)
        let timePerLength:CGFloat = timeWidth / drawingAreaRect.width
        for i in 0..<timeAxisNumberOfValues {
        let textRect = CGRect(x: leftMargin+CGFloat(i)*rectSpacing - textWidth/CGFloat(2.0), y: totalViewHeight, width: textWidth, height: textHeight)
        let doubleToDraw = Double(startTime + CGFloat(i)*rectSpacing*timePerLength)
        drawDouble(double: doubleToDraw, inRect: textRect)
        }
        */
        //New style: Draw "-(timeWidth)mins" and "Now"
        let leftRect = CGRect(x: leftMargin - textWidth/CGFloat(2.0), y: totalViewHeight, width: 50, height: textHeight)
        let rightRect = CGRect(x: leftMargin+drawingAreaRect.width - textWidth/CGFloat(2.0), y: totalViewHeight, width: 60, height: textHeight)
        drawString(string: "Now", inRect: rightRect)
        if timeWidth > 1 {
            drawString(string: "-\(Int(timeWidth)) mins", inRect: leftRect)
        }
        else if timeWidth < 1 {
            let timeInSeconds = Int(timeWidth*60.0)
            drawString(string: "-\(timeInSeconds) sec", inRect: leftRect)
        }
    }
    
    func drawAxisLines() {
        //Draw y axis horizontal lines
        let yAxisMaxLine = UIBezierPath()
        let yAxisMinLine = UIBezierPath()
        
        yAxisMaxLine.moveToPoint(CGPoint(x: 0.0, y: 0.0))
        yAxisMaxLine.addLineToPoint(CGPoint(x: totalViewWidth, y: 0.0))
        yAxisMinLine.moveToPoint(CGPoint(x: 0.0, y: totalViewHeight))
        yAxisMinLine.addLineToPoint(CGPoint(x: totalViewWidth, y: totalViewHeight))
        
        let patternForDashes: [CGFloat] = [5.0, 5.0]
        UIColor.darkGrayColor().setStroke()
        yAxisMaxLine.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)
        yAxisMinLine.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)
        yAxisMaxLine.stroke()
        yAxisMinLine.stroke()
    }
}