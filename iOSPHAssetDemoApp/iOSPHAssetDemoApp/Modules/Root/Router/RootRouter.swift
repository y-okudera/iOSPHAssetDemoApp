//
//  RootRouter.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class RootRouter {
    
    private weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "RootViewController", bundle: .main)
        let view = storyboard
            .instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        
        let router = RootRouter(viewController: view)
        let interactor = RootInteractor()
        let presenter = RootPresenter(view: view, wireframe: router, usecase: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}

/// 画面遷移を実装する
extension RootRouter: RootWireframe {
    func showRootScreen() {
        let next = RootRouter.assembleModules()
        self.viewController?.navigationController?.pushViewController(next, animated: true)
    }
}
