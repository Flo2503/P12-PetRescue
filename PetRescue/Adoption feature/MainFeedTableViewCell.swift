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
    @IBOutlet weak var animalKind: UILabel!
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
        whiteView.layer.shadowColor = UIColor.gray.cgColor
        whiteView.layer.shadowRadius = 2.0
        whiteView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        whiteView.layer.shadowOpacity = 2.0
        whiteView.layer.cornerRadius = whiteView.frame.size.height / 6
    }

    func configure(name: String, kind: String, locality: String) {
        animalName.text = name
        animalKind.text = kind
        animalLocality.text = locality
    }

    func configureImage(image: UIImage) {
        animalPicture.image = image
        animalPicture.layer.cornerRadius = animalPicture.frame.size.height / 6
        animalPicture.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
