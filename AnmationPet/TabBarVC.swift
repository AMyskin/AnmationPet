//
//  TabBarVC.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 17.11.2022.
//

import Foundation
import UIKit

final class TabBarVC: UITabBarController {

    private enum TabBarItem: Int {
        case feed
        case profile
        case next2
        var title: String {
            switch self {
            case .feed:
                return "Лента"
            case .profile:
                return "Профиль"
            case .next2:
                return "Next"
            }
        }
        var iconName: String {
            switch self {
            case .feed:
                return "house"
            case .profile:
                return "person.crop.circle"
            case .next2:
                return "house"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setTabBarApperance()
    }

    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.feed, .profile, .next2]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .feed:
                let feedViewController = SecondViewController()
                return self.wrappedInNavigationController(with: feedViewController, title: $0.title)
            case .profile:
                let profileViewController = BottomSheetViewController()
                return self.wrappedInNavigationController(with: profileViewController, title: $0.title)
            case .next2:
                let feedViewController = ViewController()
                return self.wrappedInNavigationController(with: feedViewController, title: $0.title)
            }
        }
        self.viewControllers?.enumerated().forEach {
            print(dataSource[$0].iconName)
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }

    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }

    private func setTabBarApperance() {
        let onX: CGFloat = 16
        let onY: CGFloat = 16
        let width = tabBar.bounds.width - onX * 2
        let height = tabBar.bounds.height + onY * 2

        let customLayer = CAShapeLayer()

        let path = UIBezierPath(
            roundedRect: CGRect(x: onX, y: tabBar.bounds.minY - onY, width: width, height: height),
            cornerRadius: height / 2)

        customLayer.path = path.cgPath

        tabBar.layer.insertSublayer(customLayer, at: 0)

//        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered

        customLayer.fillColor = #colorLiteral(red: 0.195315659, green: 0.9832403064, blue: 0.7704389691, alpha: 0.3946088576)
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 0.3946088576)



    }
}
