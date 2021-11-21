//
//  Utills.swift
//  SummerPlayerView
//
//  Created by Derrick on 2020/09/15.
//  Copyright © 2020 Derrick. All rights reserved.
//

import UIKit

import Foundation
class Utills {
     
    public static func getWholeViewRect(_ viewRect:CGRect) -> CGRect? {        
        let xAxis = viewRect.size.width / 4 / 2
        let yAxis: CGFloat = 0.0
        let width = viewRect.size.width / 4 * 3
        let height = viewRect.size.height * 0.75
        
        // Remark: 2021/11/21段階では、これは動画と再生バー等を含むviewのframeで、
        //         iPad 6thでは(128.0, 0.0, 768.0, 576.0)（画面全体は(0.0, 0.0, 1024.0, 768.0)）、
        //         34インチモニタ全画面では(558.5, 0.0, 3351.0, 1403.25)（画面全体は(0.0, 0.0, 4468.0, 1871.0)）
        return CGRect(x: xAxis, y: yAxis, width: width, height: height)
    }
    
    public static func getQuarterViewRect(_ viewRect:CGRect) -> CGRect? {
        var wholeStandardRect : CGRect
        let xAXIS : CGFloat = 0.0
        let yAXIS : CGFloat = 0.0
        let WIDTH = viewRect.size.width
        let HEIGHT = viewRect.size.height * 0.6
        
        wholeStandardRect = CGRect(x: xAXIS, y: yAXIS, width: WIDTH, height: HEIGHT)
        
        return wholeStandardRect
    }
    
}
