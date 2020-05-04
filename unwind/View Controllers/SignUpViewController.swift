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
import AVKit

class SignUpViewController: UIViewController {

  
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
        
    }
    
    func setUpElements() {
        // hide error label
        errorLabel.alpha = 0
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // style elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all the fields"
        }
        
        // check if password is valid
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password isn't secure
            return "Please make sure your password is at least 8 characters, contains a special character and a number!"
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToGoals() {
        let goalsViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.goalsViewController) as? GoalsViewController
        
        view.window?.rootViewController = goalsViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields; return nil or error message
        let error = validateFields()
        
        if error != nil {
            // show error message
            showError(error!)
        }
        else {
            // create clean data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    // error creating error
                    self.showError("Failed creating user")
                } else {
                    let db = Firestore.firestore()
                    
//                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid": result!.user.uid ]) {(error) in
//
//                        if error != nil {
//                            // error message
//                            self.showError("Error saving user to database")
//                        }
//                    }
                    db.collection("users").document(result!.user.uid).setData(["firstName": firstName, "lastName":lastName]) { (error) in
                        if let error = error {
                            self.showError("Error saving user to database")
                        } else {
                            print("save success!")
                        }
                    }
                    // transition to home screen
                    self.transitionToGoals()
                }
            }
        
        }
    }
    
    func setUpVideo() {
        
        // get path to resource in bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mov")
        
        guard bundlePath != nil else {
            return
        }
        // create a url from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // create vid player item
        let item = AVPlayerItem(url: url)
        // create player
        videoPlayer = AVPlayer(playerItem: item)
        // create layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        // adjust size and frame
        videoPlayerLayer?.frame = CGRect(x:
            -self.view.frame.size.width*1, y:0, width:self.view.frame.size.width*4, height:self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // add and play
        videoPlayer?.playImmediately(atRate: 0.3)
    }

}

