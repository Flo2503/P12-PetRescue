//
//  MyAdTableViewCell.swift
//  PetRescue
//
//  Created by Flo on 21/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MyAdTableViewCell: UITableViewCell {
    // MARK: - Oulets
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animlalLocality: UILabel!
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(name: String, locality: String) {
        animalName.text = name
        animlalLocality.text = locality
    }

    func configureImage(image: UIImage) {
        animalPicture.image = image
        ItemSetUp.makeRounded(animalPicture)
    }
}
