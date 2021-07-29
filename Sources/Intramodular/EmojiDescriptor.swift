//
// Copyright (c) Vatsal Manot
//

import Swift

public struct EmojiDescriptor: Hashable {
    public var name: String = ""
    public var shortName: String
    public var unified: String
    public var skinVariations: [Emoji.SkinVariation] = []
    public var category: EmojiCategory?
    public var isObsoleted: Bool = false
    public var sortOrder: Int = 0
    
    public var emoji: String {
        return Self.getEmojiFor(unified: self.unified)
    }
    
    init(shortName: String, unified: String) {
        self.shortName = shortName
        self.unified = unified
    }
    
    init(
        name: String,
        shortName: String,
        unified: String,
        skinVariations: [Emoji.SkinVariation],
        category: EmojiCategory?,
        isObsoleted: Bool,
        sortOrder: Int
    ) {
        self.init(shortName: shortName, unified: unified)
        self.skinVariations = skinVariations
        self.name = name
        self.category = category
        self.isObsoleted = isObsoleted
        self.sortOrder = sortOrder
    }
    
    static func getEmojiFor(unified: String) -> String {
        var emoji = ""
        
        unified.components(separatedBy: "-").forEach { unified in
            if let intValue = Int(unified, radix: 16), let unicode = UnicodeScalar(intValue) {
                emoji += String(unicode)
            }
        }
        
        return emoji
    }
    
    func getEmojiWithSkinVariation(_ skinVariationType: Emoji.SkinVariationType) -> String {
        getEmojiWithSkinVariations([skinVariationType])
    }
    
    func getEmojiWithSkinVariations(_ skinVariationTypes: [Emoji.SkinVariationType]) -> String {
        if (skinVariationTypes.isEmpty) { return emoji }
        
        guard let skinVariation = self.skinVariations.first(where: { $0.skinVariationTypes == skinVariationTypes }) else { return emoji }
        
        let unifiedVariation = skinVariation.unified
        
        return Self.getEmojiFor(unified: unifiedVariation)
    }
}
