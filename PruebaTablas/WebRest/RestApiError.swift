//
//  RestApiError.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 6/03/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit

class RestApiError: NSObject {
    var estado:Int?
    var titulo:String?
    var detalle:String?
    
    init(estado:Int?, titulo:String?, detalle:String?) {
        self.estado = estado
        self.titulo = titulo
        self.detalle = detalle
    }
}
