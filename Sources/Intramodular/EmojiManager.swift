//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

struct EmojiManager {
    static let shared = Self()
    
    var emojis: [EmojiDescriptor] = []
    var shortNameForUnified: [String:[EmojiDescriptor]] = [:]
    var emojisForCategory: [EmojiCategory: [EmojiDescriptor]] = [:]
    var emojiForUnified: [String:[EmojiDescriptor]] = [:]
    var emojiForUnicode: [String: EmojiDescriptor] = [:]
    
    var emojisPerCategory: [EmojiCategory: [Emoji]] = [:]

    init() {
        guard let emojisListFilePath = Bundle.module.path(forResource: "emoji-list", ofType: "json") else {
            print("emoji-list.json was not found")
            return
        }
        
        let emojisListData = FileManager.default.contents(atPath: emojisListFilePath)
        
        do {
            
            if let jsonArray = try JSONSerialization.jsonObject(with: emojisListData!, options: .allowFragments) as? [[String: Any]] {
                
                jsonArray.forEach { (emoji: [String:Any]) in
                    
                    let name = emoji["name"] as? String
                    let isObsoleted = emoji["obsoleted_by"] != nil
                    let sortOrder: Int = emoji["sort_order"] as? Int ?? 0
                    
                    var category: EmojiCategory? = nil
                    if let categoryName = emoji["category"] as? String {
                        category = EmojiCategory(rawValue: categoryName)
                    }
                    
                    var unifieds: [String] = []
                    
                    if let unifiedJson = emoji["unified"] as? String {
                        unifieds.append(unifiedJson)
                    }
                    
                    if let variations = emoji["variations"] as? [String] {
                        variations.forEach { unifieds.append($0) }
                    }
                    
                    unifieds.reverse()
                    
                    unifieds.forEach { unified in
                        
                        if let shortNames = emoji["short_names"] as? [String] {
                            shortNames.forEach { shortName in
                                
                                let emojiSkinVariations = emoji["skin_variations"] as? [[String]]
                                
                                var skinVariations: [Emoji.SkinVariation]
                                
                                if let emojiSkinVariations = emojiSkinVariations {
                                    skinVariations = emojiSkinVariations.compactMap {
                                        return Emoji.SkinVariation(unified: $0[1], skinVariations: Emoji.SkinVariationType.getFromUnified($0[0]))
                                    }
                                    
                                } else {
                                    skinVariations = []
                                }
                                
                                let emojiObject = EmojiDescriptor(
                                    name: name ?? "",
                                    shortName: shortName,
                                    unified: unified,
                                    skinVariations: skinVariations,
                                    category: category,
                                    isObsoleted: isObsoleted,
                                    sortOrder: sortOrder
                                )
                                
                                emojis.append(emojiObject)
                            }
                        }
                    }
                }
            }
            
            emojis
                .sorted { $0.isObsoleted && $1.isObsoleted }
                .forEach { emoji in
                    emojiForUnicode[emoji.emoji] = emoji
                    
                    var emojiListFromDictionary = shortNameForUnified[emoji.shortName] ?? []
                    emojiListFromDictionary.append(emoji)
                    shortNameForUnified[emoji.shortName] = emojiListFromDictionary
                    
                    var emojisForUnified  = emojiForUnified[emoji.unified] ?? []
                    emojisForUnified.append(emoji)
                    emojiForUnified[emoji.unified] = emojisForUnified
                    
                    emoji.skinVariations.forEach { variation in
                        var emojisVariationForUnified  = emojiForUnified[variation.unified] ?? []
                        var emojiVariation = emoji
                        emojiVariation.shortName = emoji.shortName + ":" + variation.skinVariationTypes.map { ":\($0.getAliasValue())" }.joined(separator: ":")
                        
                        emojisVariationForUnified.append(emojiVariation)
                        emojiForUnified[variation.unified] = emojisVariationForUnified
                    }
                    
                    if let category = emoji.category {
                        emojisForCategory[category, default: []].append(emoji)
                    }
                    
                }
            
            for key in emojisForCategory.keys {
                emojisForCategory[key, default: []] = Set(emojisForCategory[key, default: []]).sorted(by: { $0.sortOrder < $1.sortOrder })
                emojisPerCategory[key, default: []] = uniq(emojisForCategory[key, default: []].sorted(by: { $0.sortOrder < $1.sortOrder }).compactMap(Emoji.init))
            }
        }
        catch {
            print("Could not load emoji list \(error)")
        }
    }
    
    func getEmojisForCategory(_ category: EmojiCategory) -> [EmojiDescriptor]? {
        return emojisForCategory[category]
    }
}

private func uniq<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}

