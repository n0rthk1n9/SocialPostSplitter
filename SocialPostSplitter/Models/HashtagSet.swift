//
//  HashtagSet.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import Foundation
import SwiftData

@Model
class HashtagSet {
    var label: String
    
    @Relationship(inverse: \HashtagAssociation.set)
    var associations: [HashtagAssociation] = []
    
    var orderedHashtags: [Hashtag] {
        associations.sorted { $0.order < $1.order }.map { $0.hashtag }
    }
    
    init(label: String, associations: [HashtagAssociation]) {
        self.label = label
        self.associations = associations
    }
}
