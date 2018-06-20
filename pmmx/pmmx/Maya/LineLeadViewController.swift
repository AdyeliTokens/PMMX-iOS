//
//  LineLeadViewController.swift
//  PMMX
//
//  Created by ISPMMX on 9/26/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import UIKit
import Alamofire
import Speech
import CircleMenu

enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat(Float(1.0) / Float(255.0) * Float(red)),
            green: CGFloat(Float(1.0) / Float(255.0) * Float(green)),
            blue: CGFloat(Float(1.0) / Float(255.0) * Float(blue)),
            alpha: CGFloat(alpha))
    }
}

extension LineLeadViewController {
    func setUI(status: SpeechStatus) {
        switch status {
        case .ready:
            print("Ready")
        case .recognizing:
            print("Recognizing")
        case .unavailable:
            print("Unavailable")
        }
    }
}

class LineLeadViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, CircleMenuDelegate, UITabBarDelegate, SearchViewControllerDelegate
{
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBOutlet weak var txtWorkCenter: UITextField!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var txtWelcome: UILabel!
    
    let api = DBConections()
    let helper = Helpers()
    var arrayData: [AnyObject] = []
    var healthChecks = [GrupoPreguntas]()
    var workCentersArray = [WorkCenter]()
    
    var pickerWC = UIPickerView()
    
    var status = SpeechStatus.ready {
        didSet {
            self.setUI(status: status)
        }
    }
    
    var IdPersona : Int = 0
    var items: [(icon: String, color: UIColor)] = [ ]
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pickerWC.dataSource = self
        pickerWC.delegate = self
        self.arrayData.removeAll()
        
        menuItem.target = revealViewController();
        menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
        }
        
        let defaultValues = UserDefaults.standard
        if let name = defaultValues.string(forKey: "UserName"){
            txtWelcome.text = "Welcome "+name
        }
        
        self.downloadData()
        txtWorkCenter.inputView = pickerWC
        
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    open func viewWillAppear()
    {
        super.viewWillAppear(true)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.tabBarController?.reloadInputViews()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 28/255, green: 87/255, blue: 145/255, alpha: 1)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }
    
    func downloadData()
    {
        api.getGrupoPreguntas(IdCategoria: 13){(res) in
            self.healthChecks = res
            self.addHCButton()
        }
        
        api.getWorkCenters(){(res) in
            self.workCentersArray = res
            self.pickerWC.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workCentersArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtWorkCenter.text = workCentersArray[row].NombreCorto
        self.arrayData.removeAll()
        self.arrayData.append(self.workCentersArray[row].Id as AnyObject)
        self.arrayData.append((self.workCentersArray[row].NombreCorto as AnyObject))
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workCentersArray[row].NombreCorto
    }
    
    func addItems()
    {
        for i in 0 ..< self.healthChecks.count
        {
            self.items.append((icon: "nearby-btn", color: helper.randomColor(seed: self.healthChecks[i].Nombre) ))
        }
    }
    
    func addHCButton()
    {
        self.addItems()
        
        let button = CircleMenu(
            frame: CGRect(x: UIScreen.main.bounds.size.width*0.4, y: UIScreen.main.bounds.size.height*0.2, width: 70, height: 70),
            normalIcon:"play",
            selectedIcon:"icon_close",
            buttonsCount: self.healthChecks.count,
            duration: 0.5,
            distance: 140)
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        self.scrollView.addSubview(button)
        button.sendActions(for: .touchUpInside)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int)
    {
        let hc = healthChecks[atIndex]
        button.backgroundColor = items[atIndex].color
        button.setTitle(hc.Nombre, for: .normal)
        
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0/255.0, green:
            0/255.0, blue: 0/255.0, alpha: 0.3)
        button.tag = hc.Id
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        let btnsendtag: UIButton = sender
        let index = healthChecks.index(where: {$0.Id == btnsendtag.tag})!
        let hc = healthChecks[index]
        arrayData.append(hc.Id as AnyObject)
        arrayData.append(hc.Nombre as AnyObject)
        self.showAlertDD(sender)
    }
    
    @objc func nextViewControler()
    {
        if(txtWorkCenter.text != "")
        {
            txtWorkCenter.text = ""
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SurveyVC") as! SurveyVC
            self.arrayData.append(IdPersona as AnyObject)
            myVC.parameters = arrayData
            navigationController?.pushViewController(myVC, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "Please select Work Center and HealthCheck.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertDD(_ sender: UIButton)
    {
        let savingsInformationViewController = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        
        savingsInformationViewController.delegate = self
        savingsInformationViewController.Id = IdPersona
        savingsInformationViewController.IdEntorno = 1
        
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
        self.nextViewControler()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}

