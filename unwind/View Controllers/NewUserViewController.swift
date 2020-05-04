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

class NewUserViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var unwind: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        print("here")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.time.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.to.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
            self.unwind.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            self.transition()
        }
    }
    
    func setUpElements() {
        time.alpha = 0
        to.alpha = 0
        unwind.alpha = 0
        self.view.backgroundColor = UIColor(red: 0.16, green: 0.05, blue: 0.23, alpha: 1.00)
        let logoColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        let textColor = UIColor(red: 0.83, green: 0.72, blue: 0.85, alpha: 1.00)
        time.textColor = textColor
        to.textColor = textColor
        unwind.textColor = logoColor
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
    
    func currentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
    
    func transition() {
        let db = Firestore.firestore()
        let uid = getUid()
        let date = currentDate()
        
        let docRef = db.collection("users").document(uid).collection(date).document("nightlyRitual")
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                var submitted: Bool? = document.get("submit") as? Bool
                if submitted == nil {
                    let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? UITabBarController
                    
                    self.view.window?.rootViewController = tabBarController
                    self.view.window?.makeKeyAndVisible()
                } else {
                    let goodnightViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.goodnightViewController) as? GoodnightViewController
                    
                    self.view.window?.rootViewController = goodnightViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
    }

}

