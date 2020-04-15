//
//  Remover.swift
//  IPA remover
//
//  Created by Slava on 4/14/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

class Remover: FileManagerInjectable {
    
    public func remove(_ path: String) {
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
