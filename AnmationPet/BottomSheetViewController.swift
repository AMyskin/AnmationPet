//
//  BottomSheetViewController.swift
//  AnmationPet
//
//  Created by Alexander Myskin on 16.11.2022.
//

import UIKit

class BottomSheetViewController: UIViewController {

    var hideStatusBar: Bool = false {
         didSet {
             setNeedsStatusBarAppearanceUpdate()
         }
     }

     override var prefersStatusBarHidden: Bool {
            return hideStatusBar
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.hideStatusBar = true

        print("BottomSheetViewController")

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("BottomSheetViewController viewWillAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("BottomSheetViewController viewWillLayoutSubviews")
    }
}
