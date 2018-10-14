//
//  PGCircularProgessBar.swift
//  PGCircularProgressBar
//
//  Created by Pablo on 03/10/2018.
//  Copyright © 2018 Pablo Garcia. All rights reserved.
//

import UIKit

enum ProgressBarLevel {

    case low
    case moderate
    case high
    case vhigh
}

class PGCircularProgressBar: UIView {

    private var title: UILabel?

    private var level = ProgressBarLevel.low
    private var shapeLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()

    private var bezierPath: UIBezierPath?

    init(frame: CGRect, configuration: ProgressBarConfiguration<ProgressBarParameters, Any> ) {
        let maximun = max(frame.width, frame.height)

        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: maximun, height: maximun)))

        self.layer.borderColor = (configuration[.borderColor] as! CGColor)
        self.layer.borderWidth = (configuration[.borderWidth] as! CGFloat)
        setupProgressBarLayer(lineWidth: configuration[.lineWidth] as! CGFloat)
        self.layer.cornerRadius = 15
        title = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/10))

        title?.attributedText =  configuration[.attributedString] as? NSAttributedString
        title?.textAlignment = .center
        title?.textColor = UIColor.white
        self.addSubview(title!)
        title?.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {

        NSLayoutConstraint.init(item: title!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: title!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: title!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: title!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 20, constant: 0).isActive = true

    }

    private func setupProgressBarLayer(lineWidth: CGFloat) {

        bezierPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.height/2,
                                                         y: self.frame.size.height/2),
                                      radius: self.frame.size.height/3,
                                      startAngle: 3*CGFloat.pi/4,
                                      endAngle: 9*CGFloat.pi/4,
                                      clockwise: true)

        let baseShape = CAShapeLayer()
        baseShape.path = bezierPath?.cgPath
        baseShape.strokeColor = UIColor.darkGray.cgColor
        baseShape.lineWidth = lineWidth
        baseShape.lineCap = .round

        baseShape.fillColor = UIColor.clear.cgColor

        shapeLayer.path = bezierPath?.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.clear.cgColor

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor.green.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.red.cgColor, UIColor.red.cgColor]

        gradientLayer.frame = self.bounds
        gradientLayer.mask = shapeLayer
        self.layer.addSublayer(baseShape)
        self.layer.addSublayer(gradientLayer)

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
    }

    public func setProgressBarLevel( level: ProgressBarLevel) {

        self.level = level
        var value = 0.0

        switch self.level {
        case .low:
            value = 0.4
        case .moderate:
            value = 0.7
        case .high:
            value = 0.9
        case .vhigh:
            value = 1
        }

        let drawProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")

        drawProgressAnimation.toValue = value
        drawProgressAnimation.duration = 2
        drawProgressAnimation.fillMode = .forwards
        drawProgressAnimation.isRemovedOnCompletion = false
        shapeLayer.add(drawProgressAnimation, forKey: "test")
    }

    @objc
    private func tapGesture() {

        shapeLayer.path = bezierPath?.cgPath

        let drawProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")

        drawProgressAnimation.toValue = 1
        drawProgressAnimation.duration = 2
        drawProgressAnimation.fillMode = .forwards
        drawProgressAnimation.isRemovedOnCompletion = false
        shapeLayer.add(drawProgressAnimation, forKey: "test")
    }

}
