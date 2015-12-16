//
//  ViewController.swift
//  AugmentedCompass
//
//  Created by Cameron Westbury on 11/16/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import AVFoundation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    
    //MARK: - Moving stuff

    
    @IBOutlet var NLeadingConstraint :NSLayoutConstraint!
    @IBOutlet var NELeadingConstraint : NSLayoutConstraint!
    @IBOutlet var ELeadingConstraint : NSLayoutConstraint!
    @IBOutlet var SELeadingConstraint : NSLayoutConstraint!
    @IBOutlet var SLeadingConstraint : NSLayoutConstraint!
    @IBOutlet var SWLeadingConstraint : NSLayoutConstraint!
    @IBOutlet var WLeadingConstraint : NSLayoutConstraint!
    @IBOutlet var NWLeadingConstraint : NSLayoutConstraint!
    
    func setConstraint(direction: Int, var headingFloat: Double, constraint: NSLayoutConstraint) {
        if headingFloat >= 340 {
            headingFloat = headingFloat - 360
        }
        let screenWidth = UIScreen.mainScreen().bounds.width
        let DegreeShift = (screenWidth * 1.50) //- 12.75
       // let pixelDegreeScreenSize = (screenWidth * -0.23636363) + 118.63636363
        let pixelPerDegree = (screenWidth / 30.0) as CGFloat 
        let labelWidth = 150.0 as CGFloat
        let xPos = ((screenWidth / 2) - (labelWidth / 2) + DegreeShift * CGFloat(direction)) as CGFloat
        let xPosWithDegrees = xPos - (pixelPerDegree * CGFloat(headingFloat))
        constraint.constant = xPosWithDegrees
        
       // print("ScreenWidth: \(screenWidth) Xpos \(xPos) XposWD \(xPosWithDegrees)")
    }
    
//    func setConstraint(direction: Int, var headingFloat: Double, constraint: NSLayoutConstraint) {
//        if headingFloat >= 340 {
//            headingFloat = headingFloat - 360
//        }
//        let screenWidth = UIScreen.mainScreen().bounds.width
//        let pixelPerDegree = (screenWidth / 30.0) as CGFloat
//        let DegreeShift = CGFloat(1150)
//        let labelWidth = 150.0 as CGFloat
//        let xPos = ((screenWidth / 2) - (labelWidth / 2) + DegreeShift * CGFloat(direction)) as CGFloat
//        let xPosWithDegrees = xPos - (pixelPerDegree * CGFloat(headingFloat))
//        constraint.constant = xPosWithDegrees
//        
//        print("ScreenWidth: \(screenWidth) Xpos \(xPos) XposWD \(xPosWithDegrees)")
//    }
    

    func moveLabel(headingFloat :Double) {
        setConstraint(0, headingFloat: headingFloat, constraint: NLeadingConstraint)
        setConstraint(1, headingFloat: headingFloat, constraint: NELeadingConstraint)
        setConstraint(2, headingFloat: headingFloat, constraint: ELeadingConstraint)
        setConstraint(3, headingFloat: headingFloat, constraint: SELeadingConstraint)
        setConstraint(4, headingFloat: headingFloat, constraint: SLeadingConstraint)
        setConstraint(5, headingFloat: headingFloat, constraint: SWLeadingConstraint)
        setConstraint(6, headingFloat: headingFloat, constraint: WLeadingConstraint)
        setConstraint(7, headingFloat: headingFloat, constraint: NWLeadingConstraint)
    }
   
    

    
    //MARK: - Compass Methods
    
    @IBOutlet weak var worldView: UIView!
    var locationManager = CLLocationManager()
    @IBOutlet var headingLabel : UILabel!
    
    func startGettingHeading() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    var headingString = ""
   
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        switch newHeading.magneticHeading {
        case 0...22.5:
            headingString = "N"
        case 22.5...67.5:
            headingString = "NE"
        case 67.5...112.5:
            headingString = "E"
        case 112.5...157.5:
            headingString = "SE"
        case 157.5...202.5:
            headingString = "S"
        case 202.5...247.5:
            headingString = "SW"
        case 247.5...292.5:
            headingString = "W"
        case 292.5...337.5:
            headingString = "NW"
        case 337.5...360.0:
            headingString = "N"
        default:
            headingString = "?"
        }
        moveLabel(newHeading.magneticHeading)
        
        
        let wholeDegrees = String(format: "%.0f", newHeading.magneticHeading)
        headingLabel.text = "\(headingString) \(wholeDegrees)º"
    }
    
    
    
    
    //MARK: - Camera Method + Vars
    var captureSession: AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    func startCaptureSession () {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input : AVCaptureDeviceInput!
        do{
            input = try AVCaptureDeviceInput(device: backCamera)
        }catch let error1 as NSError {
            error = error1
            input = nil
            print("Error \(error)")
        }
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer!.connection?.videoOrientation = .Portrait
            worldView.layer.addSublayer(previewLayer!)
            captureSession!.startRunning()
    
    }
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        startCaptureSession()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        previewLayer!.frame = worldView.bounds
        startGettingHeading()
        moveLabel(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

