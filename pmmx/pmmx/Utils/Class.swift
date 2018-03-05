//
//  Class.swift
//  pmmx
//
//  Created by ISPMMX on 11/14/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//
import Foundation

extension Date {
    init?(jsonDate: String) {
        let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
        let regex = try! NSRegularExpression(pattern: pattern)
        guard let match = regex.firstMatch(in: jsonDate, range: NSRange(jsonDate.startIndex..., in: jsonDate)) else {
            return nil
        }
        
        // Extract milliseconds:
        let dateString = jsonDate.substring(with: Range(match.range(at: 1), in: jsonDate)!)
        // Convert to UNIX timestamp in seconds:
        let timeStamp = Double(dateString)! / 1000.0
        // Create Date from timestamp:
        self.init(timeIntervalSince1970: timeStamp)
    }
}

class BussinesUnit
{
    let Id: Int
    let IdResponsable: Int
    let Nombre: String
    let NombreCorto: String
    let ParosActivos: Int
    let DefectosActivos: Int
    let Activo: Bool
    
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as! Int)
        self.IdResponsable = (dictionary["IdResponsable"] as? Int)!
        self.Nombre = (dictionary["Nombre"] as? String)!
        self.NombreCorto = (dictionary["NombreCorto"] as? String)!
        self.ParosActivos = (dictionary["ParosActivos"] as? Int)!
        self.DefectosActivos = (dictionary["DefectosActivos"] as? Int)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}

class Eventos
{
    let Id: Int
    let IdCategoria: Int
    let Descripcion: String
    var FechaInicio: String
    var FechaFin: String
    let Nota: String?
    let Activo: Bool
    
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as! Int)
        self.IdCategoria = (dictionary["IdCategoria"] as! Int)
        self.Descripcion = (dictionary["Descripcion"] as? String)!
        self.FechaInicio = (dictionary["FechaInicio"] as? String)!
        self.FechaFin = (dictionary["FechaFin"] as? String)!
        self.Nota = (dictionary["Nota"] as? String)
        self.Activo = (dictionary["Activo"] as? Bool)!
        
        
        //self.FechaInicio = dateFormater(Fecha: self.FechaInicio)
        //self.FechaFin = dateFormater(Fecha: self.FechaFin)
    }
    
    func dateFormater(Fecha: String) -> String
    {
        if let theDate = Date(jsonDate: Fecha) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: theDate)
            return myString
        }
        else
        {
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: Fecha)!
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            dateFormatter.locale = tempLocale // reset the locale
            let myString = dateFormatter.string(from: date)
            return myString
        }
    }
}

class JustDoIt
{
    let Id: Int
    let IdReportador : Int
    let IdOrigen : Int
    let Descripcion: String
    let IdResponsable: Int
    let Activo: Bool
    
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as! Int)
        self.IdReportador = (dictionary["IdReportador"] as? Int)!
        self.IdOrigen = (dictionary["IdOrigen"] as? Int)!
        self.Descripcion = (dictionary["Descripcion"] as? String)!
        self.IdResponsable = (dictionary["IdResponsable"] as? Int)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}

class SubCategoria
{
    let Id: Int
    let IdCategoria : Int
    let IdResponsable : Int
    let IdGrupo : Int
    let Nombre: String
    let NombreCorto: String
    let Activo: Bool
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as! Int)
        self.IdCategoria = (dictionary["IdCategoria"] as? Int)!
        self.IdGrupo = (dictionary["IdGrupo"] as? Int)!
        self.IdResponsable = (dictionary["IdResponsable"] as? Int)!
        self.Nombre = (dictionary["Nombre"] as? String)!
        self.NombreCorto = (dictionary["NombreCorto"] as? String)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}

class Operador
{
    let Id: Int
    let IdPuesto: Int
    let Nombre: String
    let Apellido1: String
    let Apellido2: String
    let Activo: Bool
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as! Int)
        self.IdPuesto = (dictionary["IdPuesto"] as? Int)!
        self.Nombre = (dictionary["Nombre"] as? String)!
        self.Apellido1 = (dictionary["Apellido1"] as? String)!
        self.Apellido2 = (dictionary["Apellido2"] as? String)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}

