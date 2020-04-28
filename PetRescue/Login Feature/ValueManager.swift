//
//  Tezxt.swift
//  PetRescue
//
//  Created by Flo on 28/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

class ValueManager {

    static func isValidEmailAddress(emailAddressString: String?, textField: UITextField) -> Bool {
        guard emailAddressString != nil else { return false }
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString! as NSString
            let results = regex.matches(in: emailAddressString!, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                textField.layer.borderColor = UIColor.red.cgColor
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
  }

    static func passwordsAreEquals(passwordOne: String?, passwordTwo: String?, fieldOne: UITextField, fieldTwo: UITextField) -> Bool {
        guard (passwordOne != nil) && passwordTwo != nil else { return false }
        guard passwordOne == passwordTwo else {
            fieldOne.layer.borderColor = UIColor.red.cgColor
            fieldTwo.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }

    static func isValidPassword(password: String?, field: UITextField) -> Bool {
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        guard password != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if passwordTest.evaluate(with: password) {
            return true
        } else {
            field.layer.borderColor = UIColor.red.cgColor
            return false
        }
    }

    static func securePassword(_ textField: [UITextField]) {
        for item in textField {
            item.isSecureTextEntry = true
        }
    }

    static func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }
}
