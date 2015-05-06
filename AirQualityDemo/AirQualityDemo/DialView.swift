//
//  DialWidget.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 06/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//


import UIKit

@IBDesignable class DialView: UIView {
    
    var nibName: String = "DialView"
    
    @IBInspectable var needleColor: UIColor = UIColor.grayColor()
    
    //Init for IB rendering
    override  init(frame: CGRect) {
        //Properties
        super.init(frame: frame)
        //Setup
        setup()
    }
    
    //Init for normal rendering (from IB)
    required init(coder aDecoder: NSCoder) {
        //Properties
        super.init(coder: aDecoder)
        //Setup
        setup()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let startAngle: CGFloat = CGFloat(200 * M_PI / 180.0)
        let endAngle: CGFloat = CGFloat(340 * M_PI / 180.0)

        let radius: CGFloat = min(bounds.width, bounds.height) / 2.0
        
        var scalePath = UIBezierPath()
        scalePath.addArcWithCenter(center, radius: radius - 10, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        scalePath.addArcWithCenter(center, radius: radius - 20, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        scalePath.closePath()
        
        UIColor.lightGrayColor().setFill()
        UIColor.darkGrayColor().setStroke()
        
        scalePath.fill()
        scalePath.stroke()
        
        var needlePath = UIBezierPath()
        
        needlePath.moveToPoint(center)
        
        let endPoint = CGPoint(angle: Angle(degrees: 250), radius: radius - 21.0, center: center)
        
        needlePath.addLineToPoint(endPoint)
        
        needleColor.setStroke()
        needlePath.stroke()
    }
    
    //Setup and loadViewFromNib handle loading xib data in place of view given in IB (the "self" view)
    func setup() {
        let nibView = loadViewFromNib()
        
        nibView.frame = self.bounds
        nibView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        self.addSubview(nibView)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
}
