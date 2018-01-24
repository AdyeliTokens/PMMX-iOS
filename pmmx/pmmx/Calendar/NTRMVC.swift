//
//  NTRMVC.swift
//  pmmx
//
//  Created by ISPMMX on 1/24/18.
//  Copyright © 2018 com.pmi. All rights reserved.
//

import UIKit

class NTRMVC: UIViewController {
    
    var IdCategoria : Int = 0
    var IdEvento : Int = 0
    var Title : String = ""
    var idGrupo : Int = 0
    var IdSubCategoria : Int = 0

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextController()  {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "HallazgoVC") as! HallazgoViewController
        desController.IdCategoria = self.IdCategoria
        desController.IdEvento = self.IdEvento
        desController.Title = self.Title
        desController.idGrupo = self.idGrupo
        desController.IdSubCategoria = self.IdSubCategoria
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func metalButton(_ sender: UIButton) {
        self.Title = "Metal"
        self.nextController()
    }
    
    @IBAction func cartonButton(_ sender: UIButton) {
        self.Title = "Carton"
        self.nextController()
    }
    
    @IBAction func organicoButton(_ sender: UIButton) {
        self.Title = "Organico"
        self.nextController()
    }
    
    @IBAction func plasticoButton(_ sender: UIButton) {
        self.Title = "Plástico"
        self.nextController()
    }
    
    

}
