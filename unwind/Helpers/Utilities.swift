//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleHappyField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        textfield.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.50)
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func roundButtonHollow(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor(red: 0.16, green: 0.05, blue: 0.23, alpha: 1.00)
        button.layer.borderColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00).cgColor
        button.layer.cornerRadius = 0.5*button.bounds.size.width
        button.tintColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        button.setTitle("", for: .normal)
    }
    
    static func roundButtonFilled(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00).cgColor
        button.backgroundColor = UIColor.init(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        button.layer.cornerRadius = 0.5*button.bounds.size.width
        button.tintColor = UIColor.white
        button.setTitle("✔️", for: .normal)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 0.63, green: 0.24, blue: 0.59, alpha: 1.00)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleTabBar(_ tabBar: UITabBar) {
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor(red: 0.83, green: 0.72, blue: 0.85, alpha: 1.00)
    }
    
    static func styleMoodButton(_ button:UIButton) {
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 0.39, green: 0.16, blue: 0.49, alpha: 1.00)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleText(_ label:UILabel) {
        label.textColor = UIColor(red: 0.75, green: 0.94, blue: 0.89, alpha: 1.00)
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00).cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
