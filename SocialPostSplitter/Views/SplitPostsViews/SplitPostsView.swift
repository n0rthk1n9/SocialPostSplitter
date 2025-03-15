//
//  SplitPostsView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct SplitPostsView: View {
    @Environment(SocialPostSplitterViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(viewModel.outputSegments.enumerated()), id: \.offset) { index, post in
                    SplitPostView(
                        post: post,
                        index: index
                    )
                }
            }
        }
    }
}

#Preview {
    SplitPostsView()
        .environment(SocialPostSplitterViewModel())
}
