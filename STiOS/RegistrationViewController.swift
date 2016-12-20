//
//  RegistrationViewController.swift
//  G09 Firebase Demo
//
//  Created by Kurtis Gibson on 2016-11-07.
//  Copyright © 2016 Kurtis Gibson. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController, UITextFieldDelegate, Dismissable {
    
    @IBOutlet weak var emailAddressInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPasswordInput: UITextField!

    weak var dismissalDelegate: DismissalDelegate?
    var emailAddress: String!
    var password: String!
    var confirmPassword: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        // Do any additional setup after loading the view.
        
        emailAddressInput.delegate = self
        passwordInput.delegate = self
        confirmPasswordInput.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil
        {
            if textField == emailAddressInput
            {
                emailAddress = textField.text
            }
            
            else if textField == passwordInput
            {
                password = textField.text
            }
            
            else if textField == confirmPasswordInput
            {
                confirmPassword = textField.text
            }
        }
    }
    
    @IBAction func done()
    {
        dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    
    @IBAction func register()
    {
        if password != nil && confirmPassword != nil && emailAddress != nil
        {
            if password == confirmPassword
            {
                FIRAuth.auth()?.createUser(withEmail: emailAddress, password: password, completion: {user, error in
                    if error != nil
                    {
                        print("Oops! There was an error.")
                    }
                    else
                    {
                        FIRAuth.auth()?.signIn(withEmail: self.emailAddress, password: self.password)
                        // fill in email and password fields upon return to sign-in view
                        if (self.dismissalDelegate is SignInViewController)
                        {
                            let signIn = self.dismissalDelegate as! SignInViewController
                            signIn.emailAddressInput.text = self.emailAddress
                            signIn.passwordInput.text = self.password
                            signIn.emailAddress = self.emailAddress
                            signIn.password = self.password
                        }
                        self.done()
                    }
                
                })
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
