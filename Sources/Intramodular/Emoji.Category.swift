//
// Copyright (c) Vatsal Manot
//

import Swift

extension Emoji {
    public enum Category: String, CaseIterable, Identifiable {
        case symbols = "Symbols"
        case objects = "Objects"
        case animalsAndNature = "Animals & Nature"
        case people = "People & Body"
        case foodAndDrink = "Food & Drink"
        case places = "Travel & Places"
        case activities = "Activities"
        case flags = "Flags"
        case smileysAndEmotion = "Smileys & Emotion"
        
        public var id: some Hashable {
            rawValue.hashValue
        }
    }
}

extension Emoji.Category {
    public var allEmojis: [Emoji] {
        EmojiListReader.shared.emojisPerCategory[self]!
    }
}
