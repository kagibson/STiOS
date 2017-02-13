//
//  CustomTabBarController.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2017-01-19.
//  Copyright © 2017 ECE 4600 G09. All rights reserved.
//

import UIKit
import ExerciseMotionTracker

class SessionTabBarController: UITabBarController, Dismissable {
    
    weak var dismissalDelegate: DismissalDelegate?
    var selectedPatient = Patient()
    let userSkeleton = Skeleton()
    var currentExercise: ExerciseMonitor?
    
    }
