//
//  StringExtension.swift
//  IPA remover
//
//  Created by Slava on 4/18/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

public extension String {
    
    func isGitRepository() -> Bool {
        let fileManager = FileManager.default
        guard var components = fileManager.componentsToDisplay(forPath: self) else { return false}
        components.removeFirst()
        components.removeLast()
        let iteratorOfComponents = components
        for _ in iteratorOfComponents {
            let path = "/\(components.joined(separator: "/"))/"
            print(path)
            if fileManager.fileExists(atPath: path + ".git") {
                print("exists")
                return true
            } else {
                print("doesnt")
                components.removeLast()
            }
        }
        return false
    }
}
