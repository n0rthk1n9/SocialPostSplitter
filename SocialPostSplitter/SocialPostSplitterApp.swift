//
//  SocialPostSplitterApp.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

@main
struct SocialPostSplitterApp: App {
    @State private var viewModel = SocialPostSplitterViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(viewModel)
        }
    }
}
