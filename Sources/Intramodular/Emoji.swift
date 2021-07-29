//
// Copyright (c) Vatsal Manot
//

import Swift

public struct Emoji: CaseIterable, Hashable, Identifiable, RawRepresentable {
    public static var allCases: [Emoji] {
        EmojiManager.shared.emojis.map({ Self(rawValue: $0.emoji)! })
    }
    
    public let rawValue: String
    
    public var name: String {
        EmojiDescriptor(emoji: self).name
    }
    
    public var id: some Hashable {
        rawValue
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Auxiliary Implementation -

extension Emoji {
    public init?(descriptor: EmojiDescriptor) {
        self.init(rawValue: descriptor.emoji)
    }
}

extension EmojiDescriptor {
    public init!(emoji: Emoji) {
        guard let descriptor = EmojiManager.shared.emojiForUnicode[emoji.rawValue] else {
            return nil
        }
        
        self = descriptor
    }
}
