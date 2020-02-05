//
//  RootPresenter.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation
import Photos

enum ContentsType {
    case photo
    case video
    
    var directoryName: String {
        switch self {
        case .photo:
            return "photos"
        case .video:
            return "videos"
        }
    }
}

enum SavePathCreationError: Error {
    /// 保存元のファイルが存在しない
    case sourceFileNotExist
    /// 中間ディレクトリの作成失敗
    case failedToCreateIntermediateDirectory
    /// 保存先のPATHにあるファイルの削除失敗
    case failedToRemoveSavedFile

}

final class RootPresenter {
    
    private weak var view: RootView?
    private let router: RootWireframe
    private let interactor: RootUsecase
    
    private var contentsType: ContentsType?

    init(view: RootView, wireframe: RootWireframe, usecase: RootUsecase) {
        self.view = view
        self.router = wireframe
        self.interactor = usecase
    }
}

extension RootPresenter: RootViewPresentation {
    func requestPhotosFetching() {
        self.contentsType = .photo
        interactor.requestPhotoLibraryAuthorization()
    }
    
    func requestVideosFetching() {
        self.contentsType = .video
        interactor.requestPhotoLibraryAuthorization()
    }
}

extension RootPresenter: RootInteractorDelegate {
    
    func repliedAuthorizationStatus(status: PHAuthorizationStatus) {
        switch status {
        case .authorized:
            print("PHAuthorizationStatus is 'authorized'")
            self.fetch()
            
        case .denied:
            print("PHAuthorizationStatus is 'denied'")
        case .notDetermined:
            print("PHAuthorizationStatus is 'notDetermined'")
        case .restricted:
            print("PHAuthorizationStatus is 'restricted'")
        @unknown default:
            fatalError()
        }
    }
    
    private func fetch() {
        guard let contentsType = self.contentsType else {
            assertionFailure("contentsTypeがnil")
            return
        }
        
        switch contentsType {
        case .photo:
            interactor.fetchPhotos()
        case .video:
            interactor.fetchVideos()
        }
    }
    
    func fetchedImageURLs(imageFileURLs: [URL]) {
        
        if imageFileURLs.isEmpty {
            view?.showAlert(title: "エラー", message: "画像が1枚も保存されていません。")
            return
        }
        
        // 直近保存した動画を保存する
        let imageFileURL = imageFileURLs.last!
        
        do {
            let savePath = try self.willSavePath(contentsURL: imageFileURL, contentsType: .photo)
            try self.save(contentsURL: imageFileURL, to: savePath)
            
        } catch SavePathCreationError.sourceFileNotExist {
            view?.showAlert(title: "エラー", message: "対象の画像が見つかりませんでした。\n既に削除されている可能性があります。")
            return
        } catch SavePathCreationError.failedToCreateIntermediateDirectory {
            view?.showAlert(title: "エラー", message: "photosフォルダ作成に失敗しました。")
            return
        } catch SavePathCreationError.failedToRemoveSavedFile {
            view?.showAlert(title: "エラー", message: "既存の同名の画像の削除に失敗しました。")
            return
        } catch {
            view?.showAlert(title: "エラー", message: "画像の保存に失敗しました。")
            return
        }
        view?.showAlert(title: "保存完了", message: "画像の保存に成功しました。")
    }
    
    func fetchedVideoURLs(videoFileURLs: [URL]) {
        if videoFileURLs.isEmpty {
            view?.showAlert(title: "エラー", message: "動画が1件も保存されていません。")
            return
        }
        
        // 直近保存した動画を保存する
        let videoFileURL = videoFileURLs.last!
        
        do {
            let savePath = try self.willSavePath(contentsURL: videoFileURL, contentsType: .video)
            try self.save(contentsURL: videoFileURL, to: savePath)
            
        } catch SavePathCreationError.sourceFileNotExist {
            view?.showAlert(title: "エラー", message: "対象の動画が見つかりませんでした。\n既に削除されている可能性があります。")
            return
        } catch SavePathCreationError.failedToCreateIntermediateDirectory {
            view?.showAlert(title: "エラー", message: "videosフォルダ作成に失敗しました。")
            return
        } catch SavePathCreationError.failedToRemoveSavedFile {
            view?.showAlert(title: "エラー", message: "既存の同名の動画の削除に失敗しました。")
            return
        } catch {
            view?.showAlert(title: "エラー", message: "動画の保存に失敗しました。")
            return
        }
        view?.showAlert(title: "保存完了", message: "動画の保存に成功しました。")
    }
    
    /// DocumentsディレクトリのPATHを取得
    private func documentsDirectoryPath() -> String {
        let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsDir
    }
    
    /// 保存先のPATHを生成
    private func willSavePath(contentsURL: URL, contentsType: ContentsType) throws -> String {
        
        if !FileManager.default.fileExists(atPath: contentsURL.path) {
            // 保存元のコンテンツが存在しない場合
            throw SavePathCreationError.sourceFileNotExist
        }
        
        // URLからファイル名を取得
        let fileName = contentsURL.path.lastPathComponent

        // 保存先のディレクトリが無かったら作成する
        let contentsDirectory = documentsDirectoryPath().appendingPathComponent(contentsType.directoryName)
        do {
            try createContentsDirectory(contentsType: contentsType)
        } catch {
            // SavePathCreationError.failedToCreateIntermediateDirectoryをthrow
            throw error
        }
        
        // 保存先のfull path
        let path = contentsDirectory.appendingPathComponent(fileName)
        
        // 保存先にファイルが存在した場合、削除する
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print(error)
                // 保存先のPATHにあるファイルの削除失敗した場合
                throw SavePathCreationError.failedToRemoveSavedFile
            }
        }
        print("willSavePath", path)
        return path
    }
    
    /// コンテンツ保存用のディレクトリが存在しなければ作成
    private func createContentsDirectory(contentsType: ContentsType) throws {
        let contentsDirectory = documentsDirectoryPath().appendingPathComponent(contentsType.directoryName)
        
        if FileManager.default.fileExists(atPath: contentsDirectory) {
            print("コンテンツ保存用のディレクトリは既に作成済み")
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: contentsDirectory, withIntermediateDirectories: true)
        } catch {
            print(error)
            // ディレクトリの作成失敗した場合
            throw SavePathCreationError.failedToCreateIntermediateDirectory
        }
    }
    
    /// 保存処理を実行
    private func save(contentsURL: URL, to willSavePath: String) throws {
        do {
            let contentsData = try Data(contentsOf: contentsURL)
            // 保存先のPATHを指定し、書き込む
            let saveURL = URL(fileURLWithPath: willSavePath)
            try contentsData.write(to: saveURL)
        } catch {
            print(error)
            throw error
        }
    }
}
