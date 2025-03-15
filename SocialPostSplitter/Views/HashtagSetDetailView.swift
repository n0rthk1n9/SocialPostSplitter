//
//  HashtagSetDetailView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import SwiftUI

struct HashtagSetDetailView: View {
    @Environment(\.modelContext) var context
    var set: HashtagSet

    var body: some View {
        List {
            ForEach(set.associations.sorted { $0.order < $1.order }, id: \.id) { association in
                Text(association.hashtag.text)
            }
            .onMove(perform: move)
        }
        .navigationTitle(set.label)
        .toolbar {
            EditButton()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var sortedAssociations = set.associations.sorted { $0.order < $1.order }
        sortedAssociations.move(fromOffsets: source, toOffset: destination)
        for (index, assoc) in sortedAssociations.enumerated() {
            assoc.order = index
        }
        try? context.save()
    }
}

#Preview {
    HashtagSetDetailView(set: HashtagSet(label: "Example", associations: []))
}
