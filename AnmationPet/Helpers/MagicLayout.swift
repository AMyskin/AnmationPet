//
//  MagicLayout.swift
//  VTBUIKit
//
//  Created by Milkhail Babushkin on 06.11.2019.
//  Copyright © 2019 ВТБ. All rights reserved.
//

import UIKit

// swiftlint:disable all
public extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func pinEdgesToSuperviewEdges(withOffset offset: CGFloat) {
        self.pinEdgesToSuperviewEdges(top: offset, left: offset, bottom: offset, right: offset)
    }

    func pinEdgesToSuperviewEdges(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        leftAnchor ~= superview.leftAnchor + left
        rightAnchor ~= superview.rightAnchor - right
        topAnchor ~= superview.topAnchor + top
        bottomAnchor ~= superview.bottomAnchor - bottom
    }

    func pinExcludingEdgesToSuperviewEdges(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        if let value = top {
            topAnchor ~= superview.topAnchor + value
        }
        if let value = left {
            leftAnchor ~= superview.leftAnchor + value
        }
        if let value = bottom {
            bottomAnchor ~= superview.bottomAnchor - value
        }
        if let value = right {
            rightAnchor ~= superview.rightAnchor - value
        }
    }
    
    func pinToCenterSuperview(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("There is no superview")
        }
        
        centerXAnchor ~= superview.centerXAnchor + xOffset
        centerYAnchor ~= superview.centerYAnchor + yOffset
    }

    enum PinnedSide {
        case top
        case left
        case right
        case bottom
    }

    func pinEdgesToSuperviewEdges(excluding side: PinnedSide) {
        switch side {
        case .top:
            self.pinToSuperview([.left, .right, .bottom])
        case .left:
            self.pinToSuperview([.top, .right, .bottom])
        case .right:
            self.pinToSuperview([.top, .left, .bottom])
        case .bottom:
            self.pinToSuperview([.top, .left, .right])
        }
    }

    func pinToSuperview(_ sides: [PinnedSide]) {
        guard let superview = superview, !sides.isEmpty else {
            fatalError("There is no superview or sides")
        }

        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= superview.topAnchor
            case .right:
                rightAnchor ~= superview.rightAnchor
            case .left:
                leftAnchor ~= superview.leftAnchor
            case .bottom:
                bottomAnchor ~= superview.bottomAnchor
            }
        }
    }

    func pin(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        pin(to: view, edgesInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    func pinExcluding(to view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            self.translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        if let value = top {
            topAnchor ~= view.topAnchor + value
        }
        if let value = left {
            leftAnchor ~= view.leftAnchor + value
        }
        if let value = bottom {
            bottomAnchor ~= view.bottomAnchor - value
        }
        if let value = right {
            rightAnchor ~= view.rightAnchor - value
        }
    }

    func pin(to view: UIView, edgesInsets: UIEdgeInsets) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            self.translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        topAnchor ~= view.topAnchor + edgesInsets.top
        rightAnchor ~= view.rightAnchor - edgesInsets.right
        leftAnchor ~= view.leftAnchor + edgesInsets.left
        bottomAnchor ~= view.bottomAnchor - edgesInsets.bottom
    }

    func pin(as view: UIView, using sides: [PinnedSide]) {
        if view.translatesAutoresizingMaskIntoConstraints != false &&
            self.translatesAutoresizingMaskIntoConstraints != false {
            fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
        }
        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= view.topAnchor
            case .right:
                rightAnchor ~= view.rightAnchor
            case .left:
                leftAnchor ~= view.leftAnchor
            case .bottom:
                bottomAnchor ~= view.bottomAnchor
            }
        }
    }
    
    func pin(to layoutGuide: UILayoutGuide, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        pin(to: layoutGuide, edgesInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    func pinExcluding(to layoutGuide: UILayoutGuide, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        if let value = top {
            topAnchor ~= layoutGuide.topAnchor + value
        }
        if let value = left {
            leftAnchor ~= layoutGuide.leftAnchor + value
        }
        if let value = bottom {
            bottomAnchor ~= layoutGuide.bottomAnchor - value
        }
        if let value = right {
            rightAnchor ~= layoutGuide.rightAnchor - value
        }
    }

    func pin(to layoutGuide: UILayoutGuide, edgesInsets: UIEdgeInsets) {
        topAnchor ~= layoutGuide.topAnchor + edgesInsets.top
        rightAnchor ~= layoutGuide.rightAnchor - edgesInsets.right
        leftAnchor ~= layoutGuide.leftAnchor + edgesInsets.left
        bottomAnchor ~= layoutGuide.bottomAnchor - edgesInsets.bottom
    }

    func pin(as layoutGuide: UILayoutGuide, using sides: [PinnedSide]) {
        sides.forEach { side in
            switch side {
            case .top:
                topAnchor ~= layoutGuide.topAnchor
            case .right:
                rightAnchor ~= layoutGuide.rightAnchor
            case .left:
                leftAnchor ~= layoutGuide.leftAnchor
            case .bottom:
                bottomAnchor ~= layoutGuide.bottomAnchor
            }
        }
    }
}

public struct ConstraintAttribute<T: AnyObject> {
    public let anchor: NSLayoutAnchor<T>
    public let const: CGFloat
    
    public init(anchor: NSLayoutAnchor<T>, const: CGFloat) {
        self.anchor = anchor
        self.const = const
    }
}

public struct LayoutGuideAttribute {
    public let guide: UILayoutSupport
    public let const: CGFloat
    
    public init(guide: UILayoutSupport, const: CGFloat) {
        self.guide = guide
        self.const = const
    }
}

public struct DimensionConstraintAttribute {
    public var anchor: NSLayoutDimension
    public var multiplier: CGFloat
    public var const: CGFloat
    
    public init(anchor: NSLayoutDimension, multiplier: CGFloat, const: CGFloat = 0.0) {
        self.anchor = anchor
        self.multiplier = multiplier
        self.const = const
    }
}

extension DimensionConstraintAttribute: Equatable {
    public static func == (lhs: DimensionConstraintAttribute, rhs: DimensionConstraintAttribute) -> Bool {
        lhs.anchor === rhs.anchor &&
        lhs.multiplier == rhs.multiplier &&
        lhs.const == rhs.const
    }
}

public func * (lhs: NSLayoutDimension, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs, multiplier: rhs)
}

