//
//  FontFamily.swift
//  VTBSDK
//
//  Created by Milkhail Babushkin on 04/10/2019.
//  Copyright © 2019 VTB. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit.UIFont

struct FontFamily {
    enum SFUIText: String {
        case Regular    = "SFUIText"
        case Medium     = "SFUIText-Medium"
        case Bold       = "SFUIText-Bold"
        case Heavy      = "SFUIText-Heavy"

        func font(size: CGFloat) -> UIFont? { return UIFont(name: self.rawValue, size: size) }
    }

    enum SFUIDisplay: String {
        case Regular    = "SFUIDisplay-Regular"
        case Medium     = "SFUIDisplay-Medium"
        case Bold       = "SFUIDisplay-Bold"
        case Heavy      = "SFUIDisplay-Heavy"

        func font(size: CGFloat) -> UIFont? { return UIFont(name: self.rawValue, size: size) }
    }
}
