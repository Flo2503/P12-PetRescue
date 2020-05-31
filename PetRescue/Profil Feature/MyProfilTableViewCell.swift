//
//  MyProfilTableViewCell.swift
//  PetRescue
//
//  Created by Flo on 30/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MyProfilTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var userDetails: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureTitle(title: String) {
        titleCell.text = title
    }

    func configureDetails(details: String) {
        userDetails.text = details
    }
}
