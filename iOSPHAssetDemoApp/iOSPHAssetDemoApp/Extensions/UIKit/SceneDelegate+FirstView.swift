//
//  SceneDelegate+FirstView.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

@available(iOS 13, *)
extension SceneDelegate {
    
    /// アプリ起動後、最初に表示する画面を設定する
    ///
    /// - Parameters:
    ///   - scene: UIScene
    ///   - viewController: 最初に表示する画面のViewController
    ///   - includeNavigationController: NavigationControllerを含めるかどうか
    func firstView(scene: UIScene, viewController: UIViewController, includeNavigationController: Bool = false) {
        
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        
        if includeNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            window.rootViewController = navigationController
        } else {
            window.rootViewController = viewController
        }
    }
}
