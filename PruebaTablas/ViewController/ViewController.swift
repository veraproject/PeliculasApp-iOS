//
//  ViewController.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 22/02/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var personasTableView: UITableView!
    @IBOutlet weak var aceptarButton: UIButton!
    
    private var peliculas: Array<Pelicula>!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        peliculas = [Pelicula.init(titulo: "Coco", descripcion: "Pelicula coco", imagen: "img-coco"),
                     Pelicula.init(titulo: "Ole", descripcion: "Pelicula ole", imagen:"img-ole"),
                     Pelicula.init(titulo: "Jumanji", descripcion: "Pelicula jumanji", imagen: "img-jumanji")]
        
        SVProgressHUD.setDefaultMaskType(.black)
    }

    // MARK: - UserInteraction
    @IBAction func helloWorldPressed(_ sender: Any) {
        /*
        let alert = UIAlertController(title: "Hellow World",
                                      message: "Guardar tus cambios antes que se reinice tu pc",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        */
        
        SVProgressHUD.show(withStatus: "Cargando peliculas")
        
        RestApi.sharedInstance.obtenerListadoPeliculas { (response, error) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                print(error?.detalle ?? "")
                SVProgressHUD.showError(withStatus: error?.detalle)
                return
            }
            
            self.peliculas = response?.listaPeliculas
            self.personasTableView.reloadData()
        }
        
        //RestApi.sharedInstance.obtenerListadoPersonas()
    }
    
    @IBAction func newPeliculaPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueNewPelicula", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueDetailPelicula" {
            let detailViewController:DetailViewController = segue.destination as! DetailViewController
            detailViewController.pelicula = sender as! Pelicula
        }
        /*
        if segue.identifier == "SegueNewPelicula" {
            let _:NewPeliculaViewController = segue.destination as! NewPeliculaViewController
        }
        */
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.peliculas.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeliculaViewCell.cellIdentifier, for: indexPath) as! PeliculaViewCell
        
        let pelicula: Pelicula = self.peliculas[indexPath.row]
        
        var imgPelicula = UIImage(named: pelicula.imagen)
        imgPelicula = (imgPelicula == nil) ? UIImage(named:"img-sinfoto"): imgPelicula
        
        cell.logoImageView.image = imgPelicula
        cell.titleLabel.text = pelicula.titulo
        cell.descriptionLabel.text = pelicula.descripcion
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula:Pelicula = self.peliculas[indexPath.row]
        //self.performSegue(withIdentifier: "SegueDetailPelicula", sender: pelicula)
        
        SVProgressHUD.show(withStatus: "Cargando pelicula")
        
        RestApi.sharedInstance.obtenerPelicula(idPelicula: pelicula.id) { (response, error) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                print(error?.detalle ?? "")
                SVProgressHUD.showError(withStatus: error?.detalle)
                return
            }
            
            self.performSegue(withIdentifier: "SegueDetailPelicula", sender: response)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pelicula:Pelicula = self.peliculas[indexPath.row]
            /*
            self.peliculas.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            */
            
            SVProgressHUD.show(withStatus: "Eliminando pelicula")
            
            RestApi.sharedInstance.eliminarPelicula(idPelicula: pelicula.id, completion: { (error) in
                SVProgressHUD.dismiss()
                
                if error != nil {
                    print(error?.detalle ?? "")
                    SVProgressHUD.showError(withStatus: error?.detalle)
                    return
                }
                
                self.peliculas.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            })

            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

