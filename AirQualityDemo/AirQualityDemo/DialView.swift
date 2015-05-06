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
