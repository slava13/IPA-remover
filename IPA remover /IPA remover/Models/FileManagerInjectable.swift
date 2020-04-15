//
//  FileManager.swift
//  IPA remover
//
//  Created by Slava on 4/14/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

public protocol FileManagerInjectable {
    
    var fileManager: FileManager { get }
}

public extension FileManagerInjectable {
    
    var fileManager: FileManager { return FileManagerInjector.fileManager }
}

public struct FileManagerInjector {
    
    public static let fileManager: FileManager = FileManager.default
}
