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
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let `self` = self else {
                return
            }
            self.output?.repliedAuthorizationStatus(status: status)
        }
    }
    
    func fetchPhotos() {
        
        DispatchQueue.global().async {
            var fileURLs = [URL]()
            // 写真のfileURLを取得する
            PHAsset.fetchAssets(with: .image, options: nil).enumerateObjects({ asset, _, _ in
                let resources = PHAssetResource.assetResources(for: asset)
                if let resource = resources.first, let fileURL = resource.value(forKey: "fileURL") as? URL {
                    fileURLs.append(fileURL)
                }
            })
            
            // ログ出力
            #if DEBUG
            print("写真の枚数", fileURLs.count)
            fileURLs.forEach {
                print("fileURL =", $0)
            }
            #endif
            
            self.output?.fetchedImageURLs(imageFileURLs: fileURLs)
        }
    }
    
    func fetchVideos() {
        
        DispatchQueue.global().async {
            var fileURLs = [URL]()
            // 動画のfileURLを取得する
            PHAsset.fetchAssets(with: .video, options: nil).enumerateObjects({ asset, _, _ in
                let resources = PHAssetResource.assetResources(for: asset)
                if let resource = resources.first, let fileURL = resource.value(forKey: "fileURL") as? URL {
                    fileURLs.append(fileURL)
                }
            })
            
            // ログ出力
            #if DEBUG
            print("ビデオの件数", fileURLs.count)
            fileURLs.forEach {
                print("fileURL =", $0)
            }
            #endif
            
            self.output?.fetchedVideoURLs(videoFileURLs: fileURLs)
        }
    }
}
