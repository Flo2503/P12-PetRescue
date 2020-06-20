//
//  File.swift
//  PetRescue
//
//  Created by Flo on 10/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import Firebase

class AdManager {

    // MARK: - Properties, instances
    private var ads: [Ad]?
    private let dataBase = Database.database()
    private let storage = Storage.storage()
    private let ref = Database.database().reference(withPath: "ads")

    // MARK: - Methods
    ///Create Ad on Firebase
    func createAd(animal: Ad) {
        let animalRef = self.ref.childByAutoId()
        animalRef.setValue(animal.toAnyObject())
    }

    ///Upload picture on Firebase Storage animalsPictures/"animalName.randomString". Completion returns picture url path
    func uploadMedia(name: String, image: UIImage, completion: @escaping (_ url: String?) -> Void) {
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
    func retrieveImage(url: String, callback: @escaping (_ image: UIImage?) -> Void) {
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
    func retrieveData(callback: @escaping (_ newAd: [Ad]) -> Void) {
        if let ads = self.ads {
            callback(ads)
        } else {
            forceRetrieveData(callback: callback)
        }
    }

    ///Allow to get user ads by filtering users thanks to userId. Callback returns an array of AdManager
    func getMyAds(userId: String, callback: @escaping (_ ad: [Ad]) -> Void) {
        self.retrieveData(callback: { ads in
            callback(ads.filter({ $0.userId == userId }))
        })
    }

    ///Allow to retrieve ads observing path "ads". Callback returns an array of AdManager
    func forceRetrieveData(callback: @escaping (_ newAd: [Ad]) -> Void) {
        ref.observe(.value, with: { snapshot in
            var newAd: [Ad] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let animalAd = Ad(snapshot: snapshot) {
                    newAd.append(animalAd)
                }
            }
            self.ads = newAd
            callback(newAd)
        })
    }

    ///Allow to remove ad with path ads/childId
    func removeAd(withId: String) {
        let reference = dataBase.reference().child("ads").child(withId)
        reference.removeValue()
    }

    ///Allow to remove picture thanks to picture's url
    func removePicture(url: String) {
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
