//
//  SocialPostSplitterApp.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI
import SwiftData

@main
struct SocialPostSplitterApp: App {
    @State private var viewModel = SocialPostSplitterViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            HashtagSet.self,
            Hashtag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(sharedModelContainer)
                .environment(viewModel)
        }
    }
}
