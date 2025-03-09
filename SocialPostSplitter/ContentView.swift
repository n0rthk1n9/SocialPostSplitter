//
//  ContentView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = SegmentationViewModel()
    @State private var isTransformed = false
    @FocusState private var isInputFocused: Bool
    @State private var selectedLimit: CharacterLimit = .bluesky
    @State private var customLimit: String = "300"
    @State private var greyedSegments: Set<Int> = []

    var body: some View {
        NavigationStack {
            Group {
                if !isTransformed {
                    VStack {
                        Form {
                            Section("Character Limit") {
                                Picker("Character Limit", selection: $selectedLimit) {
                                    ForEach(CharacterLimit.allCases) { option in
                                        Text(option.displayText).tag(option)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.vertical)
                                if selectedLimit == .custom {
                                    TextField("Enter custom limit", text: $customLimit)
                                        .keyboardType(.numberPad)
                                        .focused($isInputFocused)
                                }
                            }

                            Section("Hashtags") {
                                TextField("Hashtags", text: $viewModel.hashtags, axis: .vertical)
                                    .focused($isInputFocused)
                            }
                            Section("Post") {
                                TextField("Enter your post", text: $viewModel.inputText, axis: .vertical)
                                    .focused($isInputFocused)
                            }
                        }
                        Button {
                            if selectedLimit == .custom, let customValue = Int(customLimit) {
                                viewModel.maxChars = customValue
                            } else {
                                viewModel.maxChars = selectedLimit.defaultLimit ?? 300
                            }
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
                        .tint(.indigo)
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Splitted posts (\(viewModel.outputSegments.count))")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button("Edit Input") {
                                isTransformed = false
                            }
                            .buttonStyle(.bordered)
                        }
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(Array(viewModel.outputSegments.enumerated()), id: \.offset) { index, segment in
                                    ZStack {
                                        VStack(alignment: .leading) {
                                            Text(segment)
                                                .font(.system(.footnote, design: .monospaced))
                                                .padding()
                                                .background(.ultraThinMaterial)
                                                .cornerRadius(8)
                                            HStack {
                                                Spacer()
                                                Button {
                                                    let generator = UINotificationFeedbackGenerator()
                                                    generator.notificationOccurred(.success)
                                                    UIPasteboard.general.string = segment
                                                    greyedSegments.insert(index)
                                                } label: {
                                                    Label("Copy", systemImage: "doc.on.doc")
                                                }
                                                .buttonStyle(.bordered)
                                            }
                                        }
                                        .onLongPressGesture {
                                            if greyedSegments.contains(index) {
                                                let generator = UINotificationFeedbackGenerator()
                                                generator.notificationOccurred(.error)
                                                greyedSegments.remove(index)
                                            }
                                        }
                                        if greyedSegments.contains(index) {
                                            Color.black.opacity(0.4)
                                                .cornerRadius(8)
                                            Text("✅")
                                                .font(.system(size: 60))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Social Post Splitter")
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
