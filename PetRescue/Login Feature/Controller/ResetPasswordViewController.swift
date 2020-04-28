//
//  ResetPasswordViewController.swift
//  PetRescue
//
//  Created by Flo on 28/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DisplaySetUp.textFieldSetUp([emailAdressResetPassword])
        DisplaySetUp.buttonsetUp(validateResetPassword)
    }

    @IBOutlet weak var labelResetPassword: UILabel!
    @IBOutlet weak var emailAdressResetPassword: UITextField!
    @IBOutlet weak var validateResetPassword: UIButton!

    @IBAction func resetPassword(_ sender: Any) {
        let isEmailAddressValid = ValueManager.isValidEmailAddress(emailAddressString: emailAdressResetPassword.text!, textField: emailAdressResetPassword)
        if isEmailAddressValid {
            emailAdressResetPassword.layer.borderColor = Colors.customGreen.cgColor
            labelResetPassword.text = "Mail envoyé avec succès !"
            UserManager.sendPasswordReset(withEmail: emailAdressResetPassword.text!)
        } else {
            labelResetPassword.text = "Adresse mail non valide"
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdressResetPassword.resignFirstResponder()
    }
}
