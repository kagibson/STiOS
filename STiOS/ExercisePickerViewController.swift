//
//  ExercisePickerViewController.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2017-01-22.
//  Copyright © 2017 ECE 4600 G09. All rights reserved.
//

import UIKit
import ExerciseMotionTracker

class ExercisePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let exercises = ["Bicep curl", "Flyes", "Overhead press", "Row", "Tricep extension"];
    
    @IBOutlet weak var exercisePicker: UIPickerView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisePicker.dataSource = self
        exercisePicker.delegate = self
        
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            tbs.currentExercise = BicepCurl(skeleton: tbs.userSkeleton)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // number of picker wheels
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of items on picker wheel
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    // fills in picker wheel
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            let exerciseDelegate = tbs.currentExercise?.exerciseMonitorDelegate
            
            switch (row)
            {
            case 0:
                tbs.currentExercise = BicepCurl(skeleton: tbs.userSkeleton)
                break;
            case 1:
                tbs.currentExercise = Fly(skeleton: tbs.userSkeleton)
                break;
            case 2:
                tbs.currentExercise = OverheadPress(skeleton: tbs.userSkeleton)
                break;
            case 3:
                tbs.currentExercise = Row(skeleton: tbs.userSkeleton)
                break;
            case 4:
                tbs.currentExercise = TricepExtension(skeleton: tbs.userSkeleton)
                break;
            default:
                tbs.currentExercise = BicepCurl(skeleton: tbs.userSkeleton)
                break;
            }
            
            tbs.currentExercise?.exerciseMonitorDelegate = exerciseDelegate // connect back to exerciseMonitorDelegate
            
        }
    }
}
