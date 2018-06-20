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
    
    var array: [Pregunta] = [];
    let api = DBConections()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.Button1.isHidden = true
        self.Button2.isHidden = true
        self.Button3.isHidden = true
        self.Button4.isHidden = true
        self.Button5.isHidden = true
        
        self.downloadData()
    }

    func downloadData()
    {
        api.getPreguntas(idGrupo: idGrupo )
        {(res)  in
            self.array = res
            
            if self.array.contains(where: { $0.Anexo1 != "" })
            {
                var subarray : [String] = []
                
                for item in self.array
                {
                    subarray.append(item.Anexo1)
                }
                subarray = Set(subarray).sorted()
                
                self.Button1.isHidden = false
                self.Button2.isHidden = false
                self.Button3.isHidden = false
                self.Button4.isHidden = false
                self.Button5.isHidden = false
                
                self.Button1.setTitle(subarray[0], for: .normal)
                self.Button2.setTitle(subarray[1], for: .normal)
                self.Button3.setTitle(subarray[2], for: .normal)
                self.Button4.setTitle(subarray[3], for: .normal)
            }
            else
            {
                self.preguntasController(filteredArray: self.array)
            }
        }
    }
    
    func preguntasController(filteredArray: [Pregunta])
    {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CollectionVC") as! CollectionViewController
        desController.IdCategoria = self.IdCategoria
        desController.IdEvento = self.IdEvento
        desController.Title = self.Title
        desController.idGrupo = idGrupo
        desController.array = filteredArray
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func nextController()  {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "HallazgoVC") as! HallazgoViewController
        desController.IdCategoria = self.IdCategoria
        desController.IdEvento = self.IdEvento
        desController.Title = self.Title
        desController.idGrupo = self.idGrupo
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func pushButton1(_ sender: UIButton) {
        self.pushButton(Titulo: (Button1.titleLabel?.text)!)
    }
    
    @IBAction func pushButton2(_ sender: UIButton) {
        self.pushButton(Titulo: (Button2.titleLabel?.text)!)
    }
    
    @IBAction func pushButton3(_ sender: UIButton) {
        self.pushButton(Titulo: (Button3.titleLabel?.text)!)
    }
    
    @IBAction func pushButton4(_ sender: UIButton) {
        self.pushButton(Titulo: (Button4.titleLabel?.text)!)
    }
    
    @IBAction func otrosButton(_ sender: UIButton) {
        self.Title = "Otros"
        self.nextController()
    }
    
    func pushButton(Titulo: String)
    {
        self.Title = Titulo
        let filteredArray = array.filter() { $0.Anexo1 == Titulo }
        
        self.preguntasController(filteredArray: filteredArray)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "SubMenuVC") as! SubMenuViewController
        desController.IdCategoria = self.IdCategoria
        desController.IdEvento = self.IdEvento
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }

}
