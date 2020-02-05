//
//  RootViewController.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    var presenter: RootViewPresentation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension RootViewController: RootView {
    func reloadViews() {
        
    }
}
