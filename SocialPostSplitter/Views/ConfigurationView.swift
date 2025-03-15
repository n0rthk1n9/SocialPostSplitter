//
//  ConfigurationView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI
import SwiftData

struct ConfigurationView: View {
    @Environment(SocialPostSplitterViewModel.self) private var viewModel
    @Query(sort: \HashtagSet.label, order: .forward) var availableHashtagSets: [HashtagSet]
    
    @Binding var selectedLimit: CharacterLimit
    @Binding var customLimit: String
    @FocusState.Binding var isInputFocused: Bool

    var body: some View {
        @Bindable var viewModel = viewModel
        Form {
            Section("Character Limit") {
                Picker("Character Limit", selection: $selectedLimit) {
                    ForEach(CharacterLimit.allCases) { option in
                        Text(option.displayText).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                .onChange(of: selectedLimit) { oldValue, newValue in
                    if newValue != oldValue && newValue != .custom {
                        viewModel.maxChars = newValue.defaultLimit ?? 300
                    }
                }
                if selectedLimit == .custom {
                    TextField("Enter custom limit", text: $customLimit)
                        .keyboardType(.numberPad)
                        .focused($isInputFocused)
                        .onChange(of: customLimit) { oldValue, newValue in
                            if newValue != oldValue, let customValue = Int(newValue) {
                                viewModel.maxChars = customValue
                            }
                        }
                }
            }
            Section("Hashtag Set") {
                Picker("Hashtag Set", selection: $viewModel.selectedHashtagSet) {
                    Text("None").tag(HashtagSet?.none)
                    ForEach(availableHashtagSets, id: \ .id) { set in
                        Text(set.label).tag(Optional(set))
                    }
                }
                .pickerStyle(.menu)
            }
            Section("Hashtags") {
                Toggle("Apply to all segments", isOn: $viewModel.applyHashtagsToAllSegments)
                    .disabled(viewModel.hashtagsTooLong)
                if viewModel.hashtagsTooLong {
                    Text("Hashtags are too long to fit into one segment. Please shorten them.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                Toggle("Use Accessible Hashtags", isOn: $viewModel.useAccessibleHashtags)
                if viewModel.selectedHashtagSet != nil {
                    Text(viewModel.computedHashtags)
                        .font(.body)
                } else {
                    Text("No Hashtag Set Selected")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            Section("Split Mode") {
                Picker("Split Mode", selection: $viewModel.splitMode) {
                    ForEach(SplitMode.allCases) { mode in
                        Text(mode.displayText).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
            }
            Section {
                HStack(alignment: .top) {
                    TextField("Enter your post", text: $viewModel.inputText, axis: .vertical)
                        .focused($isInputFocused)
                    Button {
                        if let pasteText = UIPasteboard.general.string {
                            viewModel.inputText = pasteText
                        }
                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                            .labelStyle(.iconOnly)
                    }
                }
            } header: {
                Text("Post (Will be split into \(viewModel.liveSegmentCount))")
                    .font(.caption)
                    .padding(4)
                    .foregroundColor(.secondary)
            }
            Section {
                Button("Generate Test Post") {
                    viewModel.inputText = SocialPostSplitterViewModel.defaultTestPost
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    ConfigurationView(
        selectedLimit: .constant(.bluesky),
        customLimit: .constant("250"),
        isInputFocused: FocusState<Bool>().projectedValue
    )
    .environment(SocialPostSplitterViewModel())
}
