//
//  QRViewController.swift
//  pmmx
//
//  Created by ISPMMX on 11/23/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import UIKit
import AVFoundation

protocol QRViewControllerDelegate
{
    func saveLocation(Id : Int, Text: String)
}

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var delegate : QRViewControllerDelegate?
    var origenArray: NSMutableArray = []
    let api = DBConections();
    
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            
            view.bringSubview(toFront: messageLabel)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
    }

   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                self.returnValue(location: metadataObj.stringValue!)
            }
        }
    }
    
    func returnValue(location: String)
    {
        if (self.delegate) != nil
        {
            //var token = messageLabel.text!.components(separatedBy: "_")
            api.getOrigenbyName(name: self.messageLabel.text!)
            {(res) in
                self.origenArray = (res as NSArray).mutableCopy() as! NSMutableArray
                let respuestas:NSDictionary = self.origenArray[0] as! NSDictionary
                
                self.delegate?.saveLocation(Id: respuestas["Id"] as! Int, Text:
                    location.uppercased())
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
