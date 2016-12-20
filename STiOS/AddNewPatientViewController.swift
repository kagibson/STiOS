//
//  AddNewPatientViewController.swift
//  
//
//  Created by Kurtis Gibson on 2016-10-29.
//
//

import UIKit
import Firebase
import FirebaseAuth

struct Patient
{
    var firstName = ""
    var lastName = ""
    var shoulderWidth: Double = 0
    var upperArmLength: Double = 0
    var lowerArmLength: Double = 0
    
    init?(patientData: Dictionary<String, AnyObject>) {
        if let fN = patientData["firstName"] as! String!, fN.characters.count > 0, let lN = patientData["lastName"] as! String!, lN.characters.count > 0, let sW = patientData["shoulderWidth"] as! Double!, sW > 0, let uAL = patientData["upperArmLength"] as! Double!, uAL > 0, let lAL = patientData["lowerArmLength"] as! Double!, lAL > 0
        {
            firstName = fN
            lastName = lN
            shoulderWidth = sW
            upperArmLength = uAL
            lowerArmLength = lAL
        }
        else
        {
            return nil
        }
    }
    
    init()
    {
        
    }
    
    func printProperties()
    {
        print(firstName)
        print(lastName)
        print(shoulderWidth)
        print(upperArmLength)
        print(lowerArmLength)
    }
    
}

class AddNewPatientViewController: UIViewController, UITextFieldDelegate, Dismissable {
    var newPatient = Patient()
    var ref: FIRDatabaseReference!
    var currentUser: FIRUser!
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var shoulderWidthInput: UITextField!
    @IBOutlet weak var upperArmLengthInput: UITextField!
    @IBOutlet weak var lowerArmLengthInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        shoulderWidthInput.delegate = self
        upperArmLengthInput.delegate = self
        lowerArmLengthInput.delegate = self
        
        FIRAuth.auth()?.addStateDidChangeListener {auth, user in
            if let user = user
            {
                self.currentUser = user
                self.ref = FIRDatabase.database().reference(withPath: self.currentUser.uid)
            }
                
            else
            {
                // no user is signed in
            }
            
        }
        
        
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
        if (textField.text != "")
        {
            if (textField == firstNameInput)
            {
                newPatient.firstName = textField.text!
            }
            else if (textField == lastNameInput)
            {
                newPatient.lastName = textField.text!
            }
            else if (textField == shoulderWidthInput)
            {
                if let shoulderWidth = Double(textField.text!)
                {
                    newPatient.shoulderWidth = shoulderWidth
                }
            }
            else if (textField == upperArmLengthInput)
            {
                if let upperArmLength = Double(textField.text!)
                {
                    newPatient.upperArmLength = upperArmLength
                }

            }
            else if (textField == lowerArmLengthInput)
            {
                if let lowerArmLength = Double(textField.text!)
                {
                    newPatient.lowerArmLength = lowerArmLength
                }
            }
            
        }


    }
    
    @IBAction func done()
    {
        print(self.isBeingPresented)
        dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    @IBAction func addNewPatientPress()
    {
        if ((newPatient.firstName != "") && (newPatient.lastName != "") && (newPatient.shoulderWidth != 0) && (newPatient.upperArmLength != 0) && (newPatient.lowerArmLength != 0))
        {
            let newEntry: FIRDatabaseReference = self.ref.childByAutoId()
            newEntry.child("firstName").setValue(newPatient.firstName)
            newEntry.child("lastName").setValue(newPatient.lastName)
            newEntry.child("shoulderWidth").setValue(newPatient.shoulderWidth)
            newEntry.child("upperArmLength").setValue(newPatient.upperArmLength)
            newEntry.child("lowerArmLength").setValue(newPatient.lowerArmLength)


        }
        self.done()
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
