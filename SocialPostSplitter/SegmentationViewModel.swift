//
//  SegmentationViewModel.swift
//  SocialPostSplitter
//
//  Created by Jan Armbrust on 09.03.2025.
//

import Foundation

@Observable
final class SegmentationViewModel {
    var inputText: String = """
After I had my challenge statement, I encountered the exact same problem, I wanted to solve with my app. I got overwhelmed with the task of doing research for my project. It felt as if the scale of the project is far too big and I had too little time and I just didn’t know how to solve all the problems ahead until I had a finished app. So I set out to change my surrounding and work from somewhere outside of my room at a nice place. Spoiler alert: I failed. Right after I realized that, I wrote a little story about my experience out there, I wanted to share with you. Beware it’s long and not polished, it’s just raw thoughts that came to my mind right after the situation.

“I wanted to start with my project for Swift Student Challenge. I thought it's nicer to go outside and work with fresh air and at a nice place. So I packed all my stuff and went to a costal promenade next to my home in Napoli. After I reached the place I sat down and first smoked a cigarette. I always do this to procrastinate and don't have to start what I wanted to do. In my mind I always have this romantic picture of me sitting at a nice place with my MacBook working in the sun and being productive, achieving nice things. Like many other people do it. But every time I attempt to do that, I fail. I only can do work in quiet, boring seeming places with no distractions. And I hate myself for that. Because I enjoy being out in nature. But I can't seem to work there. It was the same this afternoon at the seaside. I found a lot of excuses to not start. Too windy, too cold, too dark, too sketchy to pull out my MacBook. And maybe it will start raining eventually so it's not even worth it to start. When I am alone no matter where, I always listen to something. Be it podcasts, music or YouTube videos. I have this absurd fear of being alone with my thoughts or "wasting" time doing nothing. Most of the time, reading a book is not even enough anymore to cope this feeling. This afternoon I was pretty sad being there alone, not achieving again what I wanted to and again coping it by consuming a podcast. After some time I forced myself to put away my iPhone and just do nothing. I watched around the scenery and felt the wind on my face, saw the sun poking through thick black clouds over the see and saw it shining onto the mountains and houses at the other side of the Napoli bay. It was wild and beautiful at the same time. But my discomfort rose from minute to minute where I didn't do anything. My mind started to cycle around the fact that I'm being not productive, that I'm not achieving anything and that I needed an exciting idea for the Swift Student Challenge. Then suddenly I noticed a hole in the clouds in front of me where the sun slowly started shining through creating a beautiful sunset light on the water. I caught this moment on a photo. Later I thought about the fact that I would have probably never seen or experienced that, when I wasn't actively looking around and listening to some podcast instead. I reflected on it and realized, that this moment of discomfort made me experience something beautiful. Some reward I didn't anticipate and I didn't aim for. Something like that is always weird to me. I learned, that you have to work for anything in life and be tough and not waste time. But through this waste of time a got something I'll probably remember for the rest of my life. So apparently putting yourself into situations of discomfort sometime gives you something back, that you didn't thought of.
"""
    
    var outputSegments: [String] = []
    var maxChars: Int = 300
    var hashtags: String = "#BuildInPublic #indiedev #swift #swiftui #iOS #dev #iosdev #swiftstudentchallenge #dothesscwithme"
    
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
            let marker = " (\(segIndex)/\(totalSegments))"
            if segIndex == 1 {
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
            let marker = " (\(segIndex)/\(totalSegments))"
            let extra = segIndex == 1 ? "\n\n" + hashtags : ""
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
