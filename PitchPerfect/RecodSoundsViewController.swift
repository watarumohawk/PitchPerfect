//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Wataru on 2016/05/03.
//  Copyright © 2016年 Wataru Sekiguchi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        let name = "RecordScreen"
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        // Demographics
        tracker.allowIDFACollection = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
        recordingLabel.text = "Tap to Record"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
        let recordedAudioURL = sender as! NSURL
        playSoundsVC.recordedAudioURL = recordedAudioURL
        
    }

    @IBAction func recordingAudio(sender: AnyObject) {
        print("record button pressed")
        
        setupUI(recording: true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        let recordingName = "recordedVoice.wav"
        let PathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(PathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)

        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings:[:])

        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        
        setupUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("AVAudioRecorder finished saveing recording")

        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
        
    }

    func setupUI(recording recording: Bool) {
        recordButton.enabled = !recording
        stopRecordingButton.enabled = recording
        recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch. Here you can out the code you want.
//        FIRApp.configure()   
        return true
    }
    
}