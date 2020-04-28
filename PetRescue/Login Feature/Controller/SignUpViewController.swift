//
//  SignUpViewController.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.

import UIKit

class SignUpViewController: NavBarSetUp {

    private let identifier = "segueToSignUpDetails"

    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordValidation: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var labelSignUp: UILabel!

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
        passwordValidation.resignFirstResponder()
    }

    @IBAction func didTapeValidate(_ sender: Any) {
        let isEmailAddressValid = TextManager.isValidEmailAddress(emailAddressString: emailAdress.text!,
                                                                  label: labelSignUp,
                                                                  textField: emailAdress)
        if isEmailAddressValid && TextManager.passwordsAreEquals(password.text!, passwordValidation.text!, labelSignUp, password, passwordValidation) && TextManager.fieldIsNotEmpty([passwordValidation, password, emailAdress]) {
            UserManager.createUser(email: emailAdress.text!, password: password.text!)
            performSegue(withIdentifier: identifier, sender: self)
        }
    }

    @IBAction func unwindToSignUp(segue: UIStoryboardSegue) { }

    @IBAction func resetPassword(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TextManager.securePassword([password, passwordValidation])
        DisplaySetUp.buttonsetUp(validateButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        DisplaySetUp.textFieldSetUp([emailAdress, password, passwordValidation])
    }
}
