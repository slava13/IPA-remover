//
//  SizeToStringTransformer.swift
//  IPA remover
//
//  Created by Iaroslav Kopylov on 16/04/2020.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Cocoa

@objc (TransformerNSNumberToString)
class TransformerNSNumberToString: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { //What do I transform
        return NSNumber.self
    }
    
    override class func allowsReverseTransformation() -> Bool { //Can I transform back?
        return true

    }
    override func transformedValue(_ value: Any?) -> Any? {
        guard let type = value as? NSNumber else { return nil }
        return Int64(truncating: type).convertToReadebleSize()
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
                guard let type = value as? NSString else { return nil }
        return NSNumber(value: type.doubleValue)
    }
}
