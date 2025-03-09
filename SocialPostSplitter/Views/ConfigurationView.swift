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
                TextField("Enter your post", text: $viewModel.inputText, axis: .vertical)
                    .focused($isInputFocused)
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