class Pregunta
{
    let Id: Int
    let IdGrupo: Int
    let Tipo: Int
    
    let Interrogante: String
    let Anexo1: String
    let Anexo2: String
    
    let Activo: Bool
    
    init(dictionary: [String: Any]) {
        self.Id = (dictionary["Id"] as? Int)!
        self.IdGrupo = (dictionary["IdGrupo"] as? Int)!
        self.Tipo = (dictionary["Tipo"] as? Int)!
        
        self.Interrogante = (dictionary["Interrogante"] as? String)!
        self.Anexo1 = (dictionary["Anexo1"] as? String)!
        self.Anexo2 = (dictionary["Anexo2"] as? String)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}


class WorkCenterbyHC
{
    let Id: Int
    let IdBussinesUnit: Int
    let ParosActivos: Int
    let DefectosActivos: Int
    
    let Nombre: String
    let NombreCorto: String
    let Activo: Bool
    
    let Modulos: String
    let BussinesUnit: String
    let Formatos: String
    
    init(dictionary: [String: AnyObject])
    {
        self.Id = (dictionary["Id"] as? Int)!
        self.IdBussinesUnit = (dictionary["IdBussinesUnit"] as? Int) ?? 0
        self.ParosActivos = (dictionary["ParosActivos"] as? Int) ?? 0
        self.DefectosActivos = (dictionary["DefectosActivos"] as? Int) ?? 0
        self.Nombre = dictionary["Nombre"] as? String ?? ""
        self.NombreCorto = dictionary["NombreCorto"] as? String ?? ""
        self.Activo = (dictionary["Activo"] as? Bool)!
        self.Modulos = dictionary["Modulos"] as? String ?? ""
        self.BussinesUnit = dictionary["BussinesUnit"] as? String ?? ""
        self.Formatos = dictionary["Formatos"] as? String ?? ""
    }
    
}

class WorkCenter
{
    let Id: Int
    let IdBussinesUnit: Int
    
    let Nombre: String
    let NombreCorto: String
    let Activo: Bool
    
    let Modulos: String
    let BussinesUnit: String
    let Formatos: String
    
    init(dictionary: [String: AnyObject])
    {
        self.Id = (dictionary["Id"] as? Int)!
        self.IdBussinesUnit = (dictionary["IdBussinesUnit"] as? Int) ?? 0
        self.Nombre = dictionary["Nombre"] as? String ?? ""
        self.NombreCorto = dictionary["NombreCorto"] as? String ?? ""
        self.Activo = (dictionary["Activo"] as? Bool)!
        self.Modulos = dictionary["Modulos"] as? String ?? ""
        self.BussinesUnit = dictionary["BussinesUnit"] as? String ?? ""
        self.Formatos = dictionary["Formatos"] as? String ?? ""
    }
    
}

class Respuesta
{
    let Activo : Bool
    let Comentario : String
    let DescripcionPregunta : String
    let Fecha : NSString
    let Id : Int
    let IdOrigenRespuesta : Int
    
    let OrigenRespuesta : NSNull
    let PorcentajeNo : Int
    let PorcentajeSi : Int
    let RespuestaBy : String
    let Solucion : Bool
    let TotalNo : Int
    let TotalSi : Int
    let TotalSolucion : Int
    
    init(dictionary: [String: AnyObject]) {
        self.Activo = (dictionary["Activo"] as! Bool)
        self.Comentario = (dictionary["Comentario"] as! String)
        self.DescripcionPregunta = (dictionary["DescripcionPregunta"] as! String)
        self.Fecha = (dictionary["Fecha"] as? NSString)!
        self.Id = (dictionary["Id"] as! Int)
        self.IdOrigenRespuesta = (dictionary["IdOrigenRespuesta"] as! Int)
        
        self.OrigenRespuesta = (dictionary["OrigenRespuesta"] as! NSNull)
        self.PorcentajeNo = (dictionary["PorcentajeNo"] as! Int)
        self.PorcentajeSi = (dictionary["PorcentajeSi"] as! Int)
        self.RespuestaBy = (dictionary["RespuestaBy"] as! String)
        self.Solucion = (dictionary["Solucion"] as! Bool)
        self.TotalNo = (dictionary["TotalNo"] as! Int)
        self.TotalSi = (dictionary["TotalSi"] as! Int)
        self.TotalSolucion = (dictionary["TotalSolucion"] as! Int)
    }
}

class GrupoPreguntas {
    var Id : Int
    var Nombre : String
    var DDS : Bool
    var IdCategoria : Int
    var Activo : Bool
    
