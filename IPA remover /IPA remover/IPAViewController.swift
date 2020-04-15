//
//  ViewController.swift
//  IPA remover
//
//  Created by Slava on 4/11/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Cocoa

class IPAViewController: NSViewController {
    
    private var metadataQuery: NSMetadataQuery!
    private var files: [MetaFiles] = []
    private var filesToRemove: [MetaFiles] = []
    
    private let remover = Remover()
    
    @IBAction func updateTable(_sender: NSButton) {
        guard let objects = metaFiles.selectedObjects as? [MetaFiles] else { return }
        objects.forEach {metaFiles.removeObject($0)}
        print(objects)
        files.removeAll()
        filesToRemove.removeAll()
        loadData()
    }
    
    @IBOutlet var metaFiles: NSArrayController!
    @IBOutlet weak var nothingFoundLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBAction func select(_ sender: NSButton) {
        let index = tableView.row(for: sender)
        let objects = metaFiles.selectedObjects as? [MetaFiles]
        guard let files = objects else { return }
        let file = files[index]
        
        switch sender.state {
        case .on:
            file.isEnabled = true
            filesToRemove.append(file)
        default:
            file.isEnabled = false
            filesToRemove.removeLast()
        }
    }
    
    
    @IBAction func removeAll(_ sender: NSButton) {
        let container = Array(Set(filesToRemove))
        container.forEach { (file) in
            remover.remove(file.path)
            metaFiles.removeObject(file)
            files.removeAll(where: {$0.isEnabled == true})
        }
        filesToRemove.removeAll()
        hideTableViewIfNeeded()
    }
    
    @IBAction func selectDeselectAll(_ sender: Any) {
        let selectedEverything = files.filter { $0.isEnabled }.count == files.count
        let enabled = !selectedEverything
        files.forEach { (file) in
            if !file.isEnabled {
                filesToRemove.append(file)
            } else {
                filesToRemove.removeAll()
            }
        }
        files.forEach { $0.isEnabled = enabled }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

private extension IPAViewController {
    
    func loadData()  {
        tableView.allowsMultipleSelection = true
        getMetadata()
        nothingFoundLabel.isHidden = true
        tableView.isHidden = false
    }
    
    func getMetadata() {
        NotificationCenter.default.addObserver(self, selector: #selector(initalGatherComplete (notification:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering,  object: nil)
        metadataQuery = NSMetadataQuery()
        metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
        metadataQuery.predicate = NSPredicate(format: "%K ENDSWITH 'com.apple.itunes.ipa'", NSMetadataItemContentTypeTreeKey)
        metadataQuery.start()
    }
    
    @objc func initalGatherComplete(notification: NSNotification) {
        metadataQuery.stop()
        
        let resultCounter = metadataQuery.resultCount
        print(resultCounter)
        guard let results = metadataQuery.results as? [NSMetadataItem] else { return }
        for item in results {
            guard let path = item.value(forAttribute: NSMetadataItemPathKey) as? String else { return }
            guard let nsNumber = item.value(forAttribute: NSMetadataItemFSSizeKey) as? NSNumber else { return }
            let size = Units(bytes: nsNumber.int64Value).getReadableUnit()
            files.append(MetaFiles(path: path, size: size, isEnabled: false))
        }
        print(files)
        metaFiles.add(contentsOf: files)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        hideTableViewIfNeeded()
    }
    
    func hideTableViewIfNeeded() {
        guard let content = metaFiles.content as? [MetaFiles] else { return }
        if content.isEmpty {
            tableView.isHidden = true
            nothingFoundLabel.isHidden = false
        }
    }
}



