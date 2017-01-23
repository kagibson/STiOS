//
//  ExercisePickerViewController.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2017-01-22.
//  Copyright © 2017 ECE 4600 G09. All rights reserved.
//

import UIKit

class ExercisePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let exercises = ["Bicep curl", "Shoulder press", "Flies", "Leg extension"];
    @IBOutlet weak var exercisePicker: UIPickerView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisePicker.dataSource = self
        exercisePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }
}
