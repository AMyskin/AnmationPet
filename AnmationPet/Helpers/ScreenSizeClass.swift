//
//  Created by Oleg Bakharev on 14.05.2021.
//

import UIKit

public class ScreenSizeClass {
    enum SizeClass: CGFloat {
        case small = 568 // iPhone 5, 5s, SE
        case medium = 667 // iPhone 6, 7, 8, SE20
        case large = 736 // iPhone 6+, 7+, 8+
        case extraLarge = 812 // iPhone X, Xs, 11, 12
        case xxl = 896 // iPhone Xr, Xs Max, 11 Max, 12 Max
        case xxxl = 1024 // iPads
    }

    static let sizeClass: SizeClass = {
        switch UIScreen.main.bounds.size.height {
        case 0..<600:
            return .small
        case 600..<700:
            return .medium
        case 700..<770:
            return .large
        case 770..<850:
            return .extraLarge
        case 850..<950:
            return .xxl
        default:
            return .xxxl
        }
    }()
}
