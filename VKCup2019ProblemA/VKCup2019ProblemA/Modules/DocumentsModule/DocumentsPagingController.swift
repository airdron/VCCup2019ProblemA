//
//  DocumentsPagingController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsPagingControllerOutput: class {
    
    func documentsPagingControllerDidReceive(viewModels: [DocumentViewModel])
    func documentsPagingControllerDidReceive(error: Error)
}

class DocumentsPagingController {
    
    weak var output: DocumentsPagingControllerOutput?
    
    private let pageCount = 50
    private var pageOffset = 0
    private var isLoading = false
    private var canLoadNextPage = true
        
    private let documentsService: DocumentsLoading
    private let viewModelConverter: DocumentsViewModelConverter
    
    private let loadingQueue: DispatchQueue
    
    init(viewModelConverter: DocumentsViewModelConverter,
         documentsService: DocumentsLoading,
         loadingQueue: DispatchQueue) {
        self.documentsService = documentsService
        self.viewModelConverter = viewModelConverter
        self.loadingQueue = loadingQueue
    }
    
    func fetchDocuments() {
        loadingQueue.async {
            self.asyncFetchingDocuments()
        }
    }
}

// MARK: - pagination
private extension DocumentsPagingController {
    
    func asyncFetchingDocuments() {
        guard canLoadNextPage, !isLoading else { return }

        documentStartLoading()
        
        documentsService.fetchDocuments(
            count: pageCount,
            offset: pageOffset
        ) { [weak self] result in
            self?.loadingQueue.async {
                switch result {
                case .success(let documents):
                    guard let self = self else { return }
                    
                    let items = documents.response.items
                    self.documentsFinishLoading(with: items)
                    
                case .failure(let error):
                    self?.documentFinishLoading(with: error)
                }
            }
        }
    }
    
    func documentStartLoading() {
        isLoading = true
    }
    
    func documentsFinishLoading(with items: [DocumentItem]) {
        DispatchQueue.main.sync {
            self.output?.documentsPagingControllerDidReceive(viewModels: items.map(self.viewModelConverter.convert))
        }
        isLoading = false
        pageOffset += pageCount
        canLoadNextPage = items.count == pageCount
    }
    
    func documentFinishLoading(with error: Error) {
        isLoading = false
        
        DispatchQueue.main.sync {
            self.output?.documentsPagingControllerDidReceive(error: error)
        }
    }
}
