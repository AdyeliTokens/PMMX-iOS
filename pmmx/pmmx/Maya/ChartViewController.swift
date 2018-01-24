//
//  ChartViewController.swift
//  PMMX
//
//  Created by ISPMMX on 8/31/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import Alamofire
import Foundation
import Charts
import UIKit

class ChartViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var commentsCollection: UICollectionView!
    @IBOutlet weak var pieChartView: PieChartView!
    var parameters: [AnyObject] = []
    var arrayRespuesta = [Respuesta]()
    var arrayComentarios = [Respuesta]()
    let api = DBConections()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = (parameters[1] as? String)!+" "+(parameters[2] as? String)!
        
        api.getRespuestas(IdOrigen: parameters[0] as! Int, IdMWCR: parameters[4] as! Int, IdHC: parameters[3] as! Int)
        {(res) in
            self.arrayRespuesta = res
            self.arrayComentarios = self.arrayRespuesta.filter { $0.Comentario != "" }
            self.showData()
        }
    }
    
    func showData()
    {
        if(self.arrayRespuesta.count > 0)
        {
            self.pieChart()
            self.commentsCollection.reloadData()
        }
        else
        {
            let messageLabel = UILabel(frame: CGRect(x: self.view.bounds.size.width/3, y: self.view.bounds.size.height/2, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No data available.\nPlease try again."
            messageLabel.numberOfLines = 2;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.view.addSubview(messageLabel);
        }
    }
        
    func pieChart()
    {
        let track = ["%No", "%Si"]
        let money = [arrayRespuesta[0].PorcentajeNo, arrayRespuesta[0].PorcentajeSi]
        
        var entries = [PieChartDataEntry]()
        
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = track[index]
            entries.append( entry)
        }
        
        let set = PieChartDataSet( values: entries, label: "")
        let colors: [UIColor] = [UIColor(red: 33/255, green: 102/255, blue: 167/255, alpha: 1.0), UIColor(red: 0/255, green: 153/255, blue: 204/255, alpha: 1.0)]
        set.colors = colors
        let data = PieChartData(dataSet: set)
        self.pieChartView.data = data
        self.pieChartView.noDataText = "No data available"
        self.pieChartView.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = ("Total No: \(arrayRespuesta[0].TotalNo)"+"\n"+"Total Si: \(arrayRespuesta[0].TotalSi)")
        self.pieChartView.chartDescription = d
        self.pieChartView.centerText = (parameters[1] as? String)!+" "+(parameters[2] as? String)!
        self.pieChartView.holeRadiusPercent = 0.5
        self.pieChartView.transparentCircleColor = UIColor.clear
    }
    
    open func viewWillAppear()
    {
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayComentarios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.txtAsk.numberOfLines = 0
        cell.txtComment.numberOfLines = 0
        
        cell.txtAsk.text = (self.arrayComentarios[indexPath.row].DescripcionPregunta)
        cell.txtComment.text = (self.arrayComentarios[indexPath.row].Comentario)
        cell.txtBy.text = (self.arrayComentarios[indexPath.row].RespuestaBy)
        cell.imgImage.image = self.textToImage(drawText: (" ") as NSString, inImage: #imageLiteral(resourceName: "user"), atPoint: CGPoint(x: 40,y :40))
        return cell
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
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
    
}
