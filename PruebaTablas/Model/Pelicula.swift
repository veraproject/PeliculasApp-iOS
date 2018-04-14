//
//  Pelicula.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 27/02/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit

class Pelicula: NSObject {
    
    public var id:String = ""
    public var titulo:String = ""
    public var descripcion:String = ""
    public var imagen:String = ""
    
    public var genero:String = ""
    public var estreno:Bool = false
    public var logo:String = ""
    
    init(titulo:String, descripcion:String, imagen:String) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.imagen = imagen
    }
    
    init(titulo:String, descripcion:String, genero:String, estreno:Bool, logo:String) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.genero = genero
        self.estreno = estreno
        self.logo = logo
    }
    
    init(json:JSON) {
        let id = json["id_pelicula"] as? String
        let titulo = json["titulo"] as? String
        let descripcion = json["descripcion"] as? String
        let imagen = json["logo"] as? String
        let genero = json["genero"] as? String
        let estreno = json["estreno"] as? Bool
        let logo = json["logo"] as? String
        
        self.id = id!
        self.titulo = titulo!
        self.descripcion = descripcion!
        self.imagen = imagen!
        self.genero = genero!
        self.estreno = estreno!
        self.logo = logo!
    }

}
