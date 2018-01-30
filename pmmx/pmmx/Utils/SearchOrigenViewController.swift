//
//  SearchOrigenViewController.swift
//  pmmx
//
//  Created by ISPMMX on 11/28/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

protocol SearchOrigenViewControllerDelegate
{
    func saveOrigen(Id : Int, Text: String)
}

class SearchOrigenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    var IdEntorno : Int = 0
    var delegate : SearchOrigenViewControllerDelegate?
    var Id : Int = 0
    var Text : String = ""
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData = [Origen]()
    var isSearching: Bool = false
    let api = DBConections()
    var data = [Origen]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(IdEntorno != 0)
        {
            api.getOrigenes(){(res) in
                self.data = res
                self.tableView.reloadData()
            }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.searchBar.delegate = self
        
        self.searchBar.returnKeyType = UIReturnKeyType.done
        //menuButton.target = revealViewController();
        //menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
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
            text = filteredData[indexPath.row].NombreOrigen
        }
        else
        {
            text = data[indexPath.row].NombreOrigen
        }
        cell?.textLabel?.text = text
        cell?.imageView?.image = UIImage(named: "settings")
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
            filteredData = data.filter({ ($0.NombreOrigen?.contains(searchText))!})
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Id = data[indexPath.row].Id!
        Text = data[indexPath.row].NombreOrigen!
        self.returnToController(Id: Id,Text: Text)
    }
    
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func returnToController(Id: Int, Text: String)
    {
        if (self.delegate) != nil
        {
            delegate?.saveOrigen(Id: Id, Text: Text)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

