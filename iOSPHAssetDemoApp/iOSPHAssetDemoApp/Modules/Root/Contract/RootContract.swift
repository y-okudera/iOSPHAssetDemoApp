//
//  RootContract.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import Photos

// MARK: - View

/// From presenter
protocol RootView: class {
    var presenter: RootViewPresentation! { get }
    func showAlert(title: String, message: String)
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
    func repliedAuthorizationStatus(status: PHAuthorizationStatus)
    func fetchedImageURLs(imageFileURLs: [URL])
    func fetchedVideoURLs(videoFileURLs: [URL])
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
