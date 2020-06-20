//
//  Ad.swift
//  PetRescue
//
//  Created by Flo on 20/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable type_name

import Foundation
import Firebase

struct Ad {

    // MARK: - Ad object
    let ref: DatabaseReference?
    let key: String
    let age: String
    let animalImage: String
    let details: String
    let gender: String
    let kind: String
    let locality: String
    let name: String
    let userId: String

    // MARK: - Init
    init(age: String,
         animalImage: String,
         details: String,
         gender: String,
         kind: String,
         locality: String,
         name: String,
         userId: String,
         key: String = "") {
        self.age = age
        self.animalImage = animalImage
        self.details = details
        self.gender = gender
        self.kind = kind
        self.locality = locality
        self.name = name
        self.userId = userId
        self.ref = nil
        self.key = key
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let age = value["age"] as? String,
            let animalImage = value["animalImage"] as? String,
            let details = value["details"] as? String,
            let gender = value["gender"] as? String,
            let kind = value["kind"] as? String,
            let locality = value["locality"] as? String,
            let userId = value["userId"] as? String,
            let name = value["name"] as? String else {
                return  nil
        }

        self.age = age
        self.animalImage = animalImage
        self.details = details
        self.gender = gender
        self.kind = kind
        self.locality = locality
        self.name = name
        self.userId = userId
        self.ref = snapshot.ref
        self.key = snapshot.key
    }

    ///Ad object
    func toAnyObject() -> Any {
        return [
            "age": age,
            "animalImage": animalImage,
            "details": details,
            "gender": gender,
            "kind": kind,
            "locality": locality,
            "name": name,
            "userId": userId
        ]
    }
}
