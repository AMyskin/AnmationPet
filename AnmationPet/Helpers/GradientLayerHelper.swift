//
//  Created by Oleg Bakharev on 14.05.2021.
//

import UIKit

class GradientLayerHelper {
    enum Direction {
        case fromTopToBottom
        case fromLeftToRight
        case fromTopLeftToBottomRight
        case fromBottomLeftToTopRight
    }

    static func gradientLayer(colors: [UIColor], direction: Direction) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = colors.map { $0.cgColor }
        switch direction {
        case .fromTopToBottom:
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 1)
        case .fromLeftToRight:
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        case .fromTopLeftToBottomRight:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 1)
        case .fromBottomLeftToTopRight:
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        return layer
    }
}
