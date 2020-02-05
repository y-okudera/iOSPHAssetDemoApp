//
//  String+Path.swift
//  iOSPHAssetDemoApp
//
//  Created by Yuki Okudera on 2020/02/05.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    /// 拡張子を取得する
    var pathExtension: String {
        return ns.pathExtension
    }
    
    /// 拡張子を削除する
    var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
}
