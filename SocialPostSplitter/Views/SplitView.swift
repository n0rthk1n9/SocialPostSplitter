//
//  ContentView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct SplitView: View {
    @Environment(SocialPostSplitterViewModel.self) private var viewModel
    
    @State private var isTransformed = false
    @FocusState private var isInputFocused: Bool
    @State private var selectedLimit: CharacterLimit = .bluesky
    @State private var customLimit: String = "300"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !isTransformed {
                    ConfigurationView(
                        selectedLimit: $selectedLimit,
                        customLimit: $customLimit,
                        isInputFocused: $isInputFocused
                    )
                    if !viewModel.canSplit {
                        Text("Too many hashtags to fit into a single segment. Please shorten your hashtags.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button {
                        viewModel.transform()
                        isTransformed = true
                        isInputFocused = false
                    } label: {
                        Text("Split")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .disabled(!viewModel.canSplit)
                    .padding()
                } else {
                    Text("Split posts (\(viewModel.outputSegments.count))")
                        .font(.title2)
                        .bold()
                    SplitPostsView()
                    SplitPostsFooterView(isTransformed: $isTransformed)
                }
            }
            .navigationTitle("Post Split")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { isInputFocused = false }
                }
            }
        }
    }
}

#Preview {
    SplitView()
        .environment(SocialPostSplitterViewModel())
}
