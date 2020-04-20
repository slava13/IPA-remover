//
//  SizeExtension.swift
//  IPA remover
//
//  Created by Slava on 4/18/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

public extension Int64 {
    
    func convertToReadebleSize() -> String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}
