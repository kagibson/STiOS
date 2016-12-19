//
//  ViewController.swift
//  G09 Firebase Demo
//
//  Created by Kurtis Gibson on 2016-10-27.
//  Copyright © 2016 Kurtis Gibson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class PatientListViewController: UITableViewController {
    
    //@IBOutlet weak var userSelectList: UITableView!
    @IBOutlet weak var testLabel: UILabel!
    
    var ref: FIRDatabaseReference!
    var patients: [Patient] = []
    var selectedPatient: Patient!

    let cellIdentifier = "LabelCell"
    
    var currentUser: FIRUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Patient List"
        // Do any additional setup after loading the view, typically from a nib.
        //userSelectList.delegate = self
        //userSelectList.dataSource = self
        ref = FIRDatabase.database().reference().child("users")
        
        FIRAuth.auth()?.addStateDidChangeListener {auth, user in
            if let user = user
            {
                self.currentUser = user
                self.ref = FIRDatabase.database().reference(withPath: self.currentUser.uid)
                self.getPatientList()
                
            }
            
            else
            {
              // no user is signed in
            }
            
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function of UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // get patient
        let patient = patients[indexPath.row]
        
        cell.textLabel?.text = "\(patient.lastName), \(patient.firstName)"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPatient = patients[indexPath.row]
    }

    // get users from database, create array of User structs, fill in table with user's names
    func getPatientList()
    {
        ref.queryOrdered(byChild: "lastName").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]
            {
                let patientData = child.value as! Dictionary<String, AnyObject>

                if let newPatient = Patient(patientData: patientData)
                {
                    self.patients.append(newPatient)
                }
                
            }
            self.tableView.reloadData()
        })
        
    }

}

