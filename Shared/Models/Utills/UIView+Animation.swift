//
//  UIView+Animation.swift
//  KidsVideo
//
//  Created by headspinnerd on 2021/10/10.
//  Reference URL: https://qiita.com/p_x9/items/c725e375476eef1e81be
//

import UIKit

extension UIView {
    func addRainbowBorderAnimation() {
        Constants.lastShapeLayer?.removeAllAnimations()
        Constants.lastShapeLayer?.removeFromSuperlayer()
        Constants.lastGraidentLayer?.removeFromSuperlayer()
        
        if frame.width < 1 {
            // HACK: 初回はframeが定まってないため、虹色ボーダーが出ない。frameを上書きしてボーダーを出す
            frame = CGRect(origin: .zero, size: Constants.contentListitemSize)
        }
        var rainbow: [CGColor] {
            let increment: CGFloat = 0.02

            return [CGFloat](stride(from: 0.0, to: 1.0, by: increment)).map{ hue in
                UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            }
        }
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.lineWidth = 10.0
        layer.addSublayer(shapeLayer)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = rainbow
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
        let animation1 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation1.fromValue         = 0.0
        animation1.toValue           = 1.0
        animation1.duration          = 1.0
        
        animation1.beginTime = 0
        
        animation1.isRemovedOnCompletion = false
        animation1.fillMode = .forwards
        
        
        let animation2 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        animation2.fromValue         = 0.0
        animation2.toValue           = 1.0
        animation2.duration          = 1.0
        animation2.beginTime = 1/*+CACurrentMediaTime()*/
        
        
        let group = CAAnimationGroup()
        group.duration = 1.0
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.animations = [animation1,animation2]

        shapeLayer.add(group, forKey: "group-animation")
        
        Constants.lastShapeLayer = shapeLayer
        Constants.lastGraidentLayer = gradientLayer
    }
}
