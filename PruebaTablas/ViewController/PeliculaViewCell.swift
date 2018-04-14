//
//  PeliculaViewCell.swift
//  PruebaTablas
//
//  Created by Pedro Vera on 25/02/18.
//  Copyright © 2018 Pedro Vera. All rights reserved.
//

import UIKit

class PeliculaViewCell: UITableViewCell {
    
    static let cellIdentifier = "peliculaViewCell"
    
    @IBOutlet weak var logoImageView:UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
