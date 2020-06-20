//
//  User.swift
//  PetRescue
//
//  Created by Flo on 20/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import Firebase

struct User {

    // MARK: - User Objetc
    let name: String
    let firstName: String
    let emailAddress: String

    // MARK: - Init
    init(name: String, firstName: String, emailAdress: String) {
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAdress
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let firstName = value["firstName"] as? String,
            let emailAddress = value["emailAddress"] as? String else {
                return  nil
        }
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAddress
    }
}
