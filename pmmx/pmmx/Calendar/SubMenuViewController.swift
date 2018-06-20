//
//  SubMenuViewController.swift
//  pmmx
//
//  Created by ISPMMX on 1/11/18.
//  Copyright © 2018 com.pmi. All rights reserved.
//

import UIKit
import Alamofire
import CircleMenu

class SubMenuViewController: UIViewController,CircleMenuDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var items: [(icon: String, color: UIColor)] = [ ]
   
    let api = DBConections()
    let helper = Helpers()
    var subCategoriasArray = [SubCategoria]()
    var IdCategoria : Int = 0;
    var IdEvento: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.downloadData()
        
        self.titleLabel.text = "GembaWalks"
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.frame = CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func downloadData()
    {
        api.getSubCategoria(IdCategoria: IdCategoria){(res) in
            self.subCategoriasArray = res
            self.addButtons()
        }
    }
    
    func addItems()
    {
        for i in 0 ..< self.subCategoriasArray.count
        {
            self.items.append((icon: "nearby-btn", color: helper.randomColor(seed: self.subCategoriasArray[i].Nombre) ))
        }
    }
    
    func addButtons()
    {
        self.addItems()
        
        let button = CircleMenu(
            frame: CGRect(x: UIScreen.main.bounds.size.width*0.4, y: UIScreen.main.bounds.size.height*0.2, width: 80, height: 80),
            normalIcon:"quality",
            selectedIcon:"icon_close",
            buttonsCount: self.subCategoriasArray.count,
            duration: 0.5,
            distance: 150)
        
        button.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        button.setTitle(".", for: .normal)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        
        self.scrollView.addSubview(button)
        button.sendActions(for: .touchUpInside)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int)
    {
        let hc = subCategoriasArray[atIndex]
        button.backgroundColor = items[atIndex].color
        button.setTitle(hc.NombreCorto, for: .normal)
        
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
        let index = subCategoriasArray.index(where: {$0.Id == btnsendtag.tag})
        let hc = subCategoriasArray[index!]
        self.nextController(IdSubCategoria: hc.Id, Nombre: hc.Nombre, IdGrupo : hc.IdGrupo)
    }
    
    func nextController(IdSubCategoria: Int, Nombre: String, IdGrupo: Int)
    {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "NTRMVC") as! NTRMVC
        desController.IdCategoria = self.IdCategoria
        desController.IdEvento = self.IdEvento
        desController.Title = Nombre
        desController.idGrupo = IdGrupo
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
