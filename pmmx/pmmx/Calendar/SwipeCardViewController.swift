//
//  SwipeCardViewController.swift
//  pmmx
//
//  Created by ISPMMX on 12/13/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

class SwipeCardViewController: UIViewController {
    var cardView:UIView!
    var label : UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var panGestureRecognizer:UIPanGestureRecognizer!
    var originalPoint: CGPoint!
    var index : Int = 0
    var array: [Pregunta] = []
    let api = DBConections();
    
        override func viewDidLoad() {
            super.viewDidLoad()
            menuButton.target = revealViewController();
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.downloadData()
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(gestureRecognizer:)))
            self.view.addGestureRecognizer(panGestureRecognizer)
            
            self.cardView = createCardView()
            self.label = createLabel()
            cardView.addSubview(label)
            
            self.view.addSubview(cardView)
        }
        
        
        override func viewWillLayoutSubviews() {
            cardView.center = self.view.center
        }
    
        func createCardView() -> UIView {
            let width = self.view.frame.width * 0.5
            let height = self.view.frame.height * 0.5
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            
            let tempCardView = UIView(frame: rect)
            tempCardView.backgroundColor = UIColor.white
            tempCardView.layer.cornerRadius = 8;
            tempCardView.layer.shadowOffset = CGSize(width:7, height:7);
            tempCardView.layer.shadowRadius = 5;
            tempCardView.layer.shadowOpacity = 0.5;
            
            return tempCardView
        }
    
        func createLabel() -> UILabel
        {
            let width = self.view.frame.width * 0.5
            let height = self.view.frame.height * 0.5
            let label = UILabel(frame: CGRect(x: 100, y: 0, width: width, height: height))
            label.center = CGPoint(x: self.cardView.frame.width * 0.5, y: self.cardView.frame.height * 0.5)
            label.textAlignment = .center
            label.numberOfLines = 5
            label.text = "Start"
            return label
        }
    
        @objc func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
            let xDistance = gestureRecognizer.translation(in: self.view).x
            let yDistance = gestureRecognizer.translation(in: self.view).y
            
            switch gestureRecognizer.state {
            case .began:
                self.originalPoint = self.view.center
                break
                
            case .changed:
                updateCardViewWithDistances(xDistance: xDistance, yDistance: yDistance)
                break
                
            case .ended:
                resetViewPositionAndTransformations()
                break
                
            default:
                break
            }
        }
    
        func updateCardViewWithDistances(xDistance: CGFloat, yDistance: CGFloat) {
            let rotationStrength = min(xDistance / 320, 1)
            let fullCircle = (CGFloat)(2*Double.pi)
            
            let rotationAngle:CGFloat = fullCircle * rotationStrength / 16
            let scaleStrength:CGFloat = (CGFloat) (1 - fabsf(Float(rotationStrength)) / 2)
            let scale = max(scaleStrength, 0.93)
            
            let newX = self.originalPoint.x + xDistance
            let newY = self.originalPoint.y + yDistance
            
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            
            if(newX < self.originalPoint.x)
            {
                self.label.text = "No"
                self.cardView.backgroundColor = UIColor.green
            }
            
            if(newX > self.originalPoint.x)
            {
                self.label.text = "Yes"
                self.cardView.backgroundColor = UIColor.red
                self.alertView()
            }
            
            self.cardView.center = CGPoint(x: newX, y: newY)
            self.cardView.transform = scaleTransform
        }
    
        func resetViewPositionAndTransformations() {
            UIView.animate(withDuration: 0.2, animations: {
                self.cardView.center = self.originalPoint;
                self.cardView.transform = CGAffineTransform(rotationAngle: 0);
                self.cardView.backgroundColor = UIColor.white
                self.addValueToCard()
            })
        }
    
    func addValueToCard()
    {
        if(self.array.count > self.index)
        {
            self.label.text = array[index].Interrogante
            self.index = self.index + 1
            self.cardView.backgroundColor = UIColor.white
        }
        else
        {
            self.label.text = "Finish"
            self.cardView.backgroundColor = UIColor.white
            let alert = UIAlertController(title: "Just Do It", message: "Do you want to add a Just Do It?.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.justDoIt()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func alertView()
    {
        let alert = UIAlertController(title: "YES", message: "Please add your comments", preferredStyle: .alert)
        alert.addTextField { (txtComment) in
            txtComment.placeholder = "Comments"
            txtComment.frame.size.height = 100
            txtComment.text = ""
        }
        
        let saveAction = UIAlertAction(title: "Save",style: .default)
        { (action: UIAlertAction!) -> Void in
            //let textField = alert.textFields![0]
            //self.addAnswer(respuesta: 0, comentario: (textField.text!))
            self.resetViewPositionAndTransformations()
        }
        saveAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object:alert.textFields?[0],queue: OperationQueue.main)
        { (notification) -> Void in
            let textFieldName = alert.textFields?[0]
            saveAction.isEnabled = self.isValid(testStr: (textFieldName?.text!)!) &&  !(textFieldName?.text?.isEmpty)!
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
    
    func justDoIt()
    {
         let revealViewController : SWRevealViewController = self.revealViewController()
         let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CircularSliderVC") as! CircularSliderVC
        desController.newPercent = 80
         let frontViewController = UINavigationController.init(rootViewController: desController)
         revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
    func downloadData()
    {
        api.getPreguntas(idGrupo: 21 )
        {(res)  in
            self.array = res
        }
    }
    
}
