//
//  Protocols.swift
//  STiOS
//
//  Created by Kurtis Gibson on 2016-12-19.
//  Copyright © 2016 ECE 4600 G09. All rights reserved.
//

import Foundation
import UIKit


protocol DismissalDelegate : class
{
    func finishedShowing(viewController: UIViewController);
}

protocol Dismissable : class
{
    weak var dismissalDelegate : DismissalDelegate? { get set }
}

/*extension DismissalDelegate where Self: UIViewController
{
    func finishedShowing(viewController: UIViewController) {
        print(viewController.presentingViewController)
        print(self)
            
        
        if viewController.isBeingPresented && viewController.presentingViewController == self
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
} */
