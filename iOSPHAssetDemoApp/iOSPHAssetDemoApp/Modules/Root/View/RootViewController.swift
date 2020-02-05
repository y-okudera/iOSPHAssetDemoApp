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
    private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.activityIndicator?.startAnimating()
        
        // 直近の動画を1件Documents/videosに保存する
        presenter.requestVideosFetching()
        
        // 直近の画像を1枚Documents/photosに保存する
//        presenter.requestPhotosFetching()
    }
    
    private func setupActivityIndicator() {
        self.activityIndicator = .init(style: .gray)
        self.activityIndicator!.center = self.view.center
        self.activityIndicator!.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator!)
    }
}

extension RootViewController: RootView {
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else { return }
            self.activityIndicator?.stopAnimating()
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
