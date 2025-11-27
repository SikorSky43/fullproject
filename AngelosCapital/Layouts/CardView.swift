//
//  CardView.swift
//  WalletAnimation
//

import Foundation
import UIKit
import SwiftUI

struct ColorCacheKey: Hashable {
    let hue: CGFloat
    let saturation: CGFloat
    let lightness: CGFloat
}

class CardView: UIView {

    // NOT ObservableObject (UIKit cannot use it)
    private var balanceService = Balance.shared

    private var dotViews: [DotView] = []
    private var colorCache: [ColorCacheKey : UIColor] = [:]

    private let nameLabel = UILabel()
    private let balanceLabel = UILabel()

    private let backgroundGradient = CAGradientLayer()

    // ---------------------------------------------------------
    // MARK: - Init
    // ---------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupBalanceObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Listen for balance updates from SwiftUI
    private func setupBalanceObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBalanceLabel),
            name: .didUpdateBalance,
            object: nil
        )
    }

    @objc private func updateBalanceLabel() {
        DispatchQueue.main.async {
            self.balanceLabel.text = Balance.shared.invest
        }
    }

    // ---------------------------------------------------------
    // MARK: - Apple Cash Background Gradient
    // ---------------------------------------------------------
    private func setupBackgroundGradient() {

        backgroundGradient.colors = [
            UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1).cgColor,
            UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1).cgColor,
            UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1).cgColor
        ]

        backgroundGradient.locations = [0.0, 0.45, 1.0]

        backgroundGradient.type = .radial
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.25)
        backgroundGradient.endPoint   = CGPoint(x: 0.5, y: 1.3)

        layer.insertSublayer(backgroundGradient, at: 0)
    }

    // ---------------------------------------------------------
    // MARK: - Dot Gradient Update (Blue Apple style)
    // ---------------------------------------------------------
    func updateColors(withFocalPoint focalPoint: CGPoint) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        for dot in dotViews {

            let x = abs(dot.center.x - focalPoint.x)
            let y = abs(dot.center.y - focalPoint.y)
            let distance = hypot(x, y)

            let inner: CGFloat = 0
            let outer: CGFloat = 380

            let t = clipUnit(value: mapRange(distance, inner, outer, 0, 1))

            let lightBlue = UIColor(red: 0.30, green: 0.64, blue: 1.00, alpha: 1)
            let appleBlue = UIColor(red: 0.04, green: 0.52, blue: 1.00, alpha: 1)
            let deepBlue  = UIColor(red: 0.00, green: 0.23, blue: 0.49, alpha: 1)

            let color: UIColor
            if t < 0.5 {
                color = blend(lightBlue, appleBlue, amount: t * 2)
            } else {
                color = blend(appleBlue, deepBlue, amount: (t - 0.5) * 2)
            }

            dot.gradient.colors = [color.cgColor, color.cgColor]
        }

        CATransaction.commit()
    }

    private func blend(_ c1: UIColor, _ c2: UIColor, amount: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        c1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        c2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = r1 + (r2 - r1) * amount
        let g = g1 + (g2 - g1) * amount
        let b = b1 + (b2 - b1) * amount

        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }

    // ---------------------------------------------------------
    // MARK: - Dot Layout
    // ---------------------------------------------------------
    lazy var originFocalPoint: CGPoint = {
        CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
    }()

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
        layer.cornerRadius = 13

        layer.borderColor = UIColor(white: 1, alpha: 0.03).cgColor
        layer.borderWidth = 0.13
        layer.masksToBounds = true

        setupBackgroundGradient()

        addSubview(nameLabel)
        addSubview(balanceLabel)

        nameLabel.text = "Cash"
        balanceLabel.text = Balance.shared.invest   // initial value

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
