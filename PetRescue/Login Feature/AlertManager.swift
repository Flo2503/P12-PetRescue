//
//  AlertManager.swift
//  PetRescue
//
//  Created by Flo on 27/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func emptyFieldAlert() {
            let alertVC = UIAlertController(title: "Champ vide", message: "Merci de renseigner tous les champs", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }

     func noMatchPasswordAlert() {
        let alertVC = UIAlertController(title: "Mots de passe incorrects", message: "Les mots de passe ne correspondent pas", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
