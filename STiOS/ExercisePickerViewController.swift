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
    
    let exercises = ["Bicep curl", "Shoulder press", "Chest flies", "Leg extension"];
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
}
