//
//  Content+URL.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/10/03.
//

import Foundation

extension Content {
    func getUrl() -> URL? {
        guard let path = Bundle.main.path(forResource: fileName, ofType:fileExt) else {
            debugPrint("\(fileName).\(fileExt) not found")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
}
