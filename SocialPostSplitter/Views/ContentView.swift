//
//  ContentView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = SocialPostSplitterViewModel()
    @State private var isTransformed = false
    @FocusState private var isInputFocused: Bool
    @State private var selectedLimit: CharacterLimit = .bluesky
    @State private var customLimit: String = "300"
    @State private var greyedSegments: Set<Int> = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !isTransformed {
                    ConfigurationView(
                        viewModel: $viewModel,
                        selectedLimit: $selectedLimit,
                        customLimit: $customLimit,
                        isInputFocused: $isInputFocused
                    )
                } else {
                    SplittedPostsHeaderView(segmentCount: viewModel.outputSegments.count) {
                        isTransformed = false
                        greyedSegments.removeAll()
                    }
                }

                if isTransformed {
                    SplittedPostsView(
                        posts: viewModel.outputSegments,
                        greyedSegments: $greyedSegments
                    )
                }

                if !viewModel.canSplit {
                    Text("Too many hashtags to fit into a single segment. Please shorten your hashtags.")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button {
                    if !isTransformed {
                        viewModel.transform()
                        isTransformed = true
                        isInputFocused = false
                    } else {
                        viewModel.inputText = ""
                        viewModel.outputSegments = []
                        greyedSegments.removeAll()
                        isTransformed = false
                    }
                } label: {
                    Text(isTransformed ? "Start over" : "Split")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
                .disabled(!viewModel.canSplit)
                .tint(isTransformed ? .red : .indigo)
                .buttonStyle(.borderedProminent)
                .padding()
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
    ContentView()
}
