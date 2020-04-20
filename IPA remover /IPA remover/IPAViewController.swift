//
//  ViewController.swift
//  IPA remover
//
//  Created by Slava on 4/11/20.
//  Copyright © 2020 Yaroslav Kopylov. All rights reserved.
//

import Cocoa

class IPAViewController: NSViewController {
    
    private var files: [MetaFiles] = []
    private var filesToRemove: [MetaFiles] = []
    private let remover = Remover()
    private let metadata = MetaData()
    
    @IBOutlet var metaFilesController: NSArrayController!
    @IBOutlet weak var nothingFoundLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var sizeValue: NSTextField!
    
    @IBAction func select(_ sender: NSButton) {
        let index = tableView.row(for: sender)
        let objects = metaFilesController.selectedObjects as? [MetaFiles]
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
            metadata.totalSize -= file.size
            remover.remove(file.path)
            metaFilesController.removeObject(file)
            metadata.files.removeAll(where: {$0.isEnabled == true})
            sizeValue.stringValue = metadata.totalSize.convertToReadebleSize()
            sizeValue.updateLayer()
        }
        filesToRemove.removeAll()
        hideTableViewIfNeeded()
    }
    
    @IBAction func selectDeselectAll(_ sender: Any) {
        let selectedEverything = metadata.files.filter { $0.isEnabled }.count == metadata.files.count
        let enabled = !selectedEverything
        metadata.files.forEach { (file) in
            if !file.isEnabled {
                filesToRemove.append(file)
            } else {
                filesToRemove.removeAll()
            }
        }
        metadata.files.forEach { $0.isEnabled = enabled }
    }
    
    @IBAction func updateTable(_sender: NSButton) {
        guard let objects = metaFilesController.selectedObjects as? [MetaFiles] else { return }
        objects.forEach {metaFilesController.removeObject($0)}
        print(objects)
        metadata.files.removeAll()
        filesToRemove.removeAll()
        metadata.totalSize = 0
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
}

private extension IPAViewController {
    
    func loadData()  {
        getMetadata()
        nothingFoundLabel.isHidden = true
        tableView.isHidden = false
        tableView.allowsColumnResizing = false
        tableView.allowsColumnReordering = false
    }
    
    func getMetadata() {
        metadata.fetchFiles { (files) in
            self.sizeValue.stringValue = self.metadata.totalSize.convertToReadebleSize()
            self.metaFilesController.add(contentsOf: files)
            self.hideTableViewIfNeeded()
        }
    }
    
    func hideTableViewIfNeeded() {
        guard let content = metaFilesController.content as? [MetaFiles] else { return }
        if content.isEmpty {
            tableView.isHidden = true
            nothingFoundLabel.isHidden = false
        }
    }
}

