//
//  WeeklyViewController.swift
//  PMMX
//
//  Created by ISPMMX on 9/28/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import UIKit
import Alamofire
import Charts

class WeeklyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var pickerWC = UIPickerView()
    var pickerHC = UIPickerView()
    var pickerTo = UIDatePicker()
    var pickerFrom = UIDatePicker()
        
    var healthChecks = [GrupoPreguntas]()
    var workCenters = [WorkCenter]()
    var wcValue : Int = -1
    var hcValue : Int = -1
    var semanas : [Int] = []
    var array: NSMutableArray = []
    var initDate: Int = -1
    var finalDate: Int = -1
    let api = DBConections()
    
    @IBOutlet weak var txtWorkCenter: UITextField!
    @IBOutlet weak var txtHealthCheck: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    
    @IBOutlet weak var lineChartView: LineChartView!
   
        override func viewDidLoad()
        {
            super.viewDidLoad()
            pickerWC.dataSource = self
            pickerWC.delegate = self
            pickerHC.dataSource = self
            pickerHC.delegate = self
            
            downloadData()
            txtWorkCenter.inputView = pickerWC
            txtHealthCheck.inputView = pickerHC
            
            pickerTo.datePickerMode = UIDatePickerMode.date
            pickerTo.addTarget(self, action: #selector(self.datePickerValueChangeTo(sender:)), for: UIControlEvents.valueChanged)
            txtTo.inputView = pickerTo
            
            pickerFrom.datePickerMode = UIDatePickerMode.date
            pickerFrom.addTarget(self, action: #selector(self.datePickerValueChangeFrom(sender:)), for: UIControlEvents.valueChanged)
            txtFrom.inputView = pickerFrom
            
        }
        
        @objc func datePickerValueChangeTo(sender: UIDatePicker)
        {
            let formatter = DateFormatter()
            let components = Calendar.current.dateComponents([.day], from: sender.date, to: Date())
            
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.none
            txtTo.text = formatter.string(from: sender.date)
            
            self.initDate = components.day!
            self.view.endEditing(false)
            
            if(txtTo.text != "" && txtFrom.text != "")
            {
                self.lineData()
            }
        }
        
        @objc func datePickerValueChangeFrom(sender: UIDatePicker)
        {
            let formatter = DateFormatter()
            let components = Calendar.current.dateComponents([.day], from: sender.date, to: Date())
            
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.none
            txtFrom.text = formatter.string(from: sender.date)
            
            self.finalDate = components.day!
            self.view.endEditing(false)
            
            if(txtTo.text != "" && txtFrom.text != "")
            {
                self.lineData()
            }
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
    
        func lineChart()
        {
            var pno : [Any] = []
            var psi : [Any] = []
            var arraySemanas : [Any] = []
            
            for i in 0 ..< semanas.count{
                let noArray:NSDictionary = array[i] as! NSDictionary
                pno.append(noArray["PorcentajeNo"] as Any)
                
                let siArray:NSDictionary = array[i] as! NSDictionary
                psi.append(siArray["PorcentajeSi"] as Any)
                
                arraySemanas.append(self.semanas[i])
            }
            
            var yValues : [ChartDataEntry] = [ChartDataEntry]()
            var yValues1 : [ChartDataEntry] = [ChartDataEntry]()
            
            for i in 0 ..< arraySemanas.count {
                yValues.append(ChartDataEntry(x: Double(i + 1), y: pno[i] as! Double))
                yValues1.append(ChartDataEntry(x: Double(i + 1), y: psi[i] as! Double))
            }
            
            let data = LineChartData()
            let ds1 = LineChartDataSet(values: yValues1, label: "% Yes per week")
            ds1.colors = [NSUIColor.blue]
            data.addDataSet(ds1)
            
            self.lineChartView.data = data
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
        
        func lineData()
        {
            api.getRespuestas(idWorkCenter: wcValue, idHC: hcValue, Init: self.initDate, Finish: self.finalDate)
            {(res, res1)  in
                self.semanas = res
                self.array = (res1 as NSArray).mutableCopy() as! NSMutableArray
                self.lineChart()
                self.lineChartView.reloadInputViews()
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        open func viewWillAppear()
        {
            self.loadView()
            self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
        }
        
}

