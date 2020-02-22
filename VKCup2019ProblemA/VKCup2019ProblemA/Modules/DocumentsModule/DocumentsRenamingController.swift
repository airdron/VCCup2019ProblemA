//
//  DocumentsRenamingController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsRenamingControllerOutput: class {
    
    func documentsRenamingControllerDidDeleteDocument(at index: Int)
    func documentsRenamingControllerDidReceive(error: Error)
}

class DocumentsRenamingController {
    
    weak var output: DocumentsRenamingControllerOutput?
    
    private let documentsService: DocumentRenaming
    private let viewModelConverter: DocumentsViewModelConverter
    
    private let loadingQueue: DispatchQueue
    
    init(viewModelConverter: DocumentsViewModelConverter,
         documentsService: DocumentRenaming,
         loadingQueue: DispatchQueue) {
        self.documentsService = documentsService
        self.viewModelConverter = viewModelConverter
        self.loadingQueue = loadingQueue
    }
    
    func rename(id: Int, title: String, index: Int) {
        loadingQueue.async {
            self.asyncRenameDocument(id: id, title: title, index: index)
        }
    }
}

private extension DocumentsRenamingController {
    
    func asyncRenameDocument(id: Int, title: String, index: Int) {
        documentsService.rename(documentBy: id, title: title) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deletionSuccess):
                    if deletionSuccess {
                        self?.output?.documentsRenamingControllerDidDeleteDocument(at: index)
                    } else {
                        // do nothig ?
                    }
                case .failure(let error):
                    self?.output?.documentsRenamingControllerDidReceive(error: error)
                }
            }
        }
    }
}
