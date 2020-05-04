//
//  SignUpViewController.swift
//  unwind
//
//  Created by Sarah Park on 4/29/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class GoalsViewController: UIViewController {

    
    @IBOutlet weak var unwind: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var goal1textfield: UITextField!
    @IBOutlet weak var goal2textfield: UITextField!
    @IBOutlet weak var goal3textfield: UITextField!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    func validateFields() -> String? {
        // Check that all fields are filled
        if goal1textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            goal2textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            goal3textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all the fields"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setUpElements() {
       
        errorLabel.alpha = 0
        self.view.backgroundColor = UIColor(red: 0.16, green: 0.05, blue: 0.23, alpha: 1.00)
        let logoColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        let textColor = UIColor(red: 0.83, green: 0.72, blue: 0.85, alpha: 1.00)
        unwind.textColor = logoColor
        inputLabel.textColor = textColor
        Utilities.styleFilledButton(goButton)
    }
    
    func transitionToNewUserViewController() {
        let newUserViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.newUserViewController) as? NewUserViewController

        view.window?.rootViewController = newUserViewController
        view.window?.makeKeyAndVisible()
    }
    
    func currentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // gets date and time string from the date object
        let dateString = formatter.string(from: currentDate)
        return dateString
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
    }
    
    
    @IBAction func goTapped(_ sender: Any) {

        //Validate the fields; return nil or error message
        let error = validateFields()
        
        if error != nil {
            // show error message
            showError(error!)
        }
        else {
            // create clean data
            let goal1 = goal1textfield.text!
            let goal2 = goal2textfield.text!
            let goal3 = goal3textfield.text!
            let db = Firestore.firestore()
            let loggedInUser = Auth.auth().currentUser
            if let loggedInUser = loggedInUser {
                // user is signed in
                let uid = loggedInUser.uid
                db.collection("users").document(uid).setData(["goal1": goal1, "goal2":goal2, "goal3":goal3, "datesArray": []], merge: true) { (error) in
                    if let error = error {
                        self.showError("Error saving goals to database")
                    } else {
                        print("save success!")
                    }
                }
//                let dateRef = db.collection("users").document(uid).collection()
                let date = currentDate()
                db.collection("users").document(uid).collection(date).document("nightlyRitual")
                    .setData([goal1: false, goal2: false, goal3: false, "happy": false, "sad": false])
                // transition to home screen
                self.transitionToNewUserViewController()
            }
        }
    
    }
}

