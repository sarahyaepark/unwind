//
//  ViewController.swift
//  unwind
//
//  Created by Sarah Park on 4/29/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?

    @IBOutlet weak var logo: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        let logoColor = UIColor(red: 0.05, green: 0.79, blue: 0.60, alpha: 1.00)
        logo.textColor = logoColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
        
    }
    
    func setUpElements() {
        // style elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)

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
