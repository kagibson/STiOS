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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if var level = (tbs.currentExercise?.getPercentComplete())
            {
                // convert from per unit to percentage
                level *= 100
                exerciseCompletionLevelText?.text = "\(level)"
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
