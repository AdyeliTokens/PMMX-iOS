//
//  EventDescriptionViewController.swift
//  pmmx
//
//  Created by ISPMMX on 3/5/18.
//  Copyright © 2018 com.pmi. All rights reserved.
//

import UIKit

class EventDescriptionViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var IdEvento: Int = 0;
    var IdCategoria: Int = 0;
    var Descripcion: String = "";
    let api = DBConections()
    let helper = Helpers()
    var eventoArray = [Eventos]()
    var gembaWalksArray = [GembaWalk]()
    var atributes = [String]()
    var ventanaArray: NSMutableArray = []
    var okButton = UIButton()
    var rejectButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.header()
        self.createFloatingButton()
        self.loadEvento()
    }
    
    func header()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        header.backgroundColor = helper.randomColor(seed: Descripcion)
        
        let label: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        label.textColor = .white
        label.text = Descripcion
        label.textAlignment = .center
        header.addSubview(label)
        
        let backButton: UIButton = UIButton.init(frame: CGRect(x: 5, y: 0, width: 100, height: 100))
        backButton.addTarget(self, action: #selector(backButton(_:)), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = UIColor.white
        header.addSubview(backButton)
        
        tableView.tableHeaderView = header
        tableView.estimatedSectionHeaderHeight = 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.atributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CellID")
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 3
        
        if((indexPath.row % 2) == 0 )
        {
          cell.textLabel?.textColor = .white
          cell.backgroundColor = UIColor(red: 0.4, green: 0.5, blue: 0.6, alpha: 0.5)
        }
        
        cell.textLabel?.text = self.atributes[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.bounds = view.frame.insetBy(dx: 10.0, dy: 05.0)
        v.backgroundColor = .white
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.insertSegment(withTitle: "Info", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Ventana", at: 1, animated: false)
        
        if(IdCategoria == 7)
        {
            segmentedControl.insertSegment(withTitle: "GembaWalk", at: 2, animated: false)
        }
        segmentedControl.tintColor = helper.randomColor(seed: Descripcion)
        
        v.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(self.changeControl(sender:)), for:.valueChanged)
        return v
    }
    
    @objc func changeControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.loadEvento()
        case 1:
            self.loadVentana()
        case 2:
            self.loadGembaWalks()
        default:
            self.view.backgroundColor = UIColor.purple
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadEvento()
    {
        api.getEventobyId(Id: IdEvento){(res) in
            self.eventoArray = res
            self.atributes.removeAll()
            
            self.atributes.append("Descripcion: ")
            self.atributes.append(self.eventoArray[0].Descripcion)
            self.atributes.append("FechaInicio: ")
            self.atributes.append(""+self.eventoArray[0].FechaInicio)
            self.atributes.append("FechaFin: ")
            self.atributes.append(""+self.eventoArray[0].FechaFin)
            
            self.tableView.reloadData()
        }
    }
    
    func loadVentana()
    {
        self.atributes.removeAll()
        
        api.getVentanabyIdEvento(Id: IdEvento){(res) in
                self.atributes.removeAll()
                self.ventanaArray = (res as NSArray).mutableCopy() as! NSMutableArray
                let respuestas:NSDictionary = self.ventanaArray[0] as! NSDictionary
            
                self.atributes.append("PO: ")
                self.atributes.append(""+String(describing: respuestas["PO"] as! String)+" "+String(describing: respuestas["SubCategoriaNombre"] as! String))
                self.atributes.append("Ubicacion: ")
                self.atributes.append(""+String(describing: respuestas["ProcedenciaNombre"] as! String)+" a "+String(describing: respuestas["DestinoNombre"] as! String))
                self.atributes.append("Material: ")
                self.atributes.append(""+String(describing: respuestas["Recurso"] as! String)+" "+String(describing: respuestas["Cantidad"] as! Double)+" pallets")
                self.atributes.append("Linea transportista: ")
                self.atributes.append(""+String(describing: respuestas["NombreCarrier"] as! String)+"\n"+String(describing: respuestas["CarrierNombre"] as! String))
                self.atributes.append("Tipo Unidad: ")
                self.atributes.append(""+String(describing: respuestas["NumeroEconomico"] as! String)+" "+String(describing: respuestas["NumeroPlaca"] as! String))
                self.atributes.append("Modelo contenedor: ")
                self.atributes.append(""+String(describing: respuestas["Dimension"] as! String)+" "+String(describing: respuestas["Temperatura"] as! String))
                
                self.tableView.reloadData()
        }
        
        if(self.atributes.count == 0)
        {
            self.atributes.append("Ventana sin informacion")
            self.tableView.reloadData()
        }
    }
    
    func loadGembaWalks()
    {
        api.getGembaWalksbyIdEvento(Id: IdEvento){(res) in
            self.gembaWalksArray = res
            self.atributes.removeAll()
            
            self.atributes.append("Descripcion: ")
            self.atributes.append(self.gembaWalksArray[0].Descripcion)
            self.atributes.append("Fecha Reporte: ")
            self.atributes.append(self.gembaWalksArray[0].FechaReporte)
            self.atributes.append("Fecha Estimada: ")
            self.atributes.append(self.gembaWalksArray[0].FechaEstimada)
            self.atributes.append("Origen: ")
            self.atributes.append(self.gembaWalksArray[0].OrigenNombre)
            self.atributes.append("Reportador: ")
            self.atributes.append(self.gembaWalksArray[0].ReportadorNombre)
            self.atributes.append("Responsable: ")
            self.atributes.append(self.gembaWalksArray[0].ResponsableNombre)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton){
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        desController.IdCategoria = self.IdCategoria
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
    @IBAction func okButton(_ sender: UIButton){
        let respuestas:NSDictionary = self.ventanaArray[0] as! NSDictionary
        let IdVentana = respuestas["Id"];
        
        api.saveStatusVentana(IdVentana: IdVentana as! Int){(res) in
            if(res != 0)
            {
                let alert = UIAlertController(title: self.eventoArray[0].Descripcion, message: "Cambio de estatus completado", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func rejectButton(_ sender: UIButton){
        print("Reject")
    }
    
    func createFloatingButton() {
        self.okButton = UIButton(type: .custom)
        self.okButton.setTitleColor(.green, for: .normal)
        self.okButton.addTarget(self, action: #selector(okButton(_:)), for: UIControlEvents.touchUpInside)
        self.navigationController?.view.addSubview(okButton)
        
        self.rejectButton = UIButton(type: .custom)
        self.rejectButton.setTitleColor(.red, for: .normal)
        self.rejectButton.addTarget(self, action: #selector(rejectButton(_:)), for: UIControlEvents.touchUpInside)
        self.navigationController?.view.addSubview(rejectButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        okButton.layer.cornerRadius = okButton.layer.frame.size.width/2
        okButton.backgroundColor = .green
        okButton.clipsToBounds = true
        let image = UIImage(named: "ok")?.withRenderingMode(.alwaysTemplate)
        okButton.setImage(image, for: .normal)
        okButton.tintColor = UIColor.white
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -250),
            okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            okButton.widthAnchor.constraint(equalToConstant: 50),
            okButton.heightAnchor.constraint(equalToConstant: 50)])
        
        rejectButton.layer.cornerRadius = okButton.layer.frame.size.width/2
        rejectButton.backgroundColor = .red
        rejectButton.clipsToBounds = true
        let imageReject = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        rejectButton.setImage(imageReject, for: .normal)
        rejectButton.tintColor = UIColor.white
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rejectButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            rejectButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            rejectButton.widthAnchor.constraint(equalToConstant: 50),
            rejectButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}
