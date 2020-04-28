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

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
        passwordValidation.resignFirstResponder()
    }

    @IBAction func didTapeValidate(_ sender: Any) {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailAdress.text!)
        if isEmailAddressValid && isEqual() && fieldIsNotEmpty([passwordValidation, password, emailAdress]) {
            UserManager.createUser(email: emailAdress.text!, password: password.text!)
            performSegue(withIdentifier: identifier, sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        securePassword([password, passwordValidation])
        buttonsetUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        textFieldSetUp([emailAdress, password, passwordValidation])
    }
}

extension SignUpViewController {

    private func textFieldSetUp(_ textField: [UITextField]) {
        for item in textField {
            item.layer.borderWidth = 3
            item.layer.borderColor = Colors.customGreen.cgColor
            item.layer.cornerRadius = 25
            item.borderStyle = .none
        }
    }

    private func securePassword(_ textField: [UITextField]) {
        for item in textField {
            item.isSecureTextEntry = true
        }
    }

    private func buttonsetUp() {
        validateButton.layer.cornerRadius = 25
        validateButton.layer.borderWidth = 3
        validateButton.layer.borderColor = UIColor.white.cgColor
        validateButton.layer.backgroundColor = Colors.customGreen.cgColor
    }
}

extension SignUpViewController {

     private func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                emailAdress.layer.borderColor = UIColor.red.cgColor
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }

    private func isEqual() -> Bool {
        guard password.text == passwordValidation.text else {
            password.layer.borderColor = UIColor.red.cgColor
            passwordValidation.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }

    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }
}
