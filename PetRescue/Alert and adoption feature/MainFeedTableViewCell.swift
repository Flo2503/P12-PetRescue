//
//  MainFeedTableViewCell.swift
//  PetRescue
//
//  Created by Flo on 02/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MainFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    @IBOutlet weak var animalGender: UILabel!
    @IBOutlet weak var animalLocality: UILabel!
    @IBOutlet weak var whiteView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func addShadow() {
        whiteView.layer.shadowColor = UIColor.red.cgColor
        whiteView.layer.shadowRadius = 2.0
        whiteView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        whiteView.layer.shadowOpacity = 2.0
    }

    func configure(name: String, breed: String, gender: String, locality: String) {
        animalName.text = name
        animalBreed.text = breed
        animalGender.text = gender
        animalLocality.text = locality
    }
}
