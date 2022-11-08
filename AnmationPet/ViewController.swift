//
//  ViewController.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 07.11.2022.
//

import UIKit

class ViewController: UIViewController {

    private let shapeLayer = CAShapeLayer()

    private var initialPath = UIBezierPath()
    private var finalPath = UIBezierPath()

    private let shapeLayer2 = CAShapeLayer()

    private var initialPath2 = UIBezierPath()
    private var finalPath2 = UIBezierPath()

    private let myButton = UIButton()
    private let myButton2 = UIButton()
    private let mySlider = UISlider()
    private let myView = UIView()
    private let myView2 = UIView()

    private var toogle: Bool = false
    private var toogle2: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        setupUI()
        setupLayers()
    }

    private func setupLayers() {
        let firstPath2 = UIBezierPath()
        firstPath2.move(to: CGPoint(x: 50, y: 0))
        firstPath2.addLine(to: CGPoint(x: 100, y: 100))
        firstPath2.addLine(to: CGPoint(x: 0, y: 100))
        firstPath2.addLine(to: CGPoint(x: 50, y: 0))

        initialPath = firstPath2

        shapeLayer.path = initialPath.cgPath
        myView.layer.addSublayer(shapeLayer)
        myView.layer.mask = shapeLayer

        initialPath2.move(to: CGPoint(x: 0, y: 0))
        initialPath2.addLine(to: CGPoint(x: 60, y: 0))
        initialPath2.addQuadCurve(to: CGPoint(x: 100, y: 40), controlPoint: CGPoint(x: 100, y: 0))
        initialPath2.addLine(to: CGPoint(x: 100, y: 60))
        initialPath2.addQuadCurve(to: CGPoint(x: 60, y: 100), controlPoint: CGPoint(x: 100, y: 100))
        initialPath2.addLine(to: CGPoint(x: 0, y: 100))
        initialPath2.addLine(to: CGPoint(x: 0, y: 0))

        shapeLayer2.path = initialPath2.cgPath
        myView2.layer.addSublayer(shapeLayer2)
        myView2.layer.mask = shapeLayer2
    }

    private func setupUI() {
        view.backgroundColor = .gray

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 100
        view.addSubview(stack.prepareForAutoLayout())
        stack.pinEdgesToSuperviewEdges(top: 150, left: 0, bottom: 50, right: 0)

        stack.addArrangedSubview(myView)

        myView.widthAnchor ~= 100
        myView.heightAnchor ~= 100
        myView.backgroundColor = .red

        stack.addArrangedSubview(myView2)
        myView2.widthAnchor ~= 100
        myView2.heightAnchor ~= 100
        myView2.backgroundColor = .magenta

        stack.addArrangedSubview(myButton)
        myButton.backgroundColor = .green
        myButton.setTitle("Animation1", for: .normal)
        myButton.setTitleColor(.black, for: .normal)
        myButton.widthAnchor ~= 120
        myButton.addTarget(self, action: #selector(pushButton), for: .touchUpInside)

        stack.setCustomSpacing(50, after: myButton)

        stack.addArrangedSubview(myButton2)
        myButton2.backgroundColor = .green
        myButton2.setTitle("Animation2", for: .normal)
        myButton2.setTitleColor(.black, for: .normal)
        myButton2.widthAnchor ~= 120
        myButton2.addTarget(self, action: #selector(pushButton2), for: .touchUpInside)

        stack.addArrangedSubview(mySlider.prepareForAutoLayout())
        mySlider.widthAnchor ~= 250
        mySlider.minimumValue = 0
        mySlider.maximumValue = 100

        mySlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)


    }

    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        self.shapeLayer.timeOffset = Double(sender.value) / 100
    }

    @objc func pushButton() {
        toogle.toggle()
        let duration: CFTimeInterval = 1
        switch toogle {
        case true:
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
            animate2(
                duration: duration,
                initialPath: initialPath,
                finalPath: finalPath,
                shapeLayer: shapeLayer,
                speed: 0
            )
        case false:
            reverseAnimation2(
                duration: duration,
                initialPath: initialPath,
                finalPath: finalPath,
                shapeLayer: shapeLayer
            )
        }
    }

    @objc func pushButton2() {
        toogle2.toggle()
        let duration: CFTimeInterval = 0.5
        switch toogle2 {
        case true:
            let second = UIBezierPath()
            second.move(to: CGPoint(x: 0, y: 0))
            second.addLine(to: CGPoint(x: 100, y: 0))
            second.addLine(to: CGPoint(x: 100, y: 0))
            second.addLine(to: CGPoint(x: 100, y: 100))
            second.addLine(to: CGPoint(x: 100, y: 100))
            second.addLine(to: CGPoint(x: 0, y: 100))
            second.addLine(to: CGPoint(x: 0, y: 0))
            second.close()

            finalPath2 = second
            animate2(
                duration: duration,
                initialPath: initialPath2,
                finalPath: finalPath2,
                shapeLayer: shapeLayer2
            )
        case false:
            reverseAnimation2(
                duration: duration,
                initialPath: initialPath2,
                finalPath: finalPath2,
                shapeLayer: shapeLayer2
            )
        }
    }

    func animate2(
        duration: CFTimeInterval = 1,
        initialPath: UIBezierPath,
        finalPath: UIBezierPath,
        shapeLayer: CAShapeLayer,
        speed: Float = 1
    ) {
        shapeLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animateCard")
//        shapeLayer2.path = finalPath2.cgPath
        shapeLayer.speed = speed

    }

    func reverseAnimation2(
        duration: CFTimeInterval = 1,
        initialPath: UIBezierPath,
        finalPath: UIBezierPath,
        shapeLayer: CAShapeLayer
    ) {
        shapeLayer.removeAllAnimations()
        let reverseAnimation = CABasicAnimation(keyPath: "path")
        reverseAnimation.duration = duration
        reverseAnimation.fromValue = finalPath.cgPath
        reverseAnimation.toValue = initialPath.cgPath
        reverseAnimation.timingFunction = CAMediaTimingFunction(name: .default)
//        reverseAnimation.isRemovedOnCompletion = false
        reverseAnimation.fillMode = .backwards
        shapeLayer.add(reverseAnimation, forKey: "animateCard")
        shapeLayer.path = initialPath.cgPath
    }
}

