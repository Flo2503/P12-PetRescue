//
//  SignUpViewController.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class SignUpViewController: NavBarSetUp {

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
        let providedEmailAddress = emailAdress.text
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        if isEmailAddressValid {
            print("fuck Yeah")
        } else {
            print("looser")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        textFieldSetUp([emailAdress, password, passwordValidation])
        securePassword([password, passwordValidation])
        buttonsetUp()
    }

    override func viewWillAppear(_ animated: Bool) {
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

    private func correctInfo() {
        guard !emailAdress.text!.isEmpty else {
            return emptyFieldAlert()
        }
        guard !password.text!.isEmpty else {
            return emptyFieldAlert()
        }
        guard !passwordValidation.text!.isEmpty else {
            return emptyFieldAlert()
        }
        guard password.text == passwordValidation.text else {
            return noMatchPasswordAlert()
        }
    }
}

extension SignUpViewController {

     func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
       }
}
