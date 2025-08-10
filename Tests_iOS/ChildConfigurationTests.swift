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
        ChildConfigurationManager.setTarget(.nichan)
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    func testNichanConfiguration() throws {
        // Set target to nichan (younger child)
        ChildConfigurationManager.setTarget(.nichan)
        
        // Load configuration
        let configuration = ChildConfigurationManager.loadConfiguration()
        
        // Verify configuration loaded successfully
        XCTAssertNotNil(configuration, "Nichan configuration should load successfully")
        
        if let config = configuration {
            // Verify it contains dinosaur videos (specific to nichan)
            let hasDinosaur = config.menuImages.contains { $0.channel == "dinasaur" }
            XCTAssertTrue(hasDinosaur, "Nichan configuration should include dinosaur content")
            
            // Verify it doesn't contain numberblocks (specific to niichan)
            let hasNumberblocks = config.menuImages.contains { $0.channel == "numberblocks" }
            XCTAssertFalse(hasNumberblocks, "Nichan configuration should not include numberblocks")
            
            // Verify background image
            XCTAssertEqual(config.backgroundImage, "menu_background_image_ryuichi", 
                          "Nichan should use ryuichi background")
        }
    }

    func testNiichanConfiguration() throws {
        // Set target to niichan (older child)
        ChildConfigurationManager.setTarget(.niichan)
        
        // Load configuration
        let configuration = ChildConfigurationManager.loadConfiguration()
        
        // Verify configuration loaded successfully
        XCTAssertNotNil(configuration, "Niichan configuration should load successfully")
        
        if let config = configuration {
            // Verify it contains numberblocks (specific to niichan)
            let hasNumberblocks = config.menuImages.contains { $0.channel == "numberblocks" }
            XCTAssertTrue(hasNumberblocks, "Niichan configuration should include numberblocks")
            
            // Verify it doesn't contain dinosaur (specific to nichan)
            let hasDinosaur = config.menuImages.contains { $0.channel == "dinasaur" }
            XCTAssertFalse(hasDinosaur, "Niichan configuration should not include dinosaur content")
            
            // Verify background image
            XCTAssertEqual(config.backgroundImage, "menu_background_image_ryoma", 
                          "Niichan should use ryoma background")
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
        // Test ContentsMaker with different configurations
        ChildConfigurationManager.setTarget(.nichan)
        let nichanContents = ContentsMaker.getContents()
        
        ChildConfigurationManager.setTarget(.niichan)
        let niichanContents = ContentsMaker.getContents()
        
        // Verify both return content
        XCTAssertFalse(nichanContents.isEmpty, "Nichan contents should not be empty")
        XCTAssertFalse(niichanContents.isEmpty, "Niichan contents should not be empty")
        
        // Verify nichan has dinosaur content
        let nichanHasDinosaur = nichanContents.contains { $0.channel == .dinasaur }
        XCTAssertTrue(nichanHasDinosaur, "Nichan should have dinosaur content")
        
        // Verify niichan has numberblocks content  
        let niichanHasNumberblocks = niichanContents.contains { $0.channel == .numberblocks }
        XCTAssertTrue(niichanHasNumberblocks, "Niichan should have numberblocks content")
    }

    func testMenuImageMakerIntegration() throws {
        // Test MenuImageMaker with different configurations
        ChildConfigurationManager.setTarget(.nichan)
        let nichanImages = MenuImageMaker.getImages()
        
        ChildConfigurationManager.setTarget(.niichan)
        let niichanImages = MenuImageMaker.getImages()
        
        // Verify both return images
        XCTAssertFalse(nichanImages.isEmpty, "Nichan menu images should not be empty")
        XCTAssertFalse(niichanImages.isEmpty, "Niichan menu images should not be empty")
    }
}