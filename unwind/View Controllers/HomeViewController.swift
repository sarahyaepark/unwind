//
//  HomeViewController.swift
//  unwind
//
//  Created by Sarah Park on 4/29/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class HomeViewController: UIViewController {

//    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logo: UILabel!
    @IBOutlet weak var welcome: UILabel!
    
    @IBOutlet weak var goal1: UILabel!
    @IBOutlet weak var goal2: UILabel!
    @IBOutlet weak var goal3: UILabel!
    
    @IBOutlet weak var goal1Button: UIButton!
    @IBOutlet weak var goal2Button: UIButton!
    @IBOutlet weak var goal3Button: UIButton!
    
    @IBOutlet weak var goalsList: UIStackView!
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!

    @IBOutlet weak var smileTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    let db = Firestore.firestore()
    func setUpElements() {
        // style elements
//        goal1.alpha = 0
//        goal2.alpha = 0
//        goal3.alpha = 0
        goalsList.alpha = 0
        smileTextField.alpha = 0
        submitButton.alpha = 0
        Utilities.styleText(welcome)
        Utilities.styleText(userName)
        Utilities.styleText(question)
        Utilities.styleText(goal1)
        Utilities.styleText(goal2)
        Utilities.styleText(goal3)
        Utilities.styleMoodButton(happyButton)
        Utilities.styleMoodButton(sadButton)
//        Utilities.styleTabBar(tabBar)
        Utilities.styleHollowButton(submitButton)
        Utilities.styleHappyField(smileTextField)
        smileTextField.attributedPlaceholder = NSAttributedString(string: "What made you smile today? (optional)",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let uid = getUid()
        let date = currentDate()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("goal1") as! String
                let property2 = document.get("goal2") as! String
                let property3 = document.get("goal3") as! String
                print(date)
                self.db.collection("users").document(uid).collection(date).document("nightlyRitual").setData([property: false, property2: false, property3: false, "happy": false, "sad": false])
                let currentRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                currentRef.getDocument(source: .cache) { (innerDocument, error) in
                    if let innerDocument = innerDocument {
                        let goalBool = innerDocument.get(property) as? Bool
                        if goalBool! != true {
                            print("setting button hollow")
                            Utilities.roundButtonHollow(self.goal1Button)
                        } else {
                            print("setting button filled")
                            Utilities.roundButtonFilled(self.goal1Button)
                        }
                        let goalBool2 = innerDocument.get(property2) as? Bool
                        if goalBool2! != true {
                            print("setting button hollow")
                            Utilities.roundButtonHollow(self.goal2Button)
                        } else {
                            print("setting button filled")
                            Utilities.roundButtonFilled(self.goal2Button)
                        }
                        let goalBool3 = innerDocument.get(property3) as? Bool
                        if goalBool3! != true {
                            print("setting button hollow")
                            Utilities.roundButtonHollow(self.goal3Button)
                        } else {
                            print("setting button filled")
                            Utilities.roundButtonFilled(self.goal3Button)
                        }
                    }
                }
            }
        }
    }
    
    func getUid() -> String {
        let loggedInUser = Auth.auth().currentUser
        var uid = ""
        if let loggedInUser = loggedInUser {
        // user is signed in
            uid = loggedInUser.uid
        }
        return uid
    }
    
    func setGoals() {
        let uid = getUid()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("goal1")
                let property2 = document.get("goal2")
                let property3 = document.get("goal3")
                self.goal1.text = property as? String ?? ""
//                self.goal1.alpha = 1
                self.goal2.text = property2 as? String ?? ""
//                self.goal2.alpha = 1
                self.goal3.text = property3 as? String ?? ""
//                self.goal3.alpha = 1
            }
        }
    }
    
    func transitionToGoodnight() {
        let goodnightViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.goodnightViewController) as? GoodnightViewController

        view.window?.rootViewController = goodnightViewController
        view.window?.makeKeyAndVisible()
    }
    
    func currentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
    func getUserName() {
        let uid = getUid()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("firstName")
                self.userName.text = property as? String ?? ""
                self.userName.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpElements()
        listDates()
        self.view.backgroundColor = UIColor(red: 0.16, green: 0.05, blue: 0.23, alpha: 1.00)
        userName.alpha = 0
        let logoColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        logo.textColor = logoColor
        self.getUserName()
        self.setGoals()
    }
    
    func listDates() {
        let uid = getUid()
        let date = Date()
//        let datesArray = db.collection("users").document(uid)
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                var datesArray:Array? = document.get("datesArray") as? Array<Date>
                if datesArray != nil {
                if datesArray!.contains(date) {
                    // do nothing
                    return
                } else {
                    datesArray?.append(date)
                    docRef.updateData(["datesArray": datesArray])
                    print("DATESaRRAY", datesArray)
                }
                }
            }
        }

    }

    
    
    @IBAction func happyButtonTapped(_ sender: Any) {
        goalsList.alpha = 1
        smileTextField.alpha = 1
        submitButton.alpha = 1
        let uid = getUid()
        let date = currentDate()
        let nightlyRitualRef = db.collection("users").document(uid).collection(date).document("nightlyRitual")
        nightlyRitualRef.updateData(["happy": true, "sad": false])
    }

    @IBAction func sadButtonTapped(_ sender: Any) {
        goalsList.alpha = 1
        smileTextField.alpha = 1
        submitButton.alpha = 1
        let uid = getUid()
        let date = currentDate()
        let nightlyRitualRef = db.collection("users").document(uid).collection(date).document("nightlyRitual")
        nightlyRitualRef.updateData(["happy": false, "sad": true])
    }
    //check list
    
    @IBAction func goal1Tapped(_ sender: Any) {
        let uid = getUid()
        let date = currentDate()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("goal1") as? String
                let currentRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                currentRef.getDocument(source: .cache) { (innerDocument, error) in
                    if let innerDocument = innerDocument {
                        let goalBool = innerDocument.get(property) as? Bool
                        if goalBool! == true {
                            Utilities.roundButtonHollow(self.goal1Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: false])
                        } else {
                            Utilities.roundButtonFilled(self.goal1Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: true])
                        }
                    }
                }
            }
        }
    }
    @IBAction func goal2Tapped(_ sender: Any) {
        let uid = getUid()
        let date = currentDate()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("goal2") as? String
                let currentRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                currentRef.getDocument(source: .cache) { (innerDocument, error) in
                    if let innerDocument = innerDocument {
                        let goalBool = innerDocument.get(property) as? Bool
                        if goalBool! == true {
                            Utilities.roundButtonHollow(self.goal2Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: false])
                        } else {
                            Utilities.roundButtonFilled(self.goal2Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: true])
                        }
                    }
                }
            }
        }
    }
    @IBAction func goal3Tapped(_ sender: Any) {
        let uid = getUid()
        let date = currentDate()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let property = document.get("goal3") as? String
                let currentRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                currentRef.getDocument(source: .cache) { (innerDocument, error) in
                    if let innerDocument = innerDocument {
                        let goalBool = innerDocument.get(property) as? Bool
                        if goalBool! == true {
                            Utilities.roundButtonHollow(self.goal3Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: false])
                        } else {
                            Utilities.roundButtonFilled(self.goal3Button)
                            let nightlyRitualRef = self.db.collection("users").document(uid).collection(date).document("nightlyRitual")
                            nightlyRitualRef.updateData([property: true])
                        }
                    }
                }
            }
        }
    }
    @IBAction func submitTapped(_ sender: Any) {
        let uid = getUid()
        let date = currentDate()
        let smileReason = smileTextField.text!
        db.collection("users").document(uid).collection(date).document("nightlyRitual").setData(["reason": smileReason, "submit": true], merge: true) { (error) in
            if let error = error {
                // do nothing
            } else {
                print("save success!")
            }
        }

        self.transitionToGoodnight()
    }
    
}
