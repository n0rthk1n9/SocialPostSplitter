//
//  SplittedPostsView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct SplittedPostsView: View {
    let posts: [String]
    @Binding var greyedSegments: Set<Int>

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(posts.enumerated()), id: \.offset) { index, post in
                    SplittedPostView(
                        post: post,
                        index: index,
                        greyedSegments: $greyedSegments
                    )
                }
            }
        }
    }
}

#Preview {
    SplittedPostsView(
        posts: ["This is a nice post", "This is an even nicer post"],
        greyedSegments: .constant(Set([1]))
    )
}
