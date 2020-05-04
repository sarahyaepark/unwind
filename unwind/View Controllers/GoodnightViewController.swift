//
//  SignUpViewController.swift
//  unwind
//
//  Created by Sarah Park on 4/29/20.
//  Copyright © 2020 Sarah Park. All rights reserved.
//

import UIKit
import AVKit

class GoodnightViewController: UIViewController {

    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet weak var goodnight: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
        Utilities.styleText(goodnight)
    }
    
    func setUpVideo() {
        
        // get path to resource in bundle
        let bundlePath = Bundle.main.path(forResource: "goodnightbg", ofType: "mp4")
        
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
        videoPlayer?.playImmediately(atRate: 0.9)
    }

}

