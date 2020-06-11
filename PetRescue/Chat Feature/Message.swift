//
//  Message.swift
//  PetRescue
//
//  Created by Flo on 09/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation

import UIKit
import Firebase
import FirebaseFirestore
import MessageKit

struct Message {

    var userId: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String

    var dictionary: [String: Any] {
        return [
            "id": userId,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName": senderName]
    }
}

extension Message {
    init?(dictionary: [String: Any]) {

        guard let userId = dictionary["userId"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {return nil}

        self.init(userId: userId, content: content, created: created, senderID: senderID, senderName: senderName)

    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: senderName)
    }

    var messageId: String {
        return userId
    }

    var sentDate: Date {
        return created.dateValue()
    }

    var kind: MessageKind {
        return .text(content)
    }
}
