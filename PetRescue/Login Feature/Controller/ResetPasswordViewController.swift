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
        ItemSetUp.textFieldSetUp([emailAdressResetPassword])
        ItemSetUp.buttonSetUp([validateResetPassword])
    }

    @IBOutlet weak var labelResetPassword: UILabel!
    @IBOutlet weak var emailAdressResetPassword: UITextField!
    @IBOutlet weak var validateResetPassword: UIButton!

    @IBAction func resetPassword(_ sender: Any) {
        let isEmailAddressValid = InputValuesManager.isValidEmailAddress(emailAddressString: emailAdressResetPassword.text!)
        if isEmailAddressValid {
            if let email = emailAdressResetPassword.text {
                UserManager.sendPasswordReset(withEmail: email, callback: { success in
                    if success {
                        self.emailAdressResetPassword.layer.borderColor = Colors.customGreen.cgColor
                        self.labelResetPassword.text = "Mail envoyé avec succès !"
                    } else {
                        self.labelResetPassword.text = "Adresse mail non valide"
                        self.validateResetPassword.layer.backgroundColor = UIColor.red.cgColor
                    }
                })
            }
        } else {
            labelResetPassword.text = "Adresse mail non valide"
            validateResetPassword.layer.backgroundColor = UIColor.red.cgColor
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdressResetPassword.resignFirstResponder()
    }
}
