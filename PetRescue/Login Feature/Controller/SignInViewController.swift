//
//  SignInViewController.swift
//  PetRescue
//
//  Created by Flo on 29/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: NavBarSetUp {

    private let identifier = "segueToAlert"
    private let erroMessage = "Adresse mail ou mot de passe incorrect"

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
    }

    @IBAction func tapOnValidate(_ sender: Any) {
        let isEmailAddressValid = InputValuesManager.isValidEmailAddress(emailAddressString: emailAdress.text!)
        let fieldIsNotEmpty = InputValuesManager.fieldIsNotEmpty([password, emailAdress])

        if  isEmailAddressValid && fieldIsNotEmpty {
            UserManager.login(withEmail: emailAdress.text!, password: password.text!)
            performSegue(withIdentifier: identifier, sender: self)
        } else {
            validateButton.layer.backgroundColor = UIColor.red.cgColor
            signInLabel.text = erroMessage
        }
    }

    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        InputValuesManager.securePassword([password])
        ItemSetUp.buttonsetUp(validateButton)
        ItemSetUp.textFieldSetUp([emailAdress, password])
        UserManager.signOut()
    }
}
