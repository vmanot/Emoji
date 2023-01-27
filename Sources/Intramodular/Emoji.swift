//
// Copyright (c) Vatsal Manot
//

import Swallow

public struct Emoji: CaseIterable, Hashable, Identifiable, RawRepresentable {
    public static let allCases: [Emoji] = {
        Array(EmojiDataReader.shared.emojis.lazy.map({ Self(rawValue: $0.emoji)! }).distinct())
    }()
    
    public let rawValue: String
    
    public var id: some Hashable {
        rawValue
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Conformances -

extension Emoji: Codable {
    public init(from decoder: Decoder) throws {
        let emoji = try Emoji(rawValue: RawValue(from: decoder)).unwrap()
        
        self = emoji
    }
    
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension Emoji: Named {
    public var name: String {
        GitHubEmojiDataReader.data[self]?.description ?? descriptor.name
    }
}

// MARK: - Auxiliary -

extension Emoji {
    public init?(descriptor: Emoji.Descriptor) {
        self.init(rawValue: descriptor.emoji)
    }
    
    public var descriptor: Emoji.Descriptor {
        Emoji.Descriptor(emoji: self)
    }
}

extension Emoji.Descriptor {
    public init!(emoji: Emoji) {
        guard let descriptor = EmojiDataReader.shared.emojiForUnicode[emoji.rawValue] else {
            return nil
        }
        
        self = descriptor
    }
}
