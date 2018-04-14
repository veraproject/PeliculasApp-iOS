//
//  NewPeliculaViewController.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 10/03/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewPeliculaViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var genereTextField: UITextField!
    @IBOutlet weak var premiereSwitch: UISwitch!
    @IBOutlet weak var logoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.black)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UserInteraction
    @IBAction func guardarPeliculaPressed(_ sender: Any) {
        let pelicula = Pelicula.init(titulo: self.titleTextField.text!,
                                     descripcion: self.descriptionTextField.text!,
                                     genero: self.genereTextField.text!,
                                     estreno: self.premiereSwitch.isOn,
                                     logo: self.logoTextField.text!
        )
        
        SVProgressHUD.show(withStatus: "Registrando pelicula")
        
        RestApi.sharedInstance.registrarPelicula(pelicula: pelicula) { (error) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                print(error?.detalle ?? "")
                SVProgressHUD.showError(withStatus: error?.detalle)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
