//
//  CharacterLimit.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import Foundation

enum CharacterLimit: CaseIterable, Identifiable {
    case bluesky
    case mastodon
    case linkedin
    case custom

    var id: Self { self }
    
    var defaultLimit: Int? {
        switch self {
        case .bluesky: return 300
        case .mastodon: return 500
        case .linkedin: return 3000
        case .custom: return nil
        }
    }
    
    var displayText: String {
        switch self {
        case .bluesky: return "Bluesky"
        case .mastodon: return "Mastodon"
        case .linkedin: return "LinkedIn"
        case .custom: return "Custom"
        }
    }
}
