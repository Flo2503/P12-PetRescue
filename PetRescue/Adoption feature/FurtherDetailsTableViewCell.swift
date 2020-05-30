//
//  FurtherDetailsTableViewCell.swift
//  PetRescue
//
//  Created by Flo on 30/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class FurtherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var animalFurtherDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(details: String) {
        animalFurtherDetails.text = details
    }
}
