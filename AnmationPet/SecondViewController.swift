//
//  SecondViewController.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 08.11.2022.
//

import UIKit
import Lottie

class SecondViewController: UIViewController {

    private var animationView: LottieAnimationView?

//    private let animateView: LottieAnimationView = LottieAnimationView()

    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Create Animation object
        let jsonName = "test"
        let animation = LottieAnimation.named(jsonName)

        // Load animation to AnimationView
        animationView = LottieAnimationView(animation: animation)
//        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        guard let animationView = animationView else { return }

        view.addSubview(animationView.prepareForAutoLayout())
        animationView.centerXAnchor ~= view.centerXAnchor
        animationView.centerYAnchor ~= view.centerYAnchor
        animationView.widthAnchor ~= view.widthAnchor
        animationView.heightAnchor ~= 200
        animationView.isHidden = true



        view.addSubview(button.prepareForAutoLayout())
        button.bottomAnchor ~= view.bottomAnchor - 30
        button.leftAnchor ~= view.leftAnchor + 16

        button.backgroundColor = .green
        button.setTitle("Animation1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.widthAnchor ~= 120
        button.heightAnchor ~= 30
        button.addTarget(self, action: #selector(pushButton), for: .touchUpInside)
    }

    @objc
    private func pushButton() {
        animationView?.isHidden = false
        animationView?.play()
    }
}

class TestClass {

    let a: Int
    init(a: Int) {
        self.a = a
    }

    convenience init?() {
        self.init(a: 0)
    }
}

class Child: TestClass {
    override init(a: Int) {
        super.init(a: 0)
    }
}
