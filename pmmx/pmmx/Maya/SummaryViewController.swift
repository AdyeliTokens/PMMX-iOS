//
//  SummaryViewController.swift
//  PMMX
//
//  Created by ISPMMX on 9/26/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import UIKit
import Alamofire
import Charts

class SummaryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var pickerWC = UIPickerView()
    var pickerHC = UIPickerView()
    
    
    var healthChecks = [GrupoPreguntas]()
    var workCenters = [WorkCenter]()
    var wcValue : Int = -1
    var hcValue : Int = -1
    var semanas : [Int] = []
    var array: NSMutableArray = []
    let api = DBConections();
    
    
    @IBOutlet weak var txtWorkCenter: UITextField!
    @IBOutlet weak var txtHealthCheck: UITextField!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var txtTotalNo: UILabel!
    @IBOutlet weak var txtTotalSi: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtPorcentajeSi: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pickerWC.dataSource = self
        pickerWC.delegate = self
        pickerHC.dataSource = self
        pickerHC.delegate = self
        
        self.downloadData()
        txtWorkCenter.inputView = pickerWC
        txtHealthCheck.inputView = pickerHC
        
        self.pieChartView.isHidden = true
        self.txtTotalNo.isHidden = true
        self.txtTotalSi.isHidden = true
        self.txtTotal.isHidden = true
        self.txtPorcentajeSi.isHidden = true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = workCenters.count
        
        if(pickerView == pickerHC)
        {
            countRows = healthChecks.count
        }
        
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView == pickerWC)
        {
            txtWorkCenter.text = workCenters[row].NombreCorto
            wcValue = workCenters[row].Id
            self.view.endEditing(false)
        }
        else
        {
            txtHealthCheck.text = healthChecks[row].Nombre
            hcValue = healthChecks[row].Id
            self.view.endEditing(false)
        }
        
        if(wcValue != -1 && hcValue != -1)
        {
            api.getRespuestas(idWorkCenter: wcValue, idHC: hcValue, Init: 1, Finish: 1)
            {(res, res1)  in
                self.semanas = res
                self.array = (res1 as NSArray).mutableCopy() as! NSMutableArray
                self.showData()
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == pickerWC)
        {
            return workCenters[row].NombreCorto
        }
        else
        {
            return healthChecks[row].Nombre
        }
    }
    
    func pieChart()
    {
        self.pieChartView.isHidden = false
        let respuestas:NSDictionary = array[0] as! NSDictionary
        if(respuestas.count > 0)
        {
            let track = [" ","%Si"]
            let money = [respuestas["PorcentajeNo"] as! Double, respuestas["PorcentajeSi"] as! Double]
            
            var entries = [PieChartDataEntry]()
            
            for (index, value) in money.enumerated() {
                let entry = PieChartDataEntry()
                entry.y = Double(value)
                entry.label = track[index]
                entries.append( entry)
            }
            
            let set = PieChartDataSet( values: entries, label: "")
            let colors: [UIColor] = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), UIColor(red: 0/255, green: 153/255, blue: 204/255, alpha: 1.0)]
            set.colors = colors
            let data = PieChartData(dataSet: set)
            self.pieChartView.data = data
            self.pieChartView.noDataText = "No data available"
            self.pieChartView.isUserInteractionEnabled = true
            
            let d = Description()
            d.text = " "
            self.pieChartView.chartDescription = d
            self.pieChartView.holeRadiusPercent = 0.6
            self.pieChartView.centerText = (respuestas["PorcentajeSi"])! as? String
            self.pieChartView.transparentCircleColor = UIColor.clear
            
            self.txtTotalNo.isHidden = false
            self.txtTotalSi.isHidden = false
            self.txtTotal.isHidden = false
            self.txtPorcentajeSi.isHidden = false

            self.txtTotal.text   = "Total        "+String(describing: respuestas["TotalSolucion"] as! Int)
            self.txtTotalSi.text = "Total Si    "+String(describing: respuestas["TotalSi"] as! Int)
            self.txtTotalNo.text = "Total No    "+String(describing: respuestas["TotalNo"] as! Int)
            self.txtPorcentajeSi.text = String(describing: respuestas["PorcentajeSi"] as! Int)+" % "
            
            if ((respuestas["PorcentajeSi"] as! Int ) < 60)
            {
                self.txtPorcentajeSi.backgroundColor = UIColor(red: 239/255.0, green: 83/255.0, blue: 80/255.0, alpha: 1.0)
            }
            
            if (respuestas["PorcentajeSi"] as! Int >= 60)
            {
                self.txtPorcentajeSi.backgroundColor = UIColor(red: 255/255.0, green: 235/255.0, blue: 59/255.0, alpha: 1.0)
            }
            
            if (respuestas["PorcentajeSi"] as! Int >= 80)
            {
                self.txtPorcentajeSi.backgroundColor = UIColor(red: 0/255.0, green: 153/255.0, blue: 0/255.0, alpha: 1.0)
            }
        }
    }
    
    func downloadData()
    {
        api.getGrupoPreguntas(IdCategoria: 13){(res) in
            self.healthChecks = res
            self.pickerHC.reloadAllComponents()
        }
        
        api.getWorkCenters(){(res) in
            self.workCenters = res
            self.pickerWC.reloadAllComponents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    open func viewWillAppear()
    {
        self.loadView()
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func showData()
    {
        if(self.array.count > 0)
        {
            self.pieChart()
            self.pieChartView.reloadInputViews()
        }
        else
        {
            let messageButton: UIButton = UIButton(frame: CGRect(x: self.view.bounds.size.width/3, y: self.view.bounds.size.height/2, width: 200, height: 100))
            messageButton.backgroundColor = UIColor(red: 48/255.0, green: 145/255.0, blue: 240/255.0, alpha: 1.0)
            messageButton.setTitle("Please try again.", for: .normal)
            messageButton.sizeToFit()
            messageButton.addTarget(self, action: #selector(reloadView), for: .touchUpInside)
            
            self.view.addSubview(messageButton)
        }
    }
    
    @objc func reloadView()
    {
        self.loadView()
        self.viewDidLoad()
    }
    
}
