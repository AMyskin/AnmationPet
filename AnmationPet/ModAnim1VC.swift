//
//  ModAnim1VC.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 22.11.2022.
//

import UIKit

class ModAnim1VC: UIViewController {

    private let modButton = UIButton()
    private let dissmissBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setupUI()

        print("ModAnim1VC")

        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        view.addSubview(modButton.prepareForAutoLayout())
        modButton.setTitle("modal", for: .normal)
        modButton.centerXAnchor ~= view.centerXAnchor
        modButton.centerYAnchor ~= view.centerYAnchor
        modButton.addTarget(self, action: #selector(pushButton), for: .touchUpInside)

        view.addSubview(dissmissBtn.prepareForAutoLayout())
        dissmissBtn.setTitle("pushDissmiss", for: .normal)
        dissmissBtn.centerXAnchor ~= view.centerXAnchor
        dissmissBtn.centerYAnchor ~= view.centerYAnchor + 100
        dissmissBtn.addTarget(self, action: #selector(pushDissmiss), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ModAnim1VC viewWillAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ModAnim1VC viewWillLayoutSubviews")
    }

    @objc func pushDissmiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc func pushButton() {
        let modalVC = ModAnim2VC()
        modalVC.modalPresentationStyle = .custom
        modalVC.transitioningDelegate = self
        present(modalVC, animated: true)
    }
}

extension ModAnim1VC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ModAnim1VC: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view
        else {
            return
        }

        let isPresenting = (fromView == view)

        let presentingView = isPresenting ? toView : fromView

        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }

        let size = CGSize(width: UIScreen.main.bounds.width / 2.0,
                          height: UIScreen.main.bounds.height)

        let offSreenFrame = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)
        let onSreenFrame = CGRect(origin: .zero, size: size)

        presentingView.frame = isPresenting ? offSreenFrame : onSreenFrame

        let animationDuration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: animationDuration) {
            presentingView.frame = isPresenting ? onSreenFrame : offSreenFrame
        } completion: { isSuccess in
            if !isSuccess {
                presentingView.removeFromSuperview()
            }
            transitionContext.completeTransition(isSuccess)
        }

    }
}
