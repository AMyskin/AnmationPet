//
//  AccessibilityCarouselElement.swift
//  VTBUIKit
//
//  Created by Viktor Shabanov on 27.11.2020.
//  Copyright © 2020 VTB. All rights reserved.
//

import UIKit

open class AccessibilityCarouselElement: UIAccessibilityElement {
    private unowned let _container: AccessibilityCarouselContainer

    open override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            super.isAccessibilityElement = newValue
        }
    }

    open override var accessibilityValue: String? {
        get {
            if let item = _container.accessibilityCaruselItem {
                return accessibilityCarouselSpelling(for: item)
            }
            return super.accessibilityValue
        }
        set {
            super.accessibilityValue = newValue
        }
    }

    open override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .adjustable
        }
        set {
            super.accessibilityTraits = newValue
        }
    }

    open override var accessibilityFrameInContainerSpace: CGRect {
        get {
            return _container.accessibilityCaruselScrollView.frame
        }
        set {
            super.accessibilityFrameInContainerSpace = newValue
        }
    }

    public var isActivatedWhenSelected: Bool = false

    public var carouselScrollPosition: UICollectionView.ScrollPosition = .right

    public init(container: AccessibilityCarouselContainer) {
        _container = container
        super.init(accessibilityContainer: container)
    }

    /// По-умолчанию реализован следеющий порядок озвучки:
    /// ["Выбрано"] + , + ["Недоступно"] + , + accessibilityLabel + , + accessibilityValue + , + "index из count".
    /// Наличие "Выбрано" и/или "Недоступно" зависит от наличия соответствующего трейта у озвучиваемого элемента.
    open func accessibilityCarouselSpelling(for item: AccessibilityCarouselItem) -> String? {
        let view = item.accessibilityView

        var components = [
            view.accessibilityLabel,
            view.accessibilityValue
        ]

        if view.accessibilityTraits.contains(.notEnabled) {
            components.insert("Unavailable".localized, at: 0)
        }

        if view.accessibilityTraits.contains(.selected) {
            components.insert("Selected".localized, at: 0)
        }

        if let index = index(of: item) {
            components.append("\(index + 1) " + "From".localized + " \(_container.accessibilityCaruselItems.count)")
        }

        let spelling = components.compactMap { $0 }.joined(separator: ", ")
        return spelling.isEmpty ? nil : spelling
    }

    @discardableResult
    open func accessibilityCarouselScrollForward() -> Bool {
        guard let index = indexOfForwardItem() else {
            return false
        }

        return accessibilityCarouselScroll(to: index)
    }

    @discardableResult
    open func accessibilityCarouselScrollBackward() -> Bool {
        guard let index = indexOfBackwardItem() else {
            return false
        }

        return accessibilityCarouselScroll(to: index)
    }

    // MARK: - UIAccessibility methods

    @discardableResult
    open override func accessibilityActivate() -> Bool {
        guard let item = _container.accessibilityCaruselItem else {
            return false
        }
        guard !item.accessibilityView.accessibilityTraits.contains(.notEnabled) else {
            return false
        }

        // В некоторых случаях VoiceOver не вызывает у коллекции didSelectItemAt.
        // Возможно, это связано с неверным опреелением IndexPath элемента VoiceOver'ом.
        // Поэтому вызываем didSelectItemAt напрямую.
        if let collectionView = _container.accessibilityCaruselScrollView as? UICollectionView {
            if let indexPath = item.indexPath,
               let collectionViewDelegate = collectionView.delegate {
                collectionViewDelegate.collectionView?(collectionView, didSelectItemAt: indexPath)

                return true
            } else {
                return false
            }
        }

        return item.accessibilityView.accessibilityActivate()
    }

    open override func accessibilityIncrement() {
        accessibilityCarouselScrollForward()
    }

    open override func accessibilityDecrement() {
        accessibilityCarouselScrollBackward()
    }

    open override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        switch direction {
        case .left:
            return accessibilityCarouselScrollForward()

        case .right:
            return accessibilityCarouselScrollBackward()

        default:
            return false
        }
    }

    // MARK: - Private methods

    private func index(of item: AccessibilityCarouselItem) -> Int? {
        let items = _container.accessibilityCaruselItems
        return items.firstIndex(of: item)
    }

    private func indexOfFocusedItem() -> Int? {
        guard let item = _container.accessibilityCaruselItem else {
            return nil
        }

        return index(of: item)
    }

    private func indexOfForwardItem() -> Int? {
        let items = _container.accessibilityCaruselItems
        guard let index = indexOfFocusedItem(), index < items.count - 1 else {
            return nil
        }

        return index + 1
    }

    private func indexOfBackwardItem() -> Int? {
        guard let index = indexOfFocusedItem(), index > 0 else {
            return nil
        }

        return index - 1
    }

    private func accessibilityCarouselScroll(to index: Int) -> Bool {
        let items = _container.accessibilityCaruselItems
        guard let item = items[safe: index]  else {
            return false
        }

        // В вырожденном случае при работа с коллерциями движение происходит по индексу
        if let collectionView = _container.accessibilityCaruselScrollView as? UICollectionView {
            let indexPath = item.indexPath ?? IndexPath(row: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: carouselScrollPosition, animated: true)
        } else {
            let frame = item.accessibilityFrameInCarouselSpace
            _container.accessibilityCaruselScrollView.scrollRectToVisible(frame, animated: true)
        }

        _container.accessibilityCaruselItem = item
        UIAccessibility.post(notification: .layoutChanged, argument: nil)

        if isActivatedWhenSelected && UIAccessibility.isVoiceOverRunning {
            accessibilityActivate()
        }
        return true
    }
}

private extension Array {
    // swiftlint:disable identifier_name
    subscript(safe i: Int) -> Element? {
        return i < 0 ? nil : i >= count ? nil : self[i]
    }
    // swiftlint:enable identifier_name
}
