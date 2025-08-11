//
//  ChildConfigurationTests.swift
//  Tests iOS
//
//  Created by AI Assistant
//

import XCTest
@testable import KidsVideo

class ChildConfigurationTests: XCTestCase {

    override func setUpWithError() throws {
        // Reset configuration for each test
        ChildConfigurationManager.setTarget(.jinan)
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    func testJinanConfiguration() throws {
        // Set target to jinan (younger child)
        ChildConfigurationManager.setTarget(.jinan)
        
        // Load configuration
        let configuration = ChildConfigurationManager.loadConfiguration()
        
        // Verify configuration loaded successfully
        XCTAssertNotNil(configuration, "Jinan configuration should load successfully")
        
        if let config = configuration {
            // Verify it contains dinosaur videos (specific to jinan)
            let hasDinosaur = config.menuImages.contains { $0.channel == "dinasaur" }
            XCTAssertTrue(hasDinosaur, "Jinan configuration should include dinosaur content")
            
            // Verify it doesn't contain numberblocks (specific to chonan)
            let hasNumberblocks = config.menuImages.contains { $0.channel == "numberblocks" }
            XCTAssertFalse(hasNumberblocks, "Jinan configuration should not include numberblocks")
            
            // Verify background image
            XCTAssertEqual(config.backgroundImage, "menu_background_image_chinan",
                          "Jinan should use chinan background")
        }
    }

    func testChonanConfiguration() throws {
        // Set target to chonan (older child)
        ChildConfigurationManager.setTarget(.chonan)
        
        // Load configuration
        let configuration = ChildConfigurationManager.loadConfiguration()
        
        // Verify configuration loaded successfully
        XCTAssertNotNil(configuration, "Chonan configuration should load successfully")
        
        if let config = configuration {
            // Verify it contains numberblocks (specific to chonan)
            let hasNumberblocks = config.menuImages.contains { $0.channel == "numberblocks" }
            XCTAssertTrue(hasNumberblocks, "Chonan configuration should include numberblocks")
            
            // Verify it doesn't contain dinosaur (specific to jinan)
            let hasDinosaur = config.menuImages.contains { $0.channel == "dinasaur" }
            XCTAssertFalse(hasDinosaur, "Chonan configuration should not include dinosaur content")
            
            // Verify background image
            XCTAssertEqual(config.backgroundImage, "menu_background_image_jinan",
                          "Chonan should use jinan background")
        }
    }

    func testCommonContent() throws {
        // Test that both configurations include common content
        let commonChannels = ["shinkalion", "minecraft", "jobraver"]
        
        for target in ChildTarget.allCases {
            ChildConfigurationManager.setTarget(target)
            let configuration = ChildConfigurationManager.loadConfiguration()
            
            XCTAssertNotNil(configuration, "\(target.rawValue) configuration should load")
            
            if let config = configuration {
                for commonChannel in commonChannels {
                    let hasCommonChannel = config.menuImages.contains { $0.channel == commonChannel }
                    XCTAssertTrue(hasCommonChannel,
                                 "\(target.rawValue) should include common channel: \(commonChannel)")
                }
            }
        }
    }

    func testContentsMakerIntegration() throws {
        // Test content loading with different configurations
        ChildConfigurationManager.setTarget(.jinan)
        let jinanContents: [Content] = ChildConfigurationManager.loadConfiguration()?.videos.compactMap { contentData in
            guard let channel = channelFromString(contentData.channel) else { return nil }
            return Content(fileName: contentData.fileName, fileExt: contentData.fileExt, totalTime: contentData.totalTime, channel: channel)
        } ?? []
        
        ChildConfigurationManager.setTarget(.chonan)
        let chonanContents: [Content] = ChildConfigurationManager.loadConfiguration()?.videos.compactMap { contentData in
            guard let channel = channelFromString(contentData.channel) else { return nil }
            return Content(fileName: contentData.fileName, fileExt: contentData.fileExt, totalTime: contentData.totalTime, channel: channel)
        } ?? []
        
        // Verify both return content
        XCTAssertFalse(jinanContents.isEmpty, "Jinan contents should not be empty")
        XCTAssertFalse(chonanContents.isEmpty, "Chonan contents should not be empty")
        
        // Verify jinan has dinosaur content
        let jinanHasDinosaur = jinanContents.contains { $0.channel == Channel.dinasaur }
        XCTAssertTrue(jinanHasDinosaur, "Jinan should have dinosaur content")
        
        // Verify chonan has numberblocks content
        let chonanHasNumberblocks = chonanContents.contains { $0.channel == Channel.numberblocks }
        XCTAssertTrue(chonanHasNumberblocks, "Chonan should have numberblocks content")
    }

    func testMenuImageMakerIntegration() throws {
        // Test MenuImageMaker with different configurations
        ChildConfigurationManager.setTarget(.jinan)
        let jinanImages = MenuImageMaker.getImages()
        
        ChildConfigurationManager.setTarget(.chonan)
        let chonanImages = MenuImageMaker.getImages()
        
        // Verify both return images
        XCTAssertFalse(jinanImages.isEmpty, "Jinan menu images should not be empty")
        XCTAssertFalse(chonanImages.isEmpty, "Chonan menu images should not be empty")
    }
}

// Helper function to convert string to Channel enum
private func channelFromString(_ channelString: String) -> Channel? {
    switch channelString.lowercased() {
    case "shinkalion":
        return .shinkalion
    case "minecraft":
        return .minecraft
    case "jobraver":
        return .jobraver
    case "dinasaur":
        return .dinasaur
    case "numberblocks":
        return .numberblocks
    default:
        return nil
    }
}
