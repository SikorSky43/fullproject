//
//  CardView.swift
//  WalletAnimation
//
//  Created by Blackbird.
//

import Foundation
import UIKit

struct ColorCacheKey: Hashable {
    let hue: CGFloat
    let saturation: CGFloat
    let lightness: CGFloat
}

class CardView: UIView {
    
    private var dotViews: [DotView] = []
    private var colorCache: [ColorCacheKey : UIColor] = [:]
    
    private let nameLabel = UILabel()
    private let balanceLabel = UILabel()
    
    private let backgroundGradient = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var originFocalPoint: CGPoint = {
        CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
    }()
    
    // ---------------------------------------------------------
    // MARK: - Apple Cash Background Gradient
    // ---------------------------------------------------------
    
    private func setupBackgroundGradient() {
        
        backgroundGradient.colors = [
            UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1).cgColor, // #1C1C1C
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1).cgColor, // #121212
            UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1).cgColor  // #080808
        ]
        
        backgroundGradient.locations = [0.0, 0.45, 1.0]
        
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundGradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        
        backgroundGradient.type = .radial
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        backgroundGradient.endPoint   = CGPoint(x: 0.5, y: 1.3)
        
        layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    // ---------------------------------------------------------
    // MARK: - Dot Gradient Update (unchanged)
    // ---------------------------------------------------------
    
    func updateColors(withFocalPoint focalPoint: CGPoint) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let minHue = 0.2
        let maxHue = 0.8
        
        let radiusForMinimumHue = 0.0
        let radiusForMaximumHue = 380.0
        
        var saturation = 0.6
        let lightness = 0.7
        
        let distanceToBeginDesaturation = 400.0
        let distanceToEndDesaturation = 700.0
        
        for dot in dotViews {
            let xDist = abs(dot.center.x - focalPoint.x)
            let yDist = abs(dot.center.y - focalPoint.y)
            let distanceFromFocalPoint = hypot(xDist, yDist)
            
            var startHue = mapRange(distanceFromFocalPoint - 30,
                                    radiusForMinimumHue,
                                    radiusForMaximumHue,
                                    minHue, maxHue)
            
            var endHue = mapRange(distanceFromFocalPoint,
                                  radiusForMinimumHue,
                                  radiusForMaximumHue,
                                  minHue, maxHue)
            
            if distanceFromFocalPoint >= distanceToBeginDesaturation {
                saturation = mapRange(distanceFromFocalPoint,
                                      distanceToBeginDesaturation,
                                      distanceToEndDesaturation,
                                      0.6, 0)
            }
            
            startHue = clipUnit(value: startHue)
            endHue = clipUnit(value: endHue)
            saturation = clipUnit(value: saturation)
            
            let sHue = Double(round(100 * startHue)   / 100)
            let eHue = Double(round(100 * endHue)     / 100)
            let sat  = Double(round(100 * saturation) / 100)
            
            let startKey = ColorCacheKey(hue: sHue, saturation: sat, lightness: lightness)
            let endKey   = ColorCacheKey(hue: eHue, saturation: sat, lightness: lightness)
            
            let startColor = colorCache[startKey] ??
                UIColor(hue: sHue, saturation: sat, lightness: lightness, alpha: 1)
            let endColor = colorCache[endKey] ??
                UIColor(hue: eHue, saturation: sat, lightness: lightness, alpha: 1)
            
            colorCache[startKey] = startColor
            colorCache[endKey] = endColor
            
            dot.gradient.colors = [startColor.cgColor, endColor.cgColor]
        }
        
        CATransaction.commit()
    }
    
    // ---------------------------------------------------------
    // MARK: - Dot Layout (unchanged)
    // ---------------------------------------------------------
    
    func setupDots() {
        let rows = 6
        
        for i in 0...rows {
            let centerRow = Int(rows / 2)
            let dist = CGFloat(abs(i - centerRow))
            
            let baseSize = 13.0
            let scale = mapRange(dist, 0, CGFloat(rows), 1.0, 0.1)
            let size = baseSize * scale
            
            let radiusAdjustment = mapRange(CGFloat(i), 0, CGFloat(rows), 26, 22)
            let radius = 40.0 + CGFloat(i) * radiusAdjustment
            
            let angleInterval = Double.pi / (6.0 * (CGFloat(i + 1)))
            
            for angle in stride(from: 0.0, to: Double.pi * 2, by: angleInterval) {
                
                let x = radius * sin(angle) + originFocalPoint.x
                let y = radius * cos(angle) + originFocalPoint.y
                
                let dot = DotView()
                dot.bounds.size = CGSize(width: size, height: size)
                
                dot.transform = CGAffineTransform(rotationAngle: -angle + .pi)
                dot.center = CGPoint(x: x, y: y)
                
                if dot.frame.intersects(bounds) {
                    addSubview(dot)
                    dotViews.append(dot)
                }
            }
        }
        
        updateColors(withFocalPoint: originFocalPoint)
    }
    
    // ---------------------------------------------------------
    // MARK: - UI Setup
    // ---------------------------------------------------------
    
    func setupSubviews() {
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 13   // <<— YOUR ORIGINAL RADIUS
        
        // Very subtle Apple border
        layer.borderColor = UIColor(white: 1, alpha: 0.03).cgColor
        layer.borderWidth = 0.20
        
        layer.masksToBounds = true
        
        setupBackgroundGradient()
        
        addSubview(nameLabel)
        addSubview(balanceLabel)
        
        nameLabel.text = "Cash"
        balanceLabel.text = "$40"
        
        nameLabel.textAlignment = .left
        balanceLabel.textAlignment = .right
        
        [nameLabel, balanceLabel].forEach {
            $0.textColor = .white
            $0.font = .boldSystemFont(ofSize: 32)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradient.frame = bounds
        
        let pad = 15.0
        let height = 50.0
        
        nameLabel.frame = CGRect(x: pad, y: 0,
                                 width: bounds.size.width,
                                 height: height)
        
        balanceLabel.frame = CGRect(x: 0, y: 0,
                                    width: bounds.size.width - pad,
                                    height: height)
        
        if dotViews.isEmpty {
            setupDots()
        }
    }
}
