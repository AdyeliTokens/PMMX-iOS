//
//  MenuVC.swift
//  pmmx
//
//  Created by ISPMMX on 11/10/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import UIKit

class MenuVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var txtBussinesUnit: UITextField!
    var pickerBU = UIPickerView()
    var bussinesUnitArray = [BussinesUnit]()
    let api = DBConections()
    
    @IBOutlet weak var indicadoresButton: UIButton!
    //@IBOutlet weak var fallasButton: UIButton!
    @IBOutlet weak var gembaButton: UIButton!
    @IBOutlet weak var metrologiaButton: UIButton!
    //@IBOutlet weak var defectosButton: UIButton!
    @IBOutlet weak var dmsButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        pickerBU.dataSource = self
        pickerBU.delegate = self
        
        indicadoresButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        //fallasButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        gembaButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        metrologiaButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        //defectosButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        dmsButton.titleEdgeInsets = UIEdgeInsets(top: 120,left: 0,bottom: 0,right: 0)
        
        
        txtBussinesUnit.inputView = pickerBU
        api.getBussinesUnit(){(res) in
            self.bussinesUnitArray = res
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bussinesUnitArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtBussinesUnit.text = bussinesUnitArray[row].NombreCorto
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bussinesUnitArray[row].NombreCorto
    }
    
    @IBAction func dmsButton(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func gembaButton(_ sender: UIButton) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        desController.IdCategoria = 7
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func metrologiaButton(_ sender: UIButton) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        desController.IdCategoria = 10
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
}
