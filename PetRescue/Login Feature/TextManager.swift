//
//  Tezxt.swift
//  PetRescue
//
//  Created by Flo on 28/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

class TextManager {
    static func isValidEmailAddress(emailAddressString: String, label: UILabel, textField: UITextField) -> Bool {
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          if results.count == 0 {
              label.text = "Adresse mail non valide"
              textField.layer.borderColor = UIColor.red.cgColor
              returnValue = false
          }
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      return  returnValue
  }

    static func passwordsAreEquals(_ passwordOne: String, _ passwordTwo: String, _ label: UILabel, _ fieldOne: UITextField, _ fieldTwo: UITextField) -> Bool {
        guard passwordOne == passwordTwo else {
            fieldOne.layer.borderColor = UIColor.red.cgColor
            fieldTwo.layer.borderColor = UIColor.red.cgColor
            label.text = "Mots de passe différents"
            return false
        }
        return true
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
