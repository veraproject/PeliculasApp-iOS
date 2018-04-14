//
//  ObtenerPeliculaResponse.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 6/03/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit

class ObtenerPeliculasResponse: NSObject {
    let listaPeliculas: [Pelicula]
    
    init(json: [JSON]) throws {
        let listaPeliculas = json.map{ Pelicula(json: $0)}.flatMap{ $0 }
        self.listaPeliculas = listaPeliculas
    }
}
