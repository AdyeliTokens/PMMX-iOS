//
//  DBConections.swift
//  pmmx
//
//  Created by ISPMMX on 11/14/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import Alamofire
import UIKit

class DBConections: UIViewController
{
    var workCentersArray = [WorkCenter]()
    var grupoPreguntas = [GrupoPreguntas]()
    var bussinesUnitArray = [BussinesUnit]()
    var eventosArray = [Eventos]()
    var justDoItArray = [JustDoIt]()
    var operadorArray = [Operador]()
    var respuestaArray = [Respuesta]()
    var semanasArray : [Int] = []
    var nsmutableArray: NSMutableArray = []
    var preguntasArray = [Pregunta]()
    var subCategoriaArray = [SubCategoria]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBussinesUnit(completion:@escaping (Array<BussinesUnit>) -> Void )
    {
        self.bussinesUnitArray.removeAll()
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/BussinesUnit" as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json {
                        self.bussinesUnitArray.append(BussinesUnit(dictionary: obj))
                        self.bussinesUnitArray.sort(by: { $0.NombreCorto > $1.NombreCorto })
                }
                 completion(self.bussinesUnitArray)
            }
        }
    }
    
    func getEventos(Dias: Int,completion:@escaping (Array<Eventos>) -> Void )
    {
        self.eventosArray.removeAll()
        let defaultValues = UserDefaults.standard
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Evento?idResponsable="+String(describing: defaultValues.string(forKey: "IdPersona") ?? "")+"&dias="+String(describing: Dias)+"&activo=true"
        
        self.eventosArray.removeAll()
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json {
                    self.eventosArray.append(Eventos(dictionary: obj))
                }
                completion(self.eventosArray)
            }
        }
    }
    
    func getEventosbyFecha(Fecha: String,completion:@escaping (Array<Eventos>) -> Void )
    {
        self.eventosArray.removeAll()
        let defaultValues = UserDefaults.standard
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Evento?idResponsable="+String(describing: defaultValues.string(forKey: "IdPersona") ?? "")+"&fecha="+Fecha+"&activo=true"
        
        self.eventosArray.removeAll()
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json {
                    self.eventosArray.append(Eventos(dictionary: obj))
                }
                completion(self.eventosArray)
            }
        }
    }
    
    func getPersonas(idPuesto: Int,completion:@escaping (Array<Operador>) -> Void )
    {
        self.operadorArray.removeAll()
        let URL_CONNECT = "https://serverpmi.tr3sco.net/api/Persona?IdPuesto="+String(describing: idPuesto) as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json {
                    self.operadorArray.append(Operador(dictionary: obj))
                    self.operadorArray.sort(by: { $0.Id > $1.Id })
                }
                completion(self.operadorArray)
            }
        }
    }
    
    func getWorkCenters(completion:@escaping (Array<WorkCenter>) -> Void )
    {
        self.workCentersArray.removeAll()
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/WorkCenter" as String
            
            Alamofire.request(URL_CONNECT).responseJSON{ response in
                if let json = response.result.value as? [[String:AnyObject]] {
                    for hc in json {
                        self.workCentersArray.append(WorkCenter(dictionary: hc))
                        self.workCentersArray.sort(by: { $0.NombreCorto > $1.NombreCorto })
                    }
                    completion(self.workCentersArray)
                }
            }
    }
        
    func getGrupoPreguntas(IdCategoria: Int,completion:@escaping (Array<GrupoPreguntas>) -> Void )
    {
        self.grupoPreguntas.removeAll()
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/GrupoPreguntas?idCategoria="+String(describing: IdCategoria) as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
                if let json = response.result.value as? [[String:AnyObject]] {
                    for hc in json {
                        self.grupoPreguntas.append(GrupoPreguntas(dictionary: hc))
                        self.grupoPreguntas.sort(by: { $0.Id > $1.Id })
                    }
                    completion(self.grupoPreguntas)
                }
            }
    }
    
    func getRespuestas(IdOrigen: Int, IdMWCR: Int, IdHC: Int ,completion:@escaping (Array<Respuesta>) -> Void )
    {
        self.respuestaArray.removeAll()
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Respuesta?idOrigen="+String(describing: IdOrigen)+"&idMWCR="+String(describing: IdMWCR)+"&idDDS=0&idHC="+String(describing: IdHC)
        print(URL_CONNECT)
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]]{
                for obj in json{
                    self.respuestaArray.append(Respuesta(dictionary: obj))
                }
                completion(self.respuestaArray)
            }
        }
    }
    
    func getRespuestas(idWorkCenter: Int, idHC: Int, Init: Int, Finish: Int,completion:@escaping (Array<Int>, Array<NSMutableArray>) -> Void )
    {
        self.nsmutableArray.removeAllObjects()
        self.semanasArray.removeAll()
        
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Respuesta?idWorkCenter="+String(describing: idWorkCenter as Int)+"&idHC="+String(describing: idHC as Int)+"&Init="+String(describing: Init as Int)+"&Finish="+String(describing: Finish as Int)
        print(URL_CONNECT)
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json
                {
                    self.semanasArray = json.flatMap { $0["numero"] as? Int }
                    self.nsmutableArray = (obj["Respuestas"]! as! NSArray).mutableCopy() as! NSMutableArray
                }
                completion(self.semanasArray,self.nsmutableArray as! Array<NSMutableArray>)
            }
        }
    }
    
    func getPreguntas(idGrupo: Int,completion:@escaping (Array<Pregunta>) -> Void )
    {
        self.preguntasArray.removeAll()
        
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Pregunta?idGrupo="+String(describing: idGrupo) as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json
                {
                    self.preguntasArray.append(Pregunta(dictionary: obj))
                }
                completion(self.preguntasArray)
            }
        }
    }
    
    func getOrigen(IdWorkCenter: Int, completion:@escaping (Array<NSDictionary>) -> Void )
    {
       let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Origen?idLinkup="+String(describing: IdWorkCenter) as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            switch(response.result)
            {
                case .success(_):
                    if let result = response.result.value
                    {
                        if(( (result as AnyObject).count ) != nil)
                        {
                            let jsonData = result as! NSDictionary
                            completion([jsonData])
                        }
                        else
                        {
                            print("without data")
                        }
                    }
                    break
                case .failure(_):
                    guard case let .failure(error) = response.result else { return }
                    print(error)
                    break
            }
        }
    }
    
    func getOrigenbyName(name: String, completion:@escaping (Array<NSDictionary>) -> Void )
    {
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Origen?nameModulo="+name as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            switch(response.result)
            {
            case .success(_):
                if let result = response.result.value
                {
                    if(( (result as AnyObject).count ) != nil)
                    {
                        let jsonData = result as! NSDictionary
                        completion([jsonData])
                    }
                    else
                    {
                        print("without data")
                    }
                }
                break
            case .failure(_):
                guard case let .failure(error) = response.result else { return }
                print(error)
                break
            }
        }
    }
    
    func getSubCategoria(IdCategoria: Int,completion:@escaping (Array<SubCategoria>) -> Void )
    {
        self.subCategoriaArray.removeAll()
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/SubCategoria?idCategoria="+String(describing: IdCategoria) as String
        
        Alamofire.request(URL_CONNECT).responseJSON{ response in
            if let json = response.result.value as? [[String:AnyObject]] {
                for obj in json {
                    self.subCategoriaArray.append(SubCategoria(dictionary: obj))
                    self.subCategoriaArray.sort(by: { $0.NombreCorto > $1.NombreCorto })
                }
                completion(self.subCategoriaArray)
            }
        }
    }
    
