//
//  CustomTabBarController.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2017-01-19.
//  Copyright © 2017 ECE 4600 G09. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, Dismissable {
    
    weak var dismissalDelegate: DismissalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
