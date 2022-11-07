//
//  ViewController.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 07.11.2022.
//

import UIKit

class ViewController: UIViewController {

    /// The colored card shape.
    private let shapeLayer = CAShapeLayer()
    /// The alpha mask, needed so that the animation does not clip.
    private let maskLayer = CAShapeLayer()
    /// The initial path at the animation's beginning

    /// The final path at the animation's end.

    private var initialPath = UIBezierPath()
    private var finalPath = UIBezierPath()

    private let myButton = UIButton()
    private let myView = UIView()

    private var toogle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        setupUI()

        let firstPath2 = UIBezierPath()
        firstPath2.move(to: CGPoint(x: 50, y: 0))
        firstPath2.addLine(to: CGPoint(x: 100, y: 100))
        firstPath2.addLine(to: CGPoint(x: 0, y: 100))
        firstPath2.addLine(to: CGPoint(x: 50, y: 0))

        initialPath.move(to: CGPoint(x: 0, y: 0))
        initialPath.addLine(to: CGPoint(x: 60, y: 0))
        initialPath.addQuadCurve(to: CGPoint(x: 100, y: 40), controlPoint: CGPoint(x: 100, y: 0))
        initialPath.addLine(to: CGPoint(x: 100, y: 60))
        initialPath.addQuadCurve(to: CGPoint(x: 60, y: 100), controlPoint: CGPoint(x: 100, y: 100))
        initialPath.addLine(to: CGPoint(x: 0, y: 100))
        initialPath.addLine(to: CGPoint(x: 0, y: 0))

        initialPath = firstPath2

        shapeLayer.path = initialPath.cgPath

        myView.layer.addSublayer(shapeLayer)

        maskLayer.path = shapeLayer.path
        maskLayer.position =  shapeLayer.position

        shapeLayer.fillColor = UIColor.red.cgColor
        myView.layer.mask = maskLayer
    }

    private func setupUI() {
        view.backgroundColor = .green
        view.addSubview(myButton)
        myButton.backgroundColor = .green
        myButton.setTitle("Push", for: .normal)
        myButton.setTitleColor(.black, for: .normal)
        myButton.addTarget(self, action: #selector(pushButton), for: .touchUpInside)
        myButton.prepareForAutoLayout()
        myButton.pinToCenterSuperview(xOffset: 0, yOffset: 250)

        view.addSubview(myView)
        myView.prepareForAutoLayout()
        myView.pinToCenterSuperview(xOffset: 0, yOffset: -200)
        myView.widthAnchor ~= 250
        myView.heightAnchor ~= 250
        myView.backgroundColor = .yellow
    }

    @objc func pushButton() {
        toogle.toggle()
        switch toogle {
        case true:
            animate(completed: nil)
        case false:
            reverseAnimation(completed: nil)
        }
    }

    func animate(duration: CFTimeInterval = 1, completed: (() -> Void)?) {
        let second = UIBezierPath()
        second.move(to: CGPoint(x: 0, y: 0))
        second.addLine(to: CGPoint(x: 100, y: 0))
//        second.addLine(to: CGPoint(x: 100, y: 0))
//        second.addLine(to: CGPoint(x: 100, y: 100))
        second.addLine(to: CGPoint(x: 100, y: 100))
        second.addLine(to: CGPoint(x: 0, y: 100))
        second.addLine(to: CGPoint(x: 0, y: 0))
        second.close()

        finalPath = second

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completed?()
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .default)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animateCard")
        maskLayer.add(animation, forKey: "animateCard")
        CATransaction.commit()
    }

    func reverseAnimation(duration: CFTimeInterval = 1, completed: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completed?()
        }
        let reverseAnimation = CABasicAnimation(keyPath: "path")
        reverseAnimation.duration = duration
        reverseAnimation.fromValue = finalPath.cgPath
        reverseAnimation.toValue = initialPath.cgPath
        reverseAnimation.timingFunction = CAMediaTimingFunction(name: .default)
        reverseAnimation.isRemovedOnCompletion = false
        reverseAnimation.fillMode = .backwards
        shapeLayer.removeAnimation(forKey: "animateCard")
        maskLayer.removeAnimation(forKey: "animateCard")
        shapeLayer.add(reverseAnimation, forKey: "animateCard")
        maskLayer.add(reverseAnimation, forKey: "animateCard")
        CATransaction.commit()
    }
}