/* SAVE FUNCTIONS */
    func saveJustDoIt(IdEvento: Int,IdOrigen: Int,Descripcion: String, IdPersona: Int, IdSubCategoria: Int, IdTipo: Int,completion:@escaping (Int) -> Void )
    {
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/GembaWalk" as String
        let defaultValues = UserDefaults.standard
        let parameters: Parameters = [
            "IdEvento": IdEvento,
            "IdReportador" : defaultValues.string(forKey: "IdPersona") ?? "",
            "IdOrigen": IdOrigen,
            "Descripcion": Descripcion,
            "Prioridad": 1,
            "IdResponsable" : IdPersona,
            "IdSubCategoria" : 8,
            "IdTipo" : IdTipo
        ]
        
        Alamofire.request(URL_CONNECT, method: .post, parameters: parameters).responseJSON{ response in
            switch(response.result)
            {
            case .success(_):
                if let result = response.result.value
                {
                    if(( (result as AnyObject).count ) != nil)
                    {
                        let jsonData = result as! NSDictionary
                        let Id = jsonData.value(forKey: "Id")
                        completion(Id as! Int)
                    }
                    else
                    {
                        completion(0)
                    }
                    
                }
                break
            case .failure(_):
                guard case let .failure(error) = response.result else { return }
                print(error)
                break
            }
        }
    }
    
    func saveMWCR(IdOrigen: Int, IdOperador: Int ,completion:@escaping (Int) -> Void )
    {
        let defaultValues = UserDefaults.standard
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/OrigenRespuesta" as String
        
        let pMWCR: Parameters = [
            "IdOrigen": IdOrigen,
            "IdOperador" : IdOperador,
            "IdEntrevistado" : defaultValues.string(forKey: "IdPersona") as Any
        ]
        
        Alamofire.request(URL_CONNECT, method: .post, parameters: pMWCR, encoding: JSONEncoding.default).responseJSON{ response in
            if let json = response.result.value as? [String:AnyObject] {
                completion(json["Id"] as! Int)
            }
            else
            {
                completion(0)
            }
        }
    }
    
    func saveAsk(saveArray : Array<AnyObject>, completion:@escaping (Bool) -> Void)
    {
        let URL_CONNECT = "http://serverpmi.tr3sco.net/api/Respuesta" as String
        var flag: Bool = false
        
        for index in 0..<saveArray.count
        {
            let pRespuesta : Parameters = saveArray[index] as! Parameters
            
            Alamofire.request(URL_CONNECT, method: .post, parameters: pRespuesta, encoding: JSONEncoding.default).responseJSON{ response in
                if (response.result.value as? [[String:AnyObject]]) != nil {
                    flag = true
                }
            }
        }
        completion(flag)
    }
    
}
