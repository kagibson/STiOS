//
//  AuthenticationViewController.swift
//  G09 Firebase Demo
//
//  Created by Kurtis Gibson on 2016-11-07.
//  Copyright © 2016 Kurtis Gibson. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddressInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var emailAddress: String!
    var password: String!
    
    let SeguePatientListViewController = "PatientListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailAddressInput.delegate = self
        passwordInput.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""
        {
            if textField == emailAddressInput
            {
                emailAddress = textField.text
            }
                
            else if textField == passwordInput
            {
                password = textField.text
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func segueToPatientList()
    {
        performSegue(withIdentifier: SeguePatientListViewController, sender: view)
    }
    
    func signinError()
    {
        let alert = UIAlertController(title: "Incorrect Sign-In", message: "Your email address or password were entered incorrectly.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signInUser()
    {
        if emailAddress != nil && password != nil
        {
            FIRAuth.auth()?.signIn(withEmail: emailAddress, password: password, completion: { user, error in
                if error != nil
                {
                    self.signinError()
                }
                
                else
                {
                    self.segueToPatientList()
                }
            })
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
