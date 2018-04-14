//
//  RestApi.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 6/03/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

typealias JSON = [String: Any]

public class RestApi: NSObject {
    
    public static let sharedInstance = RestApi()
    
    var alamofireManager : Alamofire.SessionManager?
    let reachability = Reachability()
    
    let upsError:RestApiError = RestApiError(estado: 999, titulo: "¡Ups!", detalle: "Ocurrió un problema en los servicios, por favor intenta nuevamente.")
    let redError:RestApiError = RestApiError(estado: 999, titulo: "", detalle: "Tu conexión a internet esta fallando, por favor intenta de nuevo.")
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    private override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5  //.timeoutIntervalForResource = 10
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func obtenerListadoPersonas () {
        let url = "http://swapi.co/api/people/"
        
        self.alamofireManager?.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            
            print(response.result)
            
            if let JSON = response.result.value as? JSON {
                print("JSON \(JSON)")
            }
        })
    }
    
    func obtenerListadoPeliculas (completion:@escaping (ObtenerPeliculasResponse?,RestApiError?) -> Void){
        if (!self.isThereNetworkConnection()) {
            completion(nil, self.redError)
            return
        }
        
        let url = "https://1nql88kfw5.execute-api.us-east-2.amazonaws.com/dev/listarpeliculas"
        /*
        self.alamofireManager?.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData(completionHandler: { (response) in
            print(response.result.value)
        })
        */
        self.alamofireManager?.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            //print(response.request!)
            //print(response.response!)
            //print(response.data!)
            //print(response.result)
            
            switch response.result {
            case .success:
                guard let json = response.result.value as? [JSON] else {
                    completion(nil, self.upsError)
                    return
                }
                
                do {
                    let getPeopleResponse = try ObtenerPeliculasResponse(json: json)
                    completion(getPeopleResponse, nil)
                } catch {
                    completion(nil, self.upsError)
                }
                
            case .failure(_):
                completion(nil, self.upsError)
            }
        })
    }
    
    func eliminarPelicula(idPelicula:String,
                          completion:@escaping (RestApiError?) -> Void) {
        if (!self.isThereNetworkConnection()) {
            completion(self.redError)
            return
        }
        
        let url = "https://1nql88kfw5.execute-api.us-east-2.amazonaws.com/dev/eliminarpelicula"
        
        let parameters : [ String : Any] = [
            "idpelicula" : idPelicula
        ]
        
        self.alamofireManager?.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            
            print(response.result)
            
            switch response.result {
            case .success:
                completion(nil)
            case .failure(_):
                completion(self.upsError)
            }
        })
    }
    
    func obtenerPelicula(idPelicula:String,
                         completion:@escaping (Pelicula?,RestApiError?) -> Void){
        if (!self.isThereNetworkConnection()) {
            completion(nil, self.redError)
            return
        }
        //let url = "https://1nql88kfw5.execute-api.us-east-2.amazonaws.com/dev/detallepelicula?idpelicula=%22\(idPelicula)%22"
        let url = "https://1nql88kfw5.execute-api.us-east-2.amazonaws.com/dev/detallepelicula"
        
        let parameters : [ String : Any] = [
            "idpelicula" :"\"\(idPelicula)\""
        ]
        //URLEncoding(destination:.queryString)
        self.alamofireManager?.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            
            switch response.result {
            case .success:
                guard let json = response.result.value as? JSON else {
                    completion(nil, self.upsError)
                    return
                }
                
                let item = json.flatMap{ $0 }[0].value
                let pelicula = Pelicula(json: item as! JSON)
                
                completion(pelicula, nil)
            case .failure(_):
                completion(nil, self.upsError)
            }
        })
        
    }
    
    func registrarPelicula(pelicula:Pelicula,
                           completion:@escaping (RestApiError?) -> Void) {
        if (!self.isThereNetworkConnection()) {
            completion(self.redError)
            return
        }
        
        let url = "https://1nql88kfw5.execute-api.us-east-2.amazonaws.com/dev/agregarpeliculav2"
        
        let parameters : [ String : Any] = [
            "titulo" : pelicula.titulo,
            "descripcion": pelicula.descripcion,
            "genero": pelicula.genero,
            "estreno": pelicula.estreno,
            "logo": pelicula.logo
        ]

        self.alamofireManager?.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
            
            print(response.result)
            
            switch response.result {
            case .success:
                completion(nil)
            case .failure(_):
                completion(self.upsError)
            }
        })
    }
    
    func isThereNetworkConnection()->Bool{
        let isConnected:Bool = (self.reachability?.isReachable)!
        return isConnected
    }

}
