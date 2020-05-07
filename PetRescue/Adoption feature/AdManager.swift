//
//  AdManager.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable function_parameter_count

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

class AdManager {

    static func createAd(name: String, kind: String, gender: String, age: String, locality: String, animalImage: String, details: String) {
        let ref = Database.database().reference()
        ref.child("ads").childByAutoId().child("animal").setValue(["name": name, "kind": kind, "gender": gender, "age": age, "locality": locality, "animalImage": animalImage, "details": details])
    }

    static func uploadMedia(image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("animalsPictures").child("\(InputValuesManager.randomString(length: 20)).png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
}
