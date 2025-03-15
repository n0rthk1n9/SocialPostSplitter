//
//  HashtagSetsView.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 15.03.2025.
//

import SwiftData
import SwiftUI

struct HashtagSetsView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \HashtagSet.label, order: .forward) var hashtagSets: [HashtagSet]
        
    @State private var showNewHashtagSetSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(hashtagSets, id: \.self) { set in
                    NavigationLink(value: set) {
                        VStack(alignment: .leading) {
                            Text(set.label)
                                .font(.headline)
                            if !set.associations.isEmpty {
                                Text(set.associations.sorted { $0.order < $1.order }
                                        .map { $0.hashtag.text }
                                        .joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSets)
            }
            .navigationTitle("Hashtag Sets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewHashtagSetSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewHashtagSetSheet) {
                NewHashtagSetView()
            }
            .navigationDestination(for: HashtagSet.self) { set in
                HashtagSetDetailView(set: set)
            }
        }
    }

    func deleteSets(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let setToDelete = hashtagSets[index]
                context.delete(setToDelete)
            }
        }
    }
}

#Preview {
    HashtagSetsView()
}
