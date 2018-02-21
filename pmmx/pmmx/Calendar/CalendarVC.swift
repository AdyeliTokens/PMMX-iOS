//
//  CalendarVC.swift
//  pmmx
//
//  Created by ISPMMX on 11/15/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import FSCalendar
import UIKit

class CalendarVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance
{
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var eventosArray = [Eventos]()
    let api = DBConections()
    var somedays : Array = [String]()
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.loadData(Dias: -30)
        self.createFloatingButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var roundButton = UIButton()
    func createFloatingButton() {
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.red, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControlEvents.touchUpInside)
        //change view to navigationController?.view, if you have a navigationController in this tableview
        self.navigationController?.view.addSubview(roundButton)
    }
    
    @IBAction func ButtonClick(_ sender: UIButton){
        print("Add")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.red
        roundButton.clipsToBounds = true
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        roundButton.setImage(image, for: .normal)
        roundButton.tintColor = UIColor.white
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       self.calendar.reloadData()
       return self.eventosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarViewCell")
        cell?.imageView?.image = UIImage(named: "calendar")
        cell?.textLabel?.text = self.eventosArray[indexPath.row].Descripcion+" "+self.eventosArray[indexPath.row].FechaInicio
        
        var token = self.eventosArray[indexPath.row].FechaInicio.components(separatedBy: " ")
        self.somedays.append(token[0])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoria = self.eventosArray[indexPath.row].IdCategoria
         switch self.eventosArray[indexPath.row].IdCategoria
        {
          case 7:
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryBoard.instantiateViewController(withIdentifier: "SubMenuVC") as! SubMenuViewController
            desController.IdCategoria = categoria
            desController.IdEvento = self.eventosArray[indexPath.row].Id
            let frontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController().pushFrontViewController(frontViewController, animated: true)
          default:
                print(self.eventosArray[indexPath.row].IdCategoria)
        }
    }
    
    @IBAction func monthButton(_ sender: UIButton) {
        self.calendar.scope = .month
        self.loadData(Dias: -30)
    }
    
    @IBAction func weekButton(_ sender: UIButton) {
        self.calendar.scope = .week
        self.loadData(Dias: -7)
    }
    
    func loadData(Dias: Int)
    {
        api.getEventos(Dias: Dias){(res) in
            self.eventosArray = res
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let fecha = formatter.string(from: date)
        
        api.getEventosbyFecha(Fecha: fecha){(res) in
            self.eventosArray = res
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?
    {
        let dateString = dateFormatter1.string(from: date)
        
        if self.somedays.contains(dateString)
        {
            return UIColor.red
        }
        else
        {
            return nil
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desController = mainStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let frontViewController = UINavigationController.init(rootViewController: desController)
        revealViewController().pushFrontViewController(frontViewController, animated: true)
    }
    
}
