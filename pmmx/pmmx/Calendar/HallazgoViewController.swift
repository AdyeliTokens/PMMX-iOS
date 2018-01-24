//
//  HallazgoViewController.swift
//  pmmx
//
//  Created by ISPMMX on 1/24/18.
//  Copyright © 2018 com.pmi. All rights reserved.
//

import UIKit

class HallazgoViewController: UIViewController {
    var IdCategoria : Int = 0
    var IdEvento : Int = 0
    var Title : String = ""
    var idGrupo : Int = 0
    var IdSubCategoria : Int = 0
    var Tipo : Int = 0
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Title
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acondicionadoButtton(_ sender: UIButton) {
        self.Tipo = 1
        self.justDoIt()
    }
    
    @IBAction func picadoButton(_ sender: UIButton) {
        self.Tipo = 2
        self.justDoIt()
    }
    
    
    @IBAction func productoFinal(_ sender: UIButton) {
        self.Tipo = 1
        self.justDoIt()
    }
    
    func justDoIt()
    {
        let revealViewController : SWRevealViewController = self.revealViewController()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
        desController.IdEvento = self.IdEvento
        desController.IdCategoria = self.IdCategoria
        desController.Titulo = self.Title
        desController.IdGrupo = self.idGrupo
        desController.Tipo = self.Tipo
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
}