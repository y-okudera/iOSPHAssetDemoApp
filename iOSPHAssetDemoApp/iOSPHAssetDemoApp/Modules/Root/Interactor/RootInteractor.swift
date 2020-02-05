//
//  RootInteractor.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Photos

final class RootInteractor {
    weak var output: RootInteractorDelegate?
}

extension RootInteractor: RootUsecase {
    
    func requestPhotoLibraryAuthorization() {
        
    }
    
    func fetchPhotos() {
        
    }
    
    func fetchVideos() {
        
    }
}
