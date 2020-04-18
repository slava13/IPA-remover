//
//  MetaData.swift
//  IPA remover
//
//  Created by Slava on 4/19/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Foundation

class MetaData: FileManagerInjectable {
    
    public var totalSize: Int64 = 0
    public var files: [MetaFiles] = []
    
    private var metadataQuery: NSMetadataQuery!
    private var completionHandler: ([MetaFiles]) -> Void = {_ in }
    
    public func fetchFiles(_ completion: @escaping ([MetaFiles]) -> Void) {
        completionHandler = completion
        performFakeAccessToFDA()
        getMetadata()
    }
    
    private func getMetadata() {
        NotificationCenter.default.addObserver(self, selector: #selector(initalGatherComplete (notification:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        metadataQuery = NSMetadataQuery()
        metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
        metadataQuery.predicate = NSPredicate(format: "%K ENDSWITH 'com.apple.itunes.ipa'", NSMetadataItemContentTypeTreeKey)
        metadataQuery.start()
    }
    
    @objc func initalGatherComplete(notification: NSNotification) {
        metadataQuery.stop()
        
        guard let results = metadataQuery.results as? [NSMetadataItem] else { return }
        for item in results {
            guard let path = item.value(forAttribute: NSMetadataItemPathKey) as? String else { return }
            guard let nsNumber = item.value(forAttribute: NSMetadataItemFSSizeKey) as? NSNumber else { return }
            if !path.isGitRepository() {
                totalSize += nsNumber.int64Value
                files.append(MetaFiles(path: path, size: nsNumber.int64Value, isEnabled: false))
            }
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        completionHandler(files)
    }
    
    private func performFakeAccessToFDA() {
        let desktop = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .allDomainsMask, true).first! as String
        let downloads = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .allDomainsMask, true).first! as String
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first! as String
        let paths = [desktop, downloads, documents]
        paths.forEach { fileManager.contents(atPath: $0) }
    }
}
