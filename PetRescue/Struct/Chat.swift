//
//  Chat.swift
//  PetRescue
//
//  Created by Flo on 09/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
    // MARK: - Chat Object
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

// MARK: - Extension Init
extension Chat {
    init?(dictionary: [String: Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else { return nil }
        self.init(users: chatUsers)
    }
}
