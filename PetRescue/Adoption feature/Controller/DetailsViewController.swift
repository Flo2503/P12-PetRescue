//
//  DetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 05/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class DetailsViewController: NavBarSetUp {

    var selectedAd: AdManager?

    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalKind: UILabel!
    @IBOutlet weak var animalGender: UILabel!
    @IBOutlet weak var animalAge: UILabel!
    @IBOutlet weak var anoimalLocality: UILabel!
    @IBOutlet weak var animalMoreDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        display()
        setup(label: [anoimalLocality, animalAge, animalGender, animalKind])
    }
}

extension DetailsViewController {
    private func display() {
        if let details = selectedAd?.details, let urlImage = selectedAd?.animalImage, let name = selectedAd?.name, let kind = selectedAd?.kind, let gender = selectedAd?.gender, let age = selectedAd?.age, let locality = selectedAd?.locality {
            animalName.text = name
            animalKind.text = kind
            animalGender.text = gender
            animalAge.text = age
            anoimalLocality.text = "Lieu d'hébergement actuel: \(locality)"
            animalMoreDetails.text = details
            AdManager.retrieveImage(url: urlImage, callback: { image in
                if let image = image {
                    self.animalImage.image = image
                }
            })
        }
    }

    private func setup(label: [UILabel]) {
        for item in label {
            item.layer.borderWidth = 1
            item.layer.borderColor = Colors.customGreen.cgColor
            item.layer.cornerRadius = item.frame.size.height / 2
        }
    }
}