    init(dictionary: [String: AnyObject]) {
        self.Id = (dictionary["Id"] as? Int)!
        self.Nombre = dictionary["Nombre"] as? String ?? ""
        self.DDS = (dictionary["Activo"] as? Bool)!
        self.IdCategoria = (dictionary["IdCategoria"] as? Int)!
        self.Activo = (dictionary["Activo"] as? Bool)!
    }
}

class PreguntaTurno {
    
    var Id: Int?
    var IdDia: Int?
    var IdOrigen: Int?
    var IdPregunta: Int?
    var IdTurno: Int?
    var Activo: Bool?
    
    var Pregunta: [Pregunta]
    
    init(Id: Int?, IdDia: Int?, IdOrigen: Int?, IdPregunta: Int?, IdTurno: Int?, Activo: Bool?, Pregunta: Pregunta?)
    {
        self.Id = Id
        self.IdDia = IdDia
        self.IdOrigen = IdOrigen
        self.IdPregunta = IdPregunta
        self.IdTurno = IdTurno
        self.Activo = Activo
        self.Pregunta = []
    }
}

class Persona{
    var Activo : Bool!
    var Apellido1 : String!
    var Apellido2 : String!
    var BussinesUnit : NSNull!
    var BussinesUnits : NSNull!
    var DefectosReportados : NSNull!
    var Dispositivos : NSNull!
    var Encuestado : NSNull!
    var Id : Int!
    var IdAspNetUser : Int!
    var IdBussinesUnit : Int!
    var IdPuesto : Int!
    var IdWorkCenter : Int!
    var Nombre : String!
    var Operador : NSNull!
    var ParosAsignados : NSNull!
    var ParosReportados : NSNull!
    var Puesto : NSNull!
    var Supervisor : NSNull!
    
    init(dictionary: [String: AnyObject]) {
        self.Activo = (dictionary["Activo"] as! Bool)
        self.Apellido1 = (dictionary["Apellido1"] as! String)
        self.Apellido2 = (dictionary["Apellido2"] as! String)
        self.BussinesUnit = (dictionary["BussinesUnit"] as! NSNull)
        self.BussinesUnits = (dictionary["BussinesUnits"] as! NSNull)
        self.DefectosReportados = (dictionary["DefectosReportados"] as! NSNull)
        self.Dispositivos = (dictionary["Dispositivos"] as! NSNull)
        self.Encuestado = (dictionary["Encuestado"] as! NSNull)
        self.Id = (dictionary["Id"] as! Int)
        self.IdAspNetUser = (dictionary["Id"] as! Int)
        self.IdBussinesUnit = (dictionary["Id"] as! Int)
        self.IdPuesto = (dictionary["Id"] as! Int)
        self.IdWorkCenter = (dictionary["Id"] as! Int)
        self.Nombre = (dictionary["Nombre"] as! String)
        self.Operador = (dictionary["Operador"] as! NSNull)
        self.ParosAsignados = (dictionary["ParosAsignados"] as! NSNull)
        self.ParosReportados = (dictionary["ParosReportados"] as! NSNull)
        self.Puesto = (dictionary["Puesto"] as! NSNull)
        self.Supervisor = (dictionary["Supervisor"] as! NSNull)
    }
}

class Origen
{
    var Id: Int?
    var IdModulo: Int?
    var IdWorkCenter: Int?
    var NombreOrigen: String?
    
    init(dictionary: [String: AnyObject]) {
        self.Id = (dictionary["Id"] as? Int)!
        self.IdModulo = (dictionary["IdModulo"] as? Int)!
        self.IdWorkCenter = (dictionary["IdWorkCenter"] as? Int)!
        self.NombreOrigen = (dictionary["NombreOrigen"] as? String)!
    }
}
