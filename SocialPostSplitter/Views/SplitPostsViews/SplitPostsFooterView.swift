//
//  SplitPostsFooterView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import SwiftUI

struct SplitPostsFooterView: View {
    @Environment(SocialPostSplitterViewModel.self) private var viewModel
    
    @Binding var isTransformed: Bool
    @State private var showConfirmation = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(role: .destructive) {
                showConfirmation = true
            } label: {
                Text("Start over")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.bordered)
            .confirmationDialog(
                "Are you sure you want to delete your post?",
                isPresented: $showConfirmation,
                titleVisibility: .visible
            ) {
                Button("Start over", role: .destructive) {
                    viewModel.inputText = ""
                    viewModel.outputSegments = []
                    viewModel.greyedSegments.removeAll()
                    isTransformed = false
                }
                Button("Cancel", role: .cancel) {}
            }

            Button {
                isTransformed = false
                viewModel.greyedSegments.removeAll()
            } label: {
                Text("Edit")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    SplitPostsFooterView(isTransformed: .constant(true))
        .environment(SocialPostSplitterViewModel())
}
