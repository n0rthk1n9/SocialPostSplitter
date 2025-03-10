//
//  SocialPostSplitterViewModel.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import Foundation

@Observable
final class SocialPostSplitterViewModel {
    var inputText: String = ""

    var outputSegments: [String] = []
    var maxChars: Int = 300
    var hashtags: String = "#BuildInPublic #indiedev #swift #swiftui #iOS #dev #iosdev"
    var applyHashtagsToAllSegments: Bool = false

    func transform() {
        let words = inputText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        var segmentsUnpadded: [String] = []
        var totalSegments = 10
        while true {
            segmentsUnpadded = buildSegments(words: words, totalSegments: totalSegments)
            if segmentsUnpadded.count == totalSegments { break }
            totalSegments = segmentsUnpadded.count
        }

        let finalSegments = segmentsUnpadded.enumerated().map { (index, segment) -> String in
            let segIndex = index + 1
            // Omit the marker if there's only one segment.
            let marker = totalSegments > 1 ? " (\(segIndex)/\(totalSegments))" : ""
            if self.applyHashtagsToAllSegments || segIndex == 1 {
                return segment + marker + "\n\n" + hashtags
            } else {
                return segment + marker
            }
        }
        outputSegments = finalSegments
    }

    private func buildSegments(words: [String], totalSegments: Int) -> [String] {
        var segments: [String] = []
        var currentSegment = ""
        var segIndex = 1

        for word in words {
            let marker = totalSegments > 1 ? " (\(segIndex)/\(totalSegments))" : ""
            let extra = (segIndex == 1 || self.applyHashtagsToAllSegments) ? "\n\n" + hashtags : ""
            let capacity = maxChars - marker.count - extra.count
            let candidate = currentSegment.isEmpty ? word : currentSegment + " " + word

            if candidate.count <= capacity {
                currentSegment = candidate
            } else {
                segments.append(currentSegment)
                segIndex += 1
                currentSegment = word
            }
        }
        segments.append(currentSegment)
        return segments
    }
}

extension SocialPostSplitterViewModel {
    static let defaultTestPost: String = """
        SwiftUI is an amazing framework for building user interfaces across all Apple platforms. Its declarative syntax simplifies UI design and lets developers create responsive, dynamic interfaces in a fraction of the time. With SwiftUI, you can build robust applications with minimal code, making the development process both enjoyable and efficient.

        The live preview feature provides instant feedback, allowing you to see your changes as you code. This real-time visualization fosters creativity and speeds up the iteration process. SwiftUI integrates seamlessly with other Apple frameworks, ensuring that your app looks great on every device—whether it's an iPhone, iPad, or Mac.

        SwiftUI leverages modern Swift language features like property wrappers and generics, resulting in cleaner, more maintainable code. The built-in animations and transitions are simple to implement yet powerful enough to bring your user interfaces to life. Its data binding capabilities automatically manage state changes, reducing the need for boilerplate code.

        Moreover, the strong and supportive community around SwiftUI makes learning and troubleshooting a breeze. Whether you're a beginner or an experienced developer, you'll find plenty of resources, sample projects, and collaborative opportunities that inspire innovation.

        In essence, SwiftUI represents a paradigm shift in app development. It encourages creative problem-solving, promotes best practices, and makes it easier than ever to deliver delightful user experiences. Embracing SwiftUI means stepping into a future where building stunning apps is both fun and efficient.
        """
}
