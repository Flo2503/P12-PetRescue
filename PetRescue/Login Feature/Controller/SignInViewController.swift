//
//  SignInViewController.swift
//  PetRescue
//
//  Created by Flo on 29/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
    }

    @IBAction func tapOnValidate(_ sender: Any) {
        let isEmailAddressValid = ValueManager.isValidEmailAddress(emailAddressString: emailAdress.text!, textField: emailAdress)
        let fieldIsNotEmpty = ValueManager.fieldIsNotEmpty([password, emailAdress])
        let userExists = UserManager.userExists(email: emailAdress.text, label: signInLabel, button: validateButton)

        if isEmailAddressValid && fieldIsNotEmpty && userExists {
            UserManager.login(withEmail: emailAdress.text!, password: password.text!)
            print("Yes let's go !")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ValueManager.securePassword([password])
        DisplaySetUp.buttonsetUp(validateButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        DisplaySetUp.textFieldSetUp([emailAdress, password])
    }
}
