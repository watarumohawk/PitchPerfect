//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Wataru on 2016/05/03.
//  Copyright © 2016年 Wataru Sekiguchi. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {

    var recordedAudioURL: NSURL!
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRercoder:AVAudioRecorder!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    var duration: NSTimeInterval!
    
    var dataLayer: TAGDataLayer = TAGManager.instance().dataLayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlaySoundViewController loaded")
        
        dataLayer.push(["event": "OpenScreen", "screenName": "PlayScreen1"])
        
        setupAudio()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        configureUI(.NotPlaying)
        
        let name = "PlayScreen"
        
        let tracker = GAI.sharedInstance().defaultTracker
        // Demographics
        tracker.allowIDFACollection = true
    
        tracker.set(kGAIScreenName, value: name)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    enum ButtonType: Int { case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb}
    
    @IBAction func playSoundForButton(sender: UIButton) {
        
        print("Play Sound Button Pressed")
        
        switch(ButtonType(rawValue: sender.tag)!) {
            
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(.Playing)
        
    }
    
    @IBAction func stopSoundForButton(sender: AnyObject) {
        print("Stop Audio Button Pressed")
        
        let name = "PlayScreen 1"
        
        let tracker = GAI.sharedInstance().defaultTracker
        
        // Demographics
        tracker.allowIDFACollection = true
        
        tracker.set(kGAIScreenName, value: name)
        let builder = GAIDictionaryBuilder.createEventWithCategory("category", action: "action", label: "label", value: 200)
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        stopAudio()
    }


}





