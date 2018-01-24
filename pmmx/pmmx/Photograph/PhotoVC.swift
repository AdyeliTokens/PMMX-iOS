//
//  PhotoVC.swift
//  pmmx
//
//  Created by ISPMMX on 11/22/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit
import Alamofire

class PhotoVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    SearchViewControllerDelegate, QRViewControllerDelegate ,UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    var text : String = ""
    var IdOrigen : Int = 0
    var IdPersona : Int = 0
    
    var IdEvento: Int = 0
    var IdCategoria: Int = 0
    var IdSubCategoria: Int = 0
    var IdGrupo: Int = 0
    var Tipo: Int = 0
    var Titulo: String? = ""
    
    var imagePicker = UIImagePickerController()
    private var lastPoint = CGPoint.zero
    private var red: CGFloat = 1.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    let api = DBConections()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if(Tipo == 1)
        {
            titleLabel.text = "Just Do It"
        }
        else
        {
            titleLabel.text = "CAPAIA"
        }
        
        
        sliderOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getPrioridad(_ sender: UISlider) {
        let prioridad = Int(sliderOutlet.value);
        
        if prioridad == 1 {
            sliderOutlet.minimumTrackTintColor = UIColor.cyan
            titleLabel.backgroundColor = UIColor.cyan
        } else if prioridad == 2 {
            sliderOutlet.minimumTrackTintColor = UIColor.yellow
            titleLabel.backgroundColor = UIColor.yellow
        } else {
            sliderOutlet.minimumTrackTintColor = UIColor.red
            titleLabel.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let alert = UIAlertController(title: "Do yo want", message: "to take a Photo or open Library?", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "Take Photo", style: .default) { (action:UIAlertAction!) in
                self.openCamera()
            }
            alert.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "Open Library", style: .cancel) { (action:UIAlertAction!) in
                self.openLibrary()
            }
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        else
        {
            noCamera()
        }
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.returnValue()
    }
    
    func openCamera()
    {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(self.imagePicker,animated: true,completion: nil)
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(
            title: "Sorry, this device has no camera",
            message: "Do you want to open a Library?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "NO",
            style:.cancel,
            handler: nil)
        alertVC.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Open Library", style: .default) { (action:UIAlertAction!) in
            self.openLibrary()
        }
        alertVC.addAction(okAction)
        
        present(alertVC,animated: true,completion: nil)
    }
    
    func openLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary;
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = pickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.imageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        /*
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height), blendMode: .normal, alpha: 1.0)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height), blendMode: .normal, alpha: opacity)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = nil*/
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint)
    {
        UIGraphicsBeginImageContext(imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context!.setLineCap(.round)
        context!.setLineWidth(5)
        context!.setStrokeColor(red: red,
                                green: green,
                                blue: blue,
                                alpha: 1.0)
        context!.setBlendMode(.normal)
        
        // 4
        context!.strokePath()
        
        // 5
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func comments(_ sender: UIButton) {
        alertView()
    }
    
    
    @IBAction func qrLector(_ sender: UIButton) {
        let savingsInformationViewController = storyboard?.instantiateViewController(withIdentifier: "qrVC") as! QRViewController
        
        savingsInformationViewController.delegate = self
        
        savingsInformationViewController.modalPresentationStyle = .popover
        if let popoverController = savingsInformationViewController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(savingsInformationViewController, animated: true, completion: nil)
    }
    
    func alertView()
    {
        let alert = UIAlertController(title: "Comments", message: "Please add your comments", preferredStyle: .alert)
        alert.addTextField { (txtComment) in
            txtComment.text = ""
        }
        
        let saveAction = UIAlertAction(title: "Save",style: .default)
        { (action: UIAlertAction!) -> Void in
            let comentario = String(describing: alert.textFields![0].text ?? "")
            
            self.api.saveJustDoIt(IdEvento: self.IdEvento,IdOrigen: self.IdOrigen, Descripcion: comentario, IdPersona: self.IdPersona, IdSubCategoria: self.IdSubCategoria, IdTipo: self.Tipo){(res) in
                    self.saveImage(IdJustDoIt: res){(res) in
                       print("Ok")
                    }
                    self.returnValue()
                }
        }
        saveAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object:alert.textFields?[0],queue: OperationQueue.main)
        { (notification) -> Void in
            let textFieldName = alert.textFields?[0]
            saveAction.isEnabled = self.isValid(testStr: (textFieldName?.text!)!) &&  !(textFieldName?.text?.isEmpty)! //&& (self.IdOrigen != 0) && (self.IdPersona != 0)
        }
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValid(testStr:String) -> Bool
    {
        if(testStr != "")
        {
            return true
        }
        return false
    }
    
    func saveImage(IdJustDoIt: Int,callback:@escaping (Bool) -> Void)
    {
        let URL_CONNECT = "https://serverpmi.tr3sco.net/api/Fotos?IdGembaWalk="+String(describing: IdJustDoIt) as String
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        },
            to: URL_CONNECT,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        print(progress.fractionCompleted)
                    }
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    func returnValue()
    {
        let revealViewController : SWRevealViewController = self.revealViewController()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = mainStoryBoard.instantiateViewController(withIdentifier: "CollectionVC") as! CollectionViewController
            myVC.IdCategoria = self.IdCategoria
            myVC.IdEvento = self.IdEvento
            myVC.Title = Titulo!
            myVC.idGrupo = IdGrupo
        let frontViewController = UINavigationController.init(rootViewController: myVC)
        revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func listUsers(_ sender: UIButton)
    {
        let savingsInformationViewController = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        
        savingsInformationViewController.delegate = self
        savingsInformationViewController.Id = IdPersona
        savingsInformationViewController.IdEntorno = 7
        
        savingsInformationViewController.modalPresentationStyle = .popover
        if let popoverController = savingsInformationViewController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(savingsInformationViewController, animated: true, completion: nil)
    }
    
    func savePersona(Id: Int)
    {
        self.IdPersona = Id
    }
    
    func saveLocation(Id : Int, Text: String)
    {
        self.IdOrigen = Id
        self.text = Text
        self.location.text = self.text
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}
