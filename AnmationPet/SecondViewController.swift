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
    private let button2 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SecondViewController viewWillAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("SecondViewController viewWillLayoutSubviews")
    }

    private func setupUI() {
        title = "Animation"
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
        button.bottomAnchor ~= view.bottomAnchor - 150
        button.leftAnchor ~= view.leftAnchor + 16

        button.backgroundColor = .green
        button.setTitle("Animation1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.widthAnchor ~= 120
        button.heightAnchor ~= 30
        button.addTarget(self, action: #selector(pushButton), for: .touchUpInside)

        view.addSubview(button2.prepareForAutoLayout())
        button2.bottomAnchor ~= view.bottomAnchor - 150
        button2.leftAnchor ~= view.rightAnchor - 150

        button2.backgroundColor = .green
        button2.setTitle("BottomSheet", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.widthAnchor ~= 120
        button2.heightAnchor ~= 30
        button2.addTarget(self, action: #selector(pushButton2), for: .touchUpInside)
    }

    @objc private func pushButton() {
        animationView?.isHidden = false
        animationView?.play()
    }

    @objc private func pushButton2() {
        showMyViewControllerInACustomizedSheet()
    }


    func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = BottomSheetViewController()
        if let sheet = viewControllerToPresent.sheetPresentationController {

            sheet.detents = [ .medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
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
