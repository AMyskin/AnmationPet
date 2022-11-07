//
//  AccessibilityCarouselItem.swift
//  VTBUIKit
//
//  Created by Viktor Shabanov on 27.11.2020.
//  Copyright © 2020 VTB. All rights reserved.
//

import UIKit

open class AccessibilityCarouselItem: Equatable {
    /// Элемент карусели для озвучки
    public let accessibilityView: UIView

    /// Фрейм для позиционирования фокуса карусели при озвучке элемента.
    /// В большинсве случаев фрейм позиционирования совпадает с фреймом элемента.
    /// В сложных лайаутах данный фрейм должен будет общим для группы, входящих в него элементов.
    open var accessibilityFrameInCarouselSpace: CGRect {
        return accessibilityView.frame
    }

    /// Для вырожденного случая, когда контейнер является коллецией
    open var indexPath: IndexPath?

    public init(view: UIView) {
        self.accessibilityView = view
    }

    // MARK: - Equatable

    public static func == (lhs: AccessibilityCarouselItem, rhs: AccessibilityCarouselItem) -> Bool {
        return lhs.accessibilityView == rhs.accessibilityView
    }
}
