//
//  SurveyVC.swift
//  PMMX
//
//  Created by ISPMMX on 8/24/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import Alamofire
import UIKit

class SurveyVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var surveyTable: UITableView!
    var parameters: [AnyObject] = []
    var arrayData: [AnyObject] = []
    var saveArray = [AnyObject]()
    var array: [Pregunta] = []
    var origenArray: NSMutableArray = []
    
    var indice : Int = 0
    var idMWCR : Int = 0
    var flagSave = false
    var txtComment: UITextField!
    
    let api = DBConections();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        downloadData()
        self.arrayData.removeAll()
       
        self.title = (parameters[3] as? String)!+" "+(parameters[1] as? String)!
        
        self.surveyTable.dataSource = self
        self.surveyTable.delegate = self
        self.surveyTable.separatorStyle = .none
    }
    
    func downloadData()
    {
        api.getPreguntas(idGrupo: parameters[2] as! Int)
        {(res)  in
            self.array = res
            self.showData()
        }
    }
    
    func showData()
    {
        if(self.array.count > 0)
        {
            self.arrayData.removeAll()
            
            api.getOrigen(IdWorkCenter: parameters[0] as! Int)
            {(res) in
                self.origenArray = (res as NSArray).mutableCopy() as! NSMutableArray
                let respuestas:NSDictionary = self.origenArray[0] as! NSDictionary
                self.arrayData.append(respuestas["Id"] as AnyObject);
                self.saveMWCR(IdOrigen: respuestas["Id"] as! Int);
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       if(self.array.count == 0 && self.flagSave == true)
            { saveAsk();}
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "surveyCell") as! CustomizeTableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.textColor = UIColor(red: 28/255, green: 87/255, blue: 145/255, alpha: 1)
        cell.textLabel?.text = array[indexPath.row].Interrogante
        cell.imageView?.image = self.textToImage(drawText: ((parameters[3] as! String)) as NSString, inImage: #imageLiteral(resourceName: "circle"), atPoint: CGPoint(x: 40,y :40))
        return cell
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor(red: 28/255, green: 87/255, blue: 145/255, alpha: 1)
        let textFont = UIFont(name: "Helvetica Bold", size: 21)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        self.indice = array[indexPath.row].Id

        let no = UITableViewRowAction(style: .destructive, title: "No") { (action, indexPath) in
            self.alertView()
            self.array.remove(at: indexPath.row)
            self.surveyTable.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            self.flagSave = true
         }
        
        let yes = UITableViewRowAction(style: .normal, title: "Si") { (action, indexPath) in
            self.addAnswer(respuesta: 1, comentario: "")
            self.array.remove(at: indexPath.row)
            self.surveyTable.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            self.flagSave = true
        }
        
        yes.backgroundColor = UIColor.blue
        no.backgroundColor = UIColor.red
        
        return [no, yes]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
    }
    
    func alertView()
    {
        let alert = UIAlertController(title: "NO", message: "Please add your comments", preferredStyle: .alert)
        alert.addTextField { (txtComment) in
            txtComment.text = ""
        }
       
        let saveAction = UIAlertAction(title: "Save",style: .default)
        { (action: UIAlertAction!) -> Void in
           let textField = alert.textFields![0]
           self.addAnswer(respuesta: 0, comentario: (textField.text!))
        }
        saveAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object:alert.textFields?[0],queue: OperationQueue.main)
        { (notification) -> Void in
           let textFieldName = alert.textFields?[0]
            saveAction.isEnabled = self.isValid(testStr: (textFieldName?.text!)!) &&  !(textFieldName?.text?.isEmpty)!
        }
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValid(testStr:String) -> Bool
    {
        if(testStr != "")
        {
            return true
        }
        return false
    }
    
    func addAnswer(respuesta: Int, comentario: String)
    {
        let res : [String: AnyObject] =  ["IdPregunta":   self.indice as AnyObject,
                                          "IdOrigenRespuesta": self.idMWCR as AnyObject,
                                          "Solucion":  respuesta as AnyObject,
                                          "Comentario":  comentario as AnyObject]
        
        self.saveArray.append(res as AnyObject)
    }
    
    func saveMWCR(IdOrigen: Int)
    {
        api.saveMWCR(IdOrigen: IdOrigen, IdOperador: parameters[4] as! Int)
        {(res)  in
            self.idMWCR  = res
            self.surveyTable.reloadData()
        }
    }
    
    func saveAsk()
    {
        api.saveAsk(saveArray: self.saveArray)
        {(res)  in
             let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ChartView") as! ChartViewController
                self.arrayData.append(self.parameters[1] as AnyObject)
                self.arrayData.append(self.parameters[3] as AnyObject)
                self.arrayData.append(self.parameters[0] as AnyObject)
                self.arrayData.append(self.idMWCR as AnyObject)
                
                myVC.parameters = self.arrayData
                self.navigationController?.pushViewController(myVC, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.navigationItem.hidesBackButton = true
    }
}
