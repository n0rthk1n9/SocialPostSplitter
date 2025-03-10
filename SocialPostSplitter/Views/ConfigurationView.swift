//
//  ConfigurationView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import SwiftUI

struct ConfigurationView: View {
    @Binding var viewModel: SocialPostSplitterViewModel
    @Binding var selectedLimit: CharacterLimit
    @Binding var customLimit: String
    @FocusState.Binding var isInputFocused: Bool

    var body: some View {
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
        viewModel: .constant(SocialPostSplitterViewModel()),
        selectedLimit: .constant(.bluesky),
        customLimit: .constant("250"),
        isInputFocused: FocusState<Bool>().projectedValue
    )
}
