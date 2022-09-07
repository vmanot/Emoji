//
// Copyright (c) Vatsal Manot
//

@testable import Emoji

import XCTest

final class EmojiTests: XCTestCase {
    func testReadingGitHubEmojiList() {
        _ = Emoji.allCases
        _ = GitHubEmojiDataReader.data
    }
}
