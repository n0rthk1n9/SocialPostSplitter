//
//  ContentView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

enum LimitOption: String, CaseIterable, Identifiable {
    case fixed120 = "120"
    case fixed300 = "300"
    case fixed500 = "500"
    case custom = "Custom"

    var id: String { self.rawValue }
    var displayText: String { self.rawValue }
}

struct ContentView: View {
    @State private var viewModel = SegmentationViewModel()
    @State private var isTransformed = false
    @FocusState private var isInputFocused: Bool
    @State private var selectedLimit: LimitOption = .fixed300
    @State private var customLimit: String = "300"
    @State private var greyedSegments: Set<Int> = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !isTransformed {
                    TextEditor(text: $viewModel.inputText)
                        .focused($isInputFocused)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Character Limit:").font(.headline)
                        Picker("Character Limit", selection: $selectedLimit) {
                            ForEach(LimitOption.allCases) { option in
                                Text(option.displayText).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        if selectedLimit == .custom {
                            TextField("Enter custom limit", text: $customLimit)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hashtags:").font(.headline)
                        TextField("Hashtags", text: $viewModel.hashtags)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                } else {
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
                }

                if !isTransformed {
                    Button("Transform") {
                        if selectedLimit == .custom, let customValue = Int(customLimit) {
                            viewModel.maxChars = customValue
                        } else {
                            viewModel.maxChars = Int(selectedLimit.rawValue) ?? 300
                        }
                        viewModel.transform()
                        isTransformed = true
                        isInputFocused = false
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }

                if isTransformed {
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

                                    if greyedSegments.contains(index) {
                                        Color.black.opacity(0.4)
                                            .cornerRadius(8)
                                        Text("✅")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white)
                                    }
                                }
                                .onLongPressGesture {
                                    if greyedSegments.contains(index) {
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.error)
                                        greyedSegments.remove(index)
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Social Post Splitter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { isInputFocused = false }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
