//
//  SplitPostsHeaderView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct SplitPostsHeaderView: View {
    let segmentCount: Int
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Text("Split posts (\(segmentCount))")
                .font(.title2)
                .bold()
            Spacer()
            Button("Edit Input", action: onEdit)
                .buttonStyle(.bordered)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SplitPostsHeaderView(segmentCount: 13, onEdit: {})
}
