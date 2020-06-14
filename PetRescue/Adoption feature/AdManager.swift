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
    // MARK: - Properties, instances
    private static var ads: [AdManager]?
    private static let dataBase = Database.database()
    private static let storage = Storage.storage()
    private static let ref = Database.database().reference(withPath: "ads")
    // MARK: - AdManager object
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
    ///Create Ad on Firebase
    static func createAd(animal: AdManager) {
        let animalRef = self.ref.childByAutoId()
        animalRef.setValue(animal.toAnyObject())
    }
    ///Upload picture on Firebase Storage animalsPictures/"animalName.randomString". Completion returns picture url path
    static func uploadMedia(name: String, image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = storage.reference().child("animalsPictures").child("\(name)\(InputValuesManager.randomString(length: 10)).png")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print("Error description: \(error.localizedDescription.debugDescription)")
                        } else {
                           completion(url?.absoluteString)
                        }
                    })
                }
            }
        }
    }
    ///Allow to retrieve image thanks to url. Callback returns UIimage
    static func retrieveImage(url: String, callback: @escaping (_ image: UIImage?) -> Void) {
        let reference = storage.reference(forURL: url)
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
    ///Check if ads are up to date else if call "forceRetrieveData". Callback returns array of AdManager
    static func retrieveData(callback: @escaping (_ newAd: [AdManager]) -> Void) {
        if let ads = AdManager.ads {
            callback(ads)
        } else {
            forceRetrieveData(callback: callback)
        }
    }
    ///Allow to get user ads by filtering users thanks to userId. Callback returns an array of AdManager
    static func getMyAds(userId: String, callback: @escaping (_ ad: [AdManager]) -> Void) {
        AdManager.retrieveData(callback: { ads in
            callback(ads.filter({ $0.userId == userId }))
        })
    }
    ///Allow to retrieve ads observing path "ads". Callback returns an array of AdManager
    static func forceRetrieveData(callback: @escaping (_ newAd: [AdManager]) -> Void) {
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
    ///Allow to remove ad with path ads/childId
    static func removeAd(withId: String) {
        let reference = dataBase.reference().child("ads").child(withId)
        reference.removeValue()
    }
    ///Allow to remove picture thanks to picture's url
    static func removePicture(url: String) {
        let reference = storage.reference(forURL: url)
        reference.delete(completion: { error in
            if let error = error {
                print("Error while deleting image from firebase, url = \(url).")
                print("Error description: \(error.localizedDescription.debugDescription)")
            } else {
                print("Picture successfully removed")
            }
        })
    }
}