public func * (lhs: CGFloat, rhs: NSLayoutDimension) -> DimensionConstraintAttribute {
    rhs * lhs
}

public func / (lhs: NSLayoutDimension, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs, multiplier: 1) / rhs
}

public func * (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier * rhs, const: lhs.const * rhs)
}

public func * (lhs: CGFloat, rhs: DimensionConstraintAttribute) -> DimensionConstraintAttribute {
    rhs * lhs
}

public func / (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier / rhs, const: lhs.const / rhs)
}

public func + (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier, const: lhs.const + rhs)
}

public func + (lhs: CGFloat, rhs: DimensionConstraintAttribute) -> DimensionConstraintAttribute {
    rhs + lhs
}

public func - (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> DimensionConstraintAttribute {
    DimensionConstraintAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier, const: lhs.const - rhs)
}

public func - (lhs: CGFloat, rhs: DimensionConstraintAttribute) -> DimensionConstraintAttribute {
    lhs + rhs * -1
}

public func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

public func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

public func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

public func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

// ~= is used instead of == because Swift can't overload == for NSObject subclass
@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: DimensionConstraintAttribute, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    rhs ~= lhs
}

@discardableResult
public func ~= (lhs: DimensionConstraintAttribute, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    lhs.anchor ~= (rhs - lhs.const) / lhs.multiplier
}

@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, multiplier: rhs.multiplier, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: DimensionConstraintAttribute, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    let constraint = rhs.constraint(greaterThanOrEqualTo: lhs.anchor, multiplier: lhs.multiplier, constant: lhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: DimensionConstraintAttribute, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    let factor = (rhs - lhs.const) / lhs.multiplier
    return lhs.multiplier > 0 ? lhs.anchor <= factor : factor <= lhs.anchor
}

@discardableResult
public func <= (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> NSLayoutConstraint {
    let value = (rhs - lhs.const) / lhs.multiplier
    return lhs.multiplier > 0 ? lhs.anchor <= value : value <= lhs.anchor
}

@discardableResult
public func <= (lhs: CGFloat, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    rhs * -1 <= -lhs
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: CGFloat, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    let constraint = rhs.constraint(greaterThanOrEqualToConstant: lhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    rhs <= lhs
}

@discardableResult
public func >= (lhs: DimensionConstraintAttribute, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    rhs <= lhs
}

@discardableResult
public func >= (lhs: DimensionConstraintAttribute, rhs: DimensionConstraintAttribute) -> NSLayoutConstraint {
    rhs <= lhs
}

@discardableResult
public func >= (lhs: DimensionConstraintAttribute, rhs: CGFloat) -> NSLayoutConstraint {
    rhs <= lhs
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    rhs <= lhs
}
