//
//  ExerciseDataViewController.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2017-02-13.
//  Copyright © 2017 ECE 4600 G09. All rights reserved.
//

import UIKit
import ExerciseMotionTracker

class ExerciseDataViewController: UIViewController, ExerciseMonitorDelegate {
    
    @IBOutlet weak var exerciseCompletionLevelText: UILabel?
    
    var isRunning: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        isRunning = false
        
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            tbs.currentExercise?.exerciseMonitorDelegate = self
        }

        // Do any additional setup after loading the view.
        exerciseCompletionLevelText?.text = "/connect BT!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func completionLevelDidUpdate() {
        // display exercise completion level when an update is received
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            if (isRunning)!
            {
                if let level = (tbs.currentExercise?.getPercentComplete())
                {
                    if(level == 666) // error code
                    {
                        exerciseCompletionLevelText?.text = "Straighten your arms."
                    }
                    else
                    {
                        exerciseCompletionLevelText?.text = "\(level)"
                    }
                
                }
            }
            
            else
            {
                exerciseCompletionLevelText?.text = "Press start to begin"
            }
        }
    }
    
    @IBAction func startExercise()
    {
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            tbs.currentExercise?.initAngle()
        }
        isRunning = true
    }
    
    @IBAction func stopExercise()
    {
        isRunning = false
    }
    

}
