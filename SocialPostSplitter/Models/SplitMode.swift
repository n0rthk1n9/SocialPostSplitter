//
//  SplitMode.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 10.03.2025.
//

import Foundation

enum SplitMode: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case words
    case sentences
    
    var displayText: String {
        switch self {
        case .words: return "Words"
        case .sentences: return "Sentences"
        }
    }
}
