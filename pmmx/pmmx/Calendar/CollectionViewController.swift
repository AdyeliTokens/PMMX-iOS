//
//  QualityTests.swift
//  pmmx
//
//  Created by ISPMMX on 12/18/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "customCell"

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate, CustomCellDelegate {

    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var JustDoIt: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    
    let api = DBConections();
    
    var IdCategoria : Int = 0;
    var IdSubCategoria : Int = 0;
    var IdEvento: Int = 0;
    var Title : String = "";
    var idGrupo : Int = 0;
    var Direccion: CGFloat = 0;
    var array: [Pregunta] = [];
    
    var saveRespuestas = [AnyObject]();
    var index: Int = 0;
    var tipo: Int = 0;
    var parameters: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        viewButtons.isHidden = true
        
        if(IdCategoria == 7)
        {
            JustDoIt.titleEdgeInsets = UIEdgeInsets(top: 100,left: 0,bottom: 0,right: 0)
            viewButtons.isHidden = false
        }
        else
        {
            self.Title = (parameters[3] as! String) + " " + (parameters[1] as! String);
            self.idGrupo = (parameters[2] as! Int)
        }
        
        titleLabel.text = Title
        
        self.downloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.bounds.width, height: 50)
        return itemSize
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return array.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        
        cell.cellLabel.text = array[indexPath.row].Interrogante
        
        if(IdCategoria == 7)
        {
            cell.imgView.image = UIImage(named: "quality")!
        }
        else
        {
            cell.imgView.image = UIImage(named: "circle")!
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        self.index = array[indexPath.row].Id
        self.tipo = array[indexPath.row].Tipo
        array.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
        if(array.count == 0)
        {
            if(IdCategoria == 7)
            {
                self.justDoIt()
            }
            else
            {
                print("finish")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "customHeader", for: indexPath) as! CustomHeaderView
            headerView.headerLabel.text = "Titulo"
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func downloadData()
    {
        api.getPreguntas(idGrupo: idGrupo )
        {(res)  in
            self.array = res
            self.collectionView!.reloadData()
        }
    }
    
    func directionPan(direccion: CGFloat)
    {
        self.Direccion = direccion
        if(direccion < 0)
        {
            self.addAnswer(respuesta: 0, comentario: "") // NO
            
            switch(IdCategoria)
            {
                case 7:
                   if(idGrupo != 25)
                    {
                        justDoIt();
                    }
                default:
                    print(IdCategoria)
            }
        }
        else
        {
          self.ntrmController()
          self.addAnswer(respuesta: 1, comentario: "") // SI
        }
    }
    
    func ntrmController()
    {
        if(idGrupo == 25)
        {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "NTRMVC") as! NTRMVC
            desController.IdCategoria = self.IdCategoria
            desController.IdEvento = self.IdEvento
            desController.Title = self.Title
            desController.idGrupo = idGrupo
            desController.IdSubCategoria = IdSubCategoria
            
            let frontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController().pushFrontViewController(frontViewController, animated: true)
        }
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
            desController.Tipo = self.tipo
        
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
    func addAnswer(respuesta: Int, comentario: String)
    {
        let res : [String: AnyObject] =  ["IdPregunta":   self.index as AnyObject,
                                          "IdOrigenRespuesta": self.IdEvento as AnyObject,
                                          "Solucion":  respuesta as AnyObject,
                                          "Comentario":  comentario as AnyObject]
        
        self.saveRespuestas.append(res as AnyObject)
    }
    
    @IBAction func finishButton(_ sender: UIButton) {
        self.tipo = 1
        self.justDoIt()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let revealViewController : SWRevealViewController = self.revealViewController()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "SubMenuVC") as! SubMenuViewController
        desController.IdEvento = self.IdEvento
        desController.IdCategoria = self.IdCategoria
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController.pushFrontViewController(frontViewController, animated: true)
    }
    
    func showData()
    {
        if(self.array.count > 0)
        {
           /* self.arrayData.removeAll()
            
            api.getOrigen(IdWorkCenter: parameters[0] as! Int)
            {(res) in
                self.origenArray = (res as NSArray).mutableCopy() as! NSMutableArray
                let respuestas:NSDictionary = self.origenArray[0] as! NSDictionary
                self.arrayData.append(respuestas["Id"] as AnyObject);
                self.saveMWCR(IdOrigen: respuestas["Id"] as! Int);
            }*/
        }
        else
        {
            let messageButton: UIButton = UIButton(frame: CGRect(x: self.view.bounds.size.width/3, y: self.view.bounds.size.height/2, width: 200, height: 100))
            messageButton.backgroundColor = UIColor(red: 48/255.0, green: 145/255.0, blue: 240/255.0, alpha: 1.0)
            messageButton.setTitle("Please try again.", for: .normal)
            messageButton.sizeToFit()
            messageButton.addTarget(self, action: #selector(self.reloadView), for: .touchUpInside)
            
            self.view.addSubview(messageButton)
        }
    }
    
    @objc func reloadView()
    {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "LineLeadVC") as! LineLeadViewController
        navigationController?.pushViewController(myVC, animated: true)
    }
    
}
