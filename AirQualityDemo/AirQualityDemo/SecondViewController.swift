//
//  SecondViewController.swift
//  AirQualityDemo
//
//  Created by Philip Leaning on 06/05/2015.
//  Copyright (c) 2015 CCMOS Ltd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    let airSensor = testSensor()
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        graphView.timeWidth = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // On view appearing
        graphView.addPoint(timeInMinutes: airSensor.getLatestValues().mins, yValue: airSensor.getLatestValues().value)
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        graphView.addPoint(timeInMinutes: airSensor.getLatestValues().mins, yValue: airSensor.getLatestValues().value)
        graphView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

