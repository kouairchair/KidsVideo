//
//  ChildConfiguration.swift
//  KidsVideo
//
//  Created by AI Assistant
//

import Foundation

public enum ChildTarget: String, CaseIterable {
    case jinan = "JINAN"     // 次男 (younger son)
    case chonan = "NIICHAN"   // 長男 (older son)
}

public struct VideoConfiguration: Codable {
    let videos: [ContentData]
    let menuImages: [MenuImageData]
    let backgroundImage: String
}

public struct ContentData: Codable {
    let fileName: String
    let fileExt: String
    let totalTime: String
    let channel: String
}

public struct MenuImageData: Codable {
    let fileName: String
    let fileExt: String
    let channel: String
}

public class ChildConfigurationManager {
    private static var _currentTarget: ChildTarget?
    
    public static var currentTarget: ChildTarget {
        if let cached = _currentTarget {
            return cached
        }
        
        // Check environment variable first (for development/testing)
        if let envTarget = ProcessInfo.processInfo.environment["TARGET_CHILD"],
           let target = ChildTarget(rawValue: envTarget) {
            _currentTarget = target
            return target
        }
        
        // Check build configuration
        #if JINAN
        _currentTarget = .jinan
        #elseif NIICHAN
        _currentTarget = .chonan
        #else
        // Default fallback - can be changed based on requirements
        _currentTarget = .jinan
        #endif
        
        return _currentTarget!
    }
    
    public static func loadConfiguration() -> VideoConfiguration? {
        let fileName = currentTarget == .jinan ? "videos_jinan" : "videos_chonan"
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            print("Failed to load configuration file: \(fileName).json")
            return nil
        }
        
        do {
            let configuration = try JSONDecoder().decode(VideoConfiguration.self, from: data)
            return configuration
        } catch {
            print("Failed to decode configuration: \(error)")
            return nil
        }
    }
    
    public static func setTarget(_ target: ChildTarget) {
        _currentTarget = target
    }
}
