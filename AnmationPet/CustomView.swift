//
//  CustomView.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 17.11.2022.
//

import UIKit

class CustomView: UIView {
    private let mainLabel = UILabel()
    private let textLabel = UILabel()

    private func setupUI() {
        self.addSubview(mainLabel.prepareForAutoLayout())
        mainLabel.centerXAnchor ~= self.centerXAnchor
        mainLabel.centerYAnchor ~= self.centerYAnchor
    }
}
