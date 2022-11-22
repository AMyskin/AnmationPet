//
//  ModAnim2VC.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 22.11.2022.
//

import UIKit

class ModAnim2VC: UIViewController {
    private let modButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        print("ModAnim2VC")

        view.addSubview(modButton.prepareForAutoLayout())
        modButton.setTitle("dissmiss", for: .normal)
        modButton.setTitleColor(.black, for: .normal)
        modButton.centerXAnchor ~= view.centerXAnchor
        modButton.centerYAnchor ~= view.centerYAnchor
        modButton.addTarget(self, action: #selector(pushButton), for: .touchUpInside)
    }

    @objc func pushButton() {
        dismiss(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ModAnim2VC viewWillAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ModAnim2VC viewWillLayoutSubviews")
    }
}
