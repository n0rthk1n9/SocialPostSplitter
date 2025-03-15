//
//  HashtagAssociation.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import Foundation
import SwiftData

@Model
class HashtagAssociation {
    var order: Int

    var hashtag: Hashtag

    var set: HashtagSet

    init(order: Int = 0, hashtag: Hashtag, set: HashtagSet) {
        self.order = order
        self.hashtag = hashtag
        self.set = set
    }
}
