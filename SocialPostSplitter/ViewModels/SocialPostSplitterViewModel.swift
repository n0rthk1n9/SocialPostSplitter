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
    var splitMode: SplitMode = .words
    var greyedSegments: Set<Int> = []
    var selectedHashtagSet: HashtagSet?
    
    var useAccessibleHashtags: Bool = false
    
    var computedHashtags: String {
        if let set = selectedHashtagSet {
            if useAccessibleHashtags {
                return set.orderedHashtags.map { "#" + $0.accessibleText }.joined(separator: " ")
            } else {
                return set.orderedHashtags.map { "#" + $0.text }.joined(separator: " ")
            }
        }
        return hashtags
    }
    
    var hashtagsTooLong: Bool {
        let hashtagString = computedHashtags
        return maxChars < (minContentRequired + 2 + hashtagString.count)
    }
    
    var minContentRequired: Int {
        if splitMode == .sentences, let firstSentence = splitTextIntoSentences(inputText).first {
            return firstSentence.count
        }
        return 15
    }
    
    var sentencesFit: Bool {
        guard splitMode == .sentences else { return true }
        let markerEstimate = 7
        let sentences = splitTextIntoSentences(inputText)
        if let first = sentences.first, first.count + (2 + computedHashtags.count) + markerEstimate > maxChars {
            return false
        }
        let reservedOther = applyHashtagsToAllSegments ? (2 + computedHashtags.count) : 0
        for sentence in sentences.dropFirst() {
            if sentence.count + reservedOther + markerEstimate > maxChars {
                return false
            }
        }
        return true
    }
    
    var canSplit: Bool {
        return !hashtagsTooLong && sentencesFit
    }
    
    func transform() {
        guard canSplit else {
            outputSegments = []
            return
        }
        let components = splitComponents(from: inputText, mode: splitMode)
        let segments = computeStableSegments(for: components)
        let hashtagString = computedHashtags
        let formatted = segments.enumerated().map { (index, segment) -> String in
            let marker = segments.count > 1 ? " (\(index + 1)/\(segments.count))" : ""
            if applyHashtagsToAllSegments {
                return segment + marker + "\n\n" + hashtagString
            } else {
                return index == 0 ? segment + marker + "\n\n" + hashtagString : segment + marker
            }
        }
        if formatted.contains(where: { $0.count > maxChars }) {
            outputSegments = []
        } else {
            outputSegments = formatted
        }
    }
    
    func splitComponents(from text: String, mode: SplitMode) -> [String] {
        switch mode {
        case .words:
            return text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        case .sentences:
            return splitTextIntoSentences(text)
        }
    }
    
    func computeStableSegments(for components: [String]) -> [String] {
        var totalSegments = 10
        var segments: [String] = []
        while true {
            segments = buildSegments(for: components, totalSegments: totalSegments)
            if segments.count == totalSegments { break }
            totalSegments = segments.count
        }
        return segments
    }
    
    func buildSegments(for components: [String], totalSegments: Int) -> [String] {
        var segments: [String] = []
        var currentSegment = ""
        var segIndex = 1
        
        for component in components {
            let marker = totalSegments > 1 ? " (\(segIndex)/\(totalSegments))" : ""
            let reserved: Int = {
                if applyHashtagsToAllSegments {
                    return 2 + computedHashtags.count
                } else {
                    return segIndex == 1 ? (2 + computedHashtags.count) : 0
                }
            }()
            let capacity = maxChars - marker.count - reserved
            let candidate = currentSegment.isEmpty ? component : currentSegment + " " + component
            if candidate.count <= capacity {
                currentSegment = candidate
            } else {
                segments.append(currentSegment)
                segIndex += 1
                currentSegment = component
            }
        }
        segments.append(currentSegment)
        return segments
    }
    
    func splitTextIntoSentences(_ text: String) -> [String] {
        var sentences: [String] = []
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .bySentences) { substring, _, _, _ in
            if let sentence = substring?.trimmingCharacters(in: .whitespacesAndNewlines), !sentence.isEmpty {
                sentences.append(sentence)
            }
        }
        return sentences
    }
    
    var liveSegmentCount: Int {
        let components = splitComponents(from: inputText, mode: splitMode)
        return computeStableSegments(for: components).count
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
