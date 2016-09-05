//
//  ViewController.swift
//  StateManager
//
//  Created by Kevin Zhang on 2016-08-31.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    var recordButton : RecordButton!
    var progressTimer : NSTimer!
    var progress : CGFloat! = 0
    
    var InternetConnectionSwitch = UISwitch(frame: CGRectMake(100, 100, 100, 50))
    var CoreLocationPermissionSwitch = UISwitch(frame: CGRectMake(100, 150, 100, 50))
    var AudioPermissionSwitch = UISwitch(frame: CGRectMake(100, 200, 100, 50))
    var PushNotificationPermissionSwitch = UISwitch(frame: CGRectMake(100, 250, 100, 50))
    
    var hasInternetConnection = false { didSet{ verifyAllConditions() } }
    var hasCoreLocationPermission = false { didSet{ verifyAllConditions() } }
    var hasAudioPermission = false { didSet{ verifyAllConditions() } }
    var hasPushNotificationPermission = false { didSet{ verifyAllConditions() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        InternetConnectionSwitch.addTarget(self, action: #selector(ViewController.internetConnetionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(InternetConnectionSwitch)
        
        CoreLocationPermissionSwitch.addTarget(self, action: #selector(ViewController.coreLocationPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(CoreLocationPermissionSwitch)
        
        AudioPermissionSwitch.addTarget(self, action: #selector(ViewController.audioPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(AudioPermissionSwitch)
        
        PushNotificationPermissionSwitch.addTarget(self, action: #selector(ViewController.pushNotificationPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(PushNotificationPermissionSwitch)
        
        //for testing
        addOutgoingButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyAllConditions(){
        if hasInternetConnection &&
            hasCoreLocationPermission &&
            hasAudioPermission &&
            hasPushNotificationPermission {
            addOutgoingButton()
        }
    }

    func addOutgoingButton() {
        recordButton = RecordButton(frame: CGRectMake(0,0,70,70))
        recordButton.center = self.view.center
        recordButton.progressColor = .redColor()
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(ViewController.record), forControlEvents: .TouchDown)
        recordButton.addTarget(self, action: #selector(ViewController.stop), forControlEvents: UIControlEvents.TouchUpInside)
        recordButton.center.x = self.view.center.x
        view.addSubview(recordButton)

    }
    
    func record() {
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
    }
    
    func updateProgress() {
        
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
    func stop() {
        self.progressTimer.invalidate()
        progress = 0
    }
    
    func internetConnetionVerifier(sender: UIButton) {
        if InternetConnectionSwitch.on {
            print("internet connection verified")
           hasInternetConnection = true
        } else {
            print("No internet connection")
            hasInternetConnection = false
        }
    }
    
    func coreLocationPermissionVerifier(sender: UIButton) {
        if CoreLocationPermissionSwitch.on {
            print("corelocation permission verified")
            hasCoreLocationPermission = true
        } else {
            print("corelocation permission denied")
            hasCoreLocationPermission = false
        }
    }
    
    func audioPermissionVerifier(sender: UIButton) {
        if AudioPermissionSwitch.on {
            print("Audio Permission verified")
            hasAudioPermission = true
        } else {
            print("Audio Permission denied")
            hasAudioPermission = false
        }
    }
    
    func pushNotificationPermissionVerifier(sender: UIButton) {
        if PushNotificationPermissionSwitch.on {
            print("pushNotification Permission verified")
            hasPushNotificationPermission = true
        } else {
            print("pushNotification Permission denied")
            hasPushNotificationPermission = false
        }
    }
}

