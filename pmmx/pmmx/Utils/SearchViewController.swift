//
//  SearchViewController.swift
//  pmmx
//
//  Created by ISPMMX on 11/28/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate
{
    func savePersona(Id : Int)
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    var IdEntorno : Int = 0
    var delegate : SearchViewControllerDelegate?
    var Id : Int = 0
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData = [Operador]()
    var isSearching: Bool = false
    let api = DBConections()
    var data = [Operador]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(IdEntorno != 0)
        {
            api.getPersonas(idPuesto: IdEntorno){(res) in
                self.data = res
                self.tableView.reloadData()
            }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.searchBar.delegate = self
        
        self.searchBar.returnKeyType = UIReturnKeyType.done
        menuButton.target = revealViewController();
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredData.count
        }
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTable")
        let text : String!
        
        if isSearching{
            text = filteredData[indexPath.row].Nombre+" "+data[indexPath.row].Apellido1+" "+data[indexPath.row].Apellido2
        }
        else
        {
          text = data[indexPath.row].Nombre+" "+data[indexPath.row].Apellido1+" "+data[indexPath.row].Apellido2
        }
        cell?.textLabel?.text = text
        cell?.imageView?.image = UIImage(named: "userProfile")
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.tableView.reloadData()
        }
        else
        {
            isSearching = true
            filteredData = data.filter({ $0.Nombre.contains(searchText)})
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Id = data[indexPath.row].Id
        self.returnToController(Id: Id)
    }
    
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func returnToController(Id: Int)
    {
        if (self.delegate) != nil
        {
                delegate?.savePersona(Id: Id)
                self.dismiss(animated: true, completion: nil)
        }
    }
}
