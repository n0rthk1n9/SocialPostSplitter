//
//  MainView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Split", systemImage: "scissors") {
                SplitView()
            }
            Tab("Hashtags", systemImage: "number") {
                HashtagSetsView()
            }
        }
    }
}

#Preview {
    MainView()
        .environment(SocialPostSplitterViewModel())
}
