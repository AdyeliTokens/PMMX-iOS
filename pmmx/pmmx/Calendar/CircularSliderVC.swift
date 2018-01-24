//
//  CircularSliderVC.swift
//  pmmx
//
//  Created by ISPMMX on 11/21/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import KDCircularProgress
import UIKit

class CircularSliderVC: UIViewController
{
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var jDIButton: UIButton!
    
    var newPercent: Int = 0
    var IdEvento: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        jDIButton.layer.cornerRadius = 10
        jDIButton.clipsToBounds = true
        
        self.result()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func result()
    {
        textLabel.text = "\(newPercent) %"
        circularProgressView.animate(toAngle: Double((newPercent * 360)/100), duration: 0.5, completion: nil)
        
        if(newPercent >= 70)
        {
            let alert = UIAlertController(title: "Just Do It", message: "Do you want to add a Just Do It?.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.justDoIt()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
           present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Excelent", message: "Your grade is awsome. Please click to continue", preferredStyle: UIAlertControllerStyle.alert)
             alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Continue")
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
   @objc func justDoIt(){
        let revealViewController : SWRevealViewController = self.revealViewController()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
        desController.IdEvento = self.IdEvento
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func jDIAction(_ sender: UIButton) {
        self.justDoIt()
    }
    
}
