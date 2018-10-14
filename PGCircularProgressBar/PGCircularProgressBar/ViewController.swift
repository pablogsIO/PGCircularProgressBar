//
//  ViewController.swift
//  PGCircularProgressBar
//
//  Created by Pablo on 03/10/2018.
//  Copyright © 2018 Pablo Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var levels: UISegmentedControl!
    var progressbar: PGCircularProgressBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        let progressBarConfiguration = ProgressBarConfiguration<ProgressBarParameters, Any>(resolver: { (type) -> Any in
            switch type {
            case .attributedString:
                let font: UIFont? = UIFont(name: "Avenir-Book", size: 18)
                let fontSuper: UIFont? = UIFont(name: "Avenir-Book", size: 10)
                let attString: NSMutableAttributedString = NSMutableAttributedString(string: "SO2", attributes: [.font: font!])
                attString.setAttributes([.font: fontSuper!, .baselineOffset: -5], range: NSRange(location: 2, length: 1))
                return attString
            case .lineWidth:
                return CGFloat(2)
            case .borderColor:
                return UIColor.white.cgColor
            case .borderWidth:
                return CGFloat(1)
            }
        })

        progressbar = PGCircularProgressBar(frame: CGRect(x: self.view.frame.width/3, y: self.view.frame.height/4, width: 50, height: 100), configuration: progressBarConfiguration)
        self.view.addSubview(progressbar!)
        self.view.gradienteBackground(colors: (initColor: UIColor(rgb: 0x6A82FB), endColor: UIColor(rgb: 0xFC5C7D)), orientation: .bottomRightTopLeft)

    }

    @IBAction func levelIndex(_ sender: Any) {

        switch levels.selectedSegmentIndex {
        case 0:
            self.progressbar?.setProgressBarLevel(level: .low)
        case 1:
            self.progressbar?.setProgressBarLevel(level: .moderate)
        case 2:
            self.progressbar?.setProgressBarLevel(level: .high)
        case 3:
            self.progressbar?.setProgressBarLevel(level: .vhigh)
        default:
            self.progressbar?.setProgressBarLevel(level: .low)
        }
    }

}

extension UIView {

    func gradienteBackground(colors: GradientColors, orientation: GradientOrientation) {
        let gradient = CAGradientLayer()

        gradient.colors = [colors.initColor.cgColor, colors.endColor.cgColor]
        gradient.startPoint = orientation.points().startPoint
        gradient.endPoint = orientation.points().endPoint
        gradient.frame = bounds

        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
