//
//  LoginViewController.swift
//  unwind
//
//  Created by Sarah Park on 4/29/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpElements() {
        // hide error label
        errorLabel.alpha = 0
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // style elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fields"
        }
        return nil
    }
    
    func showError(_ message:String) {
           errorLabel.text = message
           errorLabel.alpha = 1
       }
    func transitionToNewUserViewController() {
        let newUserViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.newUserViewController) as? NewUserViewController

        view.window?.rootViewController = newUserViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func loginTapped(_ sender: Any) {
        // validate text fields
        let error = validateFields()

       if error != nil {
           // show error message
           showError(error!)
       }
       else {
           // create clean data
           let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
            
                if error != nil {
                    // couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    self.transitionToNewUserViewController()
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
