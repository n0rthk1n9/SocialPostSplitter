//
//  Hashtag.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import Foundation
import SwiftData

@Model
class Hashtag {
    var text: String
    var accessibleText: String
    
    @Relationship(inverse: \HashtagAssociation.hashtag)
    var associations: [HashtagAssociation] = []
    
    var hashtagSets: [HashtagSet] {
        associations.map { $0.set }
    }
    
    init(text: String, accessibleText: String, associations: [HashtagAssociation]) {
        self.text = text
        self.accessibleText = accessibleText
        self.associations = associations
    }
}
