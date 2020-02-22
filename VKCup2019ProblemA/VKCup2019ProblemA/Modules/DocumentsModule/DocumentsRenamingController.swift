//
//  DocumentsRenamingController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsRenamingControllerOutput: class {
    
    func documentsRenamingControllerDidRenameDocument(viewModel: DocumentViewModel, at index: Int)
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
    
    func rename(documentItem: DocumentItem, newFileName: String, index: Int) {
        loadingQueue.async {
            self.asyncRenameDocument(documentItem: documentItem, newFileName: newFileName, index: index)
        }
    }
}

private extension DocumentsRenamingController {
    
    func asyncRenameDocument(documentItem: DocumentItem, newFileName: String, index: Int) {
        documentsService.rename(documentBy: documentItem.id, title: newFileName) { [weak self] result in
            self?.loadingQueue.async {
                switch result {
                case .success(let deletionSuccess):
                    self?.documentFinishRenaming(with: deletionSuccess,
                                                 index: index,
                                                 documentItem: documentItem,
                                                 newFileName: newFileName)
                case .failure(let error):
                    self?.documentFinishRenaming(with: error)
                }
            }
        }
    }
    
    func documentFinishRenaming(with success: Bool,
                                index: Int,
                                documentItem: DocumentItem,
                                newFileName: String) {
        
        guard success else {
            self.output?.documentsRenamingControllerDidReceive(error: VKDefaultError.default)
            return
        }
        
        let updatedViewModel = self.viewModelConverter.convert(documentItem: documentItem.updated(with: newFileName))
        
        DispatchQueue.main.sync {
            self.output?.documentsRenamingControllerDidRenameDocument(viewModel: updatedViewModel, at: index)
        }
    }
    
    func documentFinishRenaming(with error: Error) {
        DispatchQueue.main.sync {
            self.output?.documentsRenamingControllerDidReceive(error: error)
        }
    }
}
