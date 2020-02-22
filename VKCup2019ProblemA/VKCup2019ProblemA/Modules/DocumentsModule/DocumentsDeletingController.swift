//
//  DocumentsDeletingController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsDeletingControllerOutput: class {
    
    func documentsDeletingControllerDidDeleteDocument(at index: Int)
    func documentsDeletingControllerDidReceive(error: Error)
}

class DocumentsDeletingController {
    
    weak var output: DocumentsDeletingControllerOutput?
    
    private let documentsService: DocumentDeleting
    
    private let loadingQueue: DispatchQueue
    
    init(documentsService: DocumentDeleting,
         loadingQueue: DispatchQueue) {
        self.documentsService = documentsService
        self.loadingQueue = loadingQueue
    }
    
    func deleteDocument(id: Int, index: Int) {
        loadingQueue.async {
            self.asyncDeleteDocument(id: id, index: index)
        }
    }
}

private extension DocumentsDeletingController {
    
    func asyncDeleteDocument(id: Int, index: Int) {
        documentsService.delete(documentBy: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deletionSuccess):
                    if deletionSuccess {
                        self?.output?.documentsDeletingControllerDidDeleteDocument(at: index)
                    } else {
                        self?.output?.documentsDeletingControllerDidReceive(error: VKDefaultError.default)
                    }
                case .failure(let error):
                    self?.output?.documentsDeletingControllerDidReceive(error: error)
                }
            }
        }
    }
}
