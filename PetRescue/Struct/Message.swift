//
//  Message.swift
//  PetRescue
//
//  Created by Flo on 09/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

import UIKit
import FirebaseFirestore
import MessageKit

struct Message {

    // MARK: - Message Object
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String

    var dictionary: [String: Any] {
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName": senderName]
    }
}

// MARK: - Extension
// Iinit
extension Message {
    init?(dictionary: [String: Any]) {

        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {
                print("Error in message array")
                return nil
            }

        self.init(id: id, content: content, created: created, senderID: senderID, senderName: senderName)

    }
}

// Message Protocol
extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: senderName)
    }

    var messageId: String {
        return id
    }

    var sentDate: Date {
        return created.dateValue()
    }

    var kind: MessageKind {
        return .text(content)
    }
}
