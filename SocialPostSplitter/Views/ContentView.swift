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
    @State private var showConfirmation = false

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
                    Text("Split posts (\(viewModel.outputSegments.count))")
                        .font(.title2)
                        .bold()
                }

                if isTransformed {
                    SplitPostsView(
                        posts: viewModel.outputSegments,
                        greyedSegments: $greyedSegments
                    )
                }

                if !viewModel.canSplit {
                    Text("Too many hashtags to fit into a single segment. Please shorten your hashtags.")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                HStack(spacing: 16) {
                    if isTransformed {
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
                                greyedSegments.removeAll()
                                isTransformed = false
                            }
                            Button("Cancel", role: .cancel) {}
                        }

                        Button {
                            isTransformed = false
                            greyedSegments.removeAll()
                        } label: {
                            Text("Edit")
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
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
                    }
                }
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
