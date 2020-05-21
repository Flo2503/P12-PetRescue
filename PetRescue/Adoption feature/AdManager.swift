//
//  File.swift
//  PetRescue
//
//  Created by Flo on 10/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import Firebase

struct AdManager {

    private static var ads: [AdManager]?

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

    static func uploadMedia(name: String, image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("animalsPictures").child("\(name)\(InputValuesManager.randomString(length: 10)).png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }

    static func retrieveImage(url: String, callback: @escaping (_ image: UIImage?) -> Void) {
        let reference = Storage.storage().reference(forURL: url)
        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if let error = error {
                print("Error while retreiving image from firebase, url = \(url).")
                print("Error description: \(error.localizedDescription.debugDescription)")
                callback(nil)
            } else if let data = data {
                callback(UIImage(data: data))
            } else {
                print("Error while retreiving image from firebase, url = \(url). Caused by nil data.")
                callback(nil)
            }
        }
    }

    static func retrieveData(callback: @escaping (_ newAd: [AdManager]) -> Void) {
        if let ads = AdManager.ads {
            callback(ads)
        } else {
            forceRetrieceData(callback: callback)
        }
    }

    static func getMyAds(userId: String, callback: @escaping (_ ad: [AdManager]) -> Void) {
        AdManager.retrieveData(callback: { ads in
            callback(ads.filter({ $0.userId == userId }))
        })
    }

    static func forceRetrieceData(callback: @escaping (_ newAd: [AdManager]) -> Void) {
        let ref = Database.database().reference(withPath: "ads")
        ref.observe(.value, with: { snapshot in
            var newAd: [AdManager] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let animalAd = AdManager(snapshot: snapshot) {
                    newAd.append(animalAd)
                }
            }
            AdManager.ads = newAd
            callback(newAd)
        })
    }

    static func deleteAd() {
    }
}
