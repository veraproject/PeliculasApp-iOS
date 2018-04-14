//
//  DetailViewController.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 27/02/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    public var pelicula:Pelicula!
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var logoImageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleLabel.text = self.pelicula.titulo
        self.descriptionLabel.text = self.pelicula.descripcion
        
        
        var imgPelicula = UIImage(named: pelicula.imagen)
        imgPelicula = (imgPelicula == nil) ? UIImage(named:"img-sinfoto"): imgPelicula
        
        self.logoImageView.image = imgPelicula
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
