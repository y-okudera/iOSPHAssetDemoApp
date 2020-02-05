//
//  RootContract.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - View

/// From presenter
protocol RootView: class {
    var presenter: RootViewPresentation! { get }
    func reloadViews()
}

// MARK: - Presenter


/// From view
protocol RootViewPresentation {
    init(view: RootView, wireframe: RootWireframe, usecase: RootUsecase)
    func requestPhotosFetching()
    func requestVideosFetching()
}

/// From interactor
protocol RootInteractorDelegate: class {
    func fetchedImages(imageData: [Data])
    func fetchedVideos(videoData: [Data])
}

// MARK: - Interactor

/// From presenter
protocol RootUsecase {
    var output: RootInteractorDelegate? { get }
    func requestPhotoLibraryAuthorization()
    func fetchPhotos()
    func fetchVideos()
}

// MARK: - Router

/// From presenter
protocol RootWireframe {
    func showRootScreen()
}
