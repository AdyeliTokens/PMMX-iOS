//
//  ViewMenuVC.swift
//  pmmx
//
//  Created by ISPMMX on 11/10/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

class ViewMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var imgProfile: UIImageView!
    var menuNameArray: Array = [String]()
    var iconeImage: Array = [UIImage]()
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArray = ["Home", "Calendar",  "Logout" ]
        iconeImage = [UIImage(named: "monitor")!,UIImage(named: "calendar")!,UIImage(named: "logout")!]
        
        self.getProfile()
    }
    
    func getProfile()
    {
        let defaultValues = UserDefaults.standard
        if let name = defaultValues.string(forKey: "UserName"){
            userLabel.text = name
        }
        
        if let IdPersona = defaultValues.string(forKey: "IdPersona"){
            let stringURL = "http://serverpmi.tr3sco.net/Fotos/Personas/"+String(describing: IdPersona)
            
           let image = UIImage(data: NSData(contentsOf: URL(string: stringURL)!)! as Data)
            imgProfile.image = image
            imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
            imgProfile.clipsToBounds = true
            imgProfile.contentMode = UIViewContentMode.scaleAspectFit
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.imgIcon.image = iconeImage[indexPath.row]
        cell.lblMenuName.text! = menuNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealViewController : SWRevealViewController = self.revealViewController()
        let cell: MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if(cell.lblMenuName.text! == "Home")
        {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            let frontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(frontViewController, animated: true)
        }
        
        if(cell.lblMenuName.text! == "Calendar")
        {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            let frontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(frontViewController, animated: true)
        }
        
        if(cell.lblMenuName.text! == "Logout")
        {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! Login
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = next
        }
        
    }
    

}
