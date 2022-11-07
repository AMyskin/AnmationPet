//
//  AccessibilityCarouselContainer.swift
//  VTBUIKit
//
//  Created by Viktor Shabanov on 27.11.2020.
//  Copyright © 2020 VTB. All rights reserved.
//

import UIKit

public protocol AccessibilityCarouselContainer: AnyObject {
    /// Основной UIScrollView карусели
    var accessibilityCaruselScrollView: UIScrollView { get }

    /// Набор элементов, доступных к позиционированию
    var accessibilityCaruselItems: [AccessibilityCarouselItem] { get }

    /// Текущий выбранный элемент
    var accessibilityCaruselItem: AccessibilityCarouselItem? { get set }
}
