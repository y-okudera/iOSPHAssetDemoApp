//
//  RootPresenter.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import UIKit

final class RootPresenter {
    
    private weak var view: RootView?
    private let router: RootWireframe
    private let interactor: RootUsecase

    init(view: RootView, wireframe: RootWireframe, usecase: RootUsecase) {
        self.view = view
        self.router = wireframe
        self.interactor = usecase
    }
}

extension RootPresenter: RootViewPresentation {
    func requestPhotosFetching() {
        self.interactor.fetchPhotos()
    }
    
    func requestVideosFetching() {
        self.interactor.fetchVideos()
    }
}

extension RootPresenter: RootInteractorDelegate {
    func fetchedImages(imageData: [Data]) {
        
    }
    
    func fetchedVideos(videoData: [Data]) {
        
    }
}
