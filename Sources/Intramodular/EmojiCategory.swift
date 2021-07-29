//
// Copyright (c) Vatsal Manot
//

import Swift

public enum EmojiCategory: String, CaseIterable, Identifiable {
    case SYMBOLS = "Symbols"
    case OBJECTS = "Objects"
    case NATURE = "Animals & Nature"
    case PEOPLE = "People & Body"
    case FOODS = "Food & Drink"
    case PLACES = "Travel & Places"
    case ACTIVITY = "Activities"
    case FLAGS = "Flags"
    case SMILEYS = "Smileys & Emotion"
    
    public var id: some Hashable {
        rawValue.hashValue
    }
}

extension EmojiCategory {
    public var allEmojis: [Emoji] {
        EmojiManager.shared.emojisPerCategory[self]!
    }
}
