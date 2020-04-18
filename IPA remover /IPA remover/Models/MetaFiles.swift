//
//  Files.swift
//  IPA remover
//
//  Created by Slava on 4/11/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

class MetaFiles: NSObject {
    
    @objc var path: String
    @objc var size: Int64
    @objc dynamic var isEnabled: Bool
    
    init(path: String, size: Int64, isEnabled: Bool) {
        self.path = path
        self.size = size
        self.isEnabled = isEnabled
    }
}
