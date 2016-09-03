//
//  ViewController.swift
//  StateManager
//
//  Created by Kevin Zhang on 2016-08-31.
//  Copyright © 2016 Kevin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var outgoingButton: UIButton!
//    var buttonSize:CGFloat = 100
//  
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
    
    enum outgoingButtonState {
        case Standby // 0
        case RecordingStarted
        case RecordingLongEnough // 2
        case Finished // 5
        case Muted
        case PromptForInternet
        case AskForAudioPermission
        case Unknown // 6
        case Err
        case Failed
    }
    
    var state: outgoingButtonState = .Muted{
        didSet{
            switch (oldValue, state){
            case (.Muted, .PromptForInternet):
                break
            case (.Muted, .AskForAudioPermission):
                break
            case (.AskForAudioPermission, .Standby):
                break
            case (.PromptForInternet, .Standby):
                assert(false, "Should not be here!!")
            case (.Standby, .RecordingStarted):
                break
            case (.RecordingStarted, .RecordingLongEnough):
                break
            case (.RecordingStarted, .Finished):
                break
            case (.Finished, .Standby):
                break
            case (.Failed, .Standby):
                break
            case (.Finished, .Standby):
                break
            case (let x, .Err):
                print("state x.hashValue: \(x.hashValue)")
            default:
                print("oldValue: \(oldValue.hashValue), state: \(state.hashValue)")
                assert(false, "OOPS!!!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       //before adding outgoing button
        //4 things must be checked
//        verifyInternetConnection(true)
//        verifyCoreLocationPermission(true)
//        verifyAudioPermission(true)
//        verifyPushNotificationPermission(true)
        InternetConnectionSwitch.addTarget(self, action: #selector(ViewController.internetConnetionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(InternetConnectionSwitch)
        
        CoreLocationPermissionSwitch.addTarget(self, action: #selector(ViewController.coreLocationPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(CoreLocationPermissionSwitch)
        
        AudioPermissionSwitch.addTarget(self, action: #selector(ViewController.audioPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(AudioPermissionSwitch)
        
        PushNotificationPermissionSwitch.addTarget(self, action: #selector(ViewController.pushNotificationPermissionVerifier(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(PushNotificationPermissionSwitch)
        
        
        //addOutgoingButton()
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
//       outgoingButton = UIButton(frame: CGRect(x: 100, y: 400, width: buttonSize, height: buttonSize))
//        outgoingButton.backgroundColor = UIColor.redColor()
//        outgoingButton.addTarget(self, action: #selector(ViewController.outgoingButtonTouchedDown(_:)), forControlEvents: UIControlEvents.TouchDown)
//        outgoingButton.addTarget(self, action: #selector(ViewController.outgoingButtonTouchedUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        outgoingButton.addTarget(self, action: #selector(ViewController.outgoingButtonTouchDraggedExit(_:)), forControlEvents: UIControlEvents.TouchDragExit)
//        
//        view.addSubview(outgoingButton)
        // set up recorder button
        
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
        outgoingButtonState = .RecordingStarted
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
    }
    
//    func outgoingButtonTouchedDown(button:UIButton){
//        print("being touched down")
//        UIView.animateWithDuration(0.07){
//            self.outgoingButton.backgroundColor = UIColor.blackColor()
//        }
//    }
//    
//    func outgoingButtonTouchedUpInside(button:UIButton){
//        print("being touched up inside")
//        UIView.animateWithDuration(0.07){
//            self.outgoingButton.backgroundColor = UIColor.greenColor()
//        }
//    }
//    
//    func outgoingButtonTouchDraggedExit(button:UIButton){
//        UIView.animateWithDuration(0.07){
//            self.outgoingButton.backgroundColor = UIColor.redColor()
//            print("touchdraggedexited")
//        }
//    }
    
//    func verifyInternetConnection(internet: Bool){
//        if internet {
//            print("internet connection verified")
//        }else{
//            assert(false, "no internet, no button access")
//        }
//    }
//    
//    func verifyCoreLocationPermission(CLPermission: Bool){
//        if CLPermission {
//            print("CLPermission verified")
//        }else{
//            assert(false, "no CLPermission, no button access")
//        }
//    }
//
//    func verifyAudioPermission(AudioPermission: Bool){
//        if AudioPermission {
//            print("AudioPermission verified")
//        }else{
//            assert(false, "no AudioPermission, no button access")
//        }
//    }
//    
//    func verifyPushNotificationPermission(PushPermission: Bool){
//        if PushPermission {
//            print("PushPermission verified")
//        }else{
//            assert(false, "no PushPermission, no button access")
//        }
//    }
    
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

