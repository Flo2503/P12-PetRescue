//
//  AdManager.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable function_parameter_count

import Foundation
import FirebaseDatabase
import FirebaseStorage

class AdManager {

    static func createAd(name: String, kind: String, gender: String, age: String, locality: String, details: String) {
        let ref = Database.database().reference()
        ref.child("ads").childByAutoId().child("animal").setValue(["name": name, "breed": kind, "gender": gender, "age": age, "locality": locality, "details": details])
    }
}
