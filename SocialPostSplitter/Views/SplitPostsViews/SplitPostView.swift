//
//  SplitPostView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct SplitPostView: View {
    @Environment(SocialPostSplitterViewModel.self) private var viewModel
    
    let post: String
    let index: Int
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(post)
                    .font(.system(.footnote, design: .monospaced))
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 50, trailing: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            if index == 0 {
                                ShareLink(item: post) {
                                    Label("Share post", systemImage: "square.and.arrow.up")
                                        .labelStyle(.iconOnly)
                                }
                                .simultaneousGesture(
                                    TapGesture().onEnded({ _ in
                                        viewModel.greyedSegments.insert(index)
                                    })
                                )
                            }
                            Button {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                UIPasteboard.general.string = post
                                viewModel.greyedSegments.insert(index)
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                            .padding(8)
                        },
                        alignment: .bottomTrailing
                    )
            }
            if viewModel.greyedSegments.contains(index) {
                Color.black.opacity(0.4)
                    .cornerRadius(8)
                Text("✅")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
        }
        .onLongPressGesture {
            if viewModel.greyedSegments.contains(index) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                viewModel.greyedSegments.remove(index)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SplitPostView(post: "This is a nice post", index: 0)
}
