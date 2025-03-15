//
//  NewHashtagSetView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import SwiftUI
import SwiftData

struct NewHashtagSetView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var label = ""
    @State private var selectedHashtagIDs = Set<PersistentIdentifier>()
    
    @State private var newHashtagText = ""
    @State private var newAccessibleText = ""
    
    @Query(sort: \Hashtag.text, order: .forward) var availableHashtags: [Hashtag]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hashtag Set Label")) {
                    TextField("Enter set label", text: $label)
                }
                
                Section(header: Text("Select Existing Hashtags")) {
                    ForEach(availableHashtags, id: \.id) { hashtag in
                        HStack {
                            Text(hashtag.text)
                            Spacer()
                            if selectedHashtagIDs.contains(hashtag.id) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedHashtagIDs.contains(hashtag.id) {
                                selectedHashtagIDs.remove(hashtag.id)
                            } else {
                                selectedHashtagIDs.insert(hashtag.id)
                            }
                        }
                    }
                }
                
                Section(header: Text("Add New Hashtag")) {
                    TextField("Hashtag", text: $newHashtagText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    TextField("Accessible Text", text: $newAccessibleText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.words)
                    Button("Add Hashtag") {
                        let accessibleWidthoutSpaces = newAccessibleText.isEmpty ? newHashtagText.replacingOccurrences(of: " ", with: "") : newAccessibleText
                        
                        let newHashtag = Hashtag(
                            text: newHashtagText,
                            accessibleText: accessibleWidthoutSpaces,
                            associations: []
                        )
                      
                        context.insert(newHashtag)
                        
                        selectedHashtagIDs.insert(newHashtag.id)
                        
                        newHashtagText = ""
                        newAccessibleText = ""
                    }
                }
            }
            .navigationTitle("New Hashtag Set")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Create a new HashtagSet with the selected hashtags.
                        let selectedHashtags = availableHashtags.filter { selectedHashtagIDs.contains($0.id) }
                        let newSet = HashtagSet(label: label, associations: [])
                        for (index, hashtag) in selectedHashtags.enumerated() {
                            let association = HashtagAssociation(order: index, hashtag: hashtag, set: newSet)
                            newSet.associations.append(association)
                        }
                        context.insert(newSet)
                        
                        dismiss()
                    }
                    .disabled(label.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NewHashtagSetView()
}
