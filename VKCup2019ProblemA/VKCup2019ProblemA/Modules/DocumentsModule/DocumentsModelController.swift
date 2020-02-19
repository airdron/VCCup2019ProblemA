//
//  DocumentsModelController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsModelControllerOutput: class {
    
    func didReceiveInitial(viewModels: [DocumentViewModel])
    func didReceive(error: Error)
}

class DocumentsModelController {
    
    weak var output: DocumentsModelControllerOutput?
    
    private let pageCount = 50
    private var pageOffset = 0
    private var isLoading = false
    private var canLoadNextPage = true
        
    private let documentsService: DocumentsService
    private let viewModelConverter: DocumentsViewModelConverter
    
    private let dispatchGroup = DispatchGroup()
    private let loadingQueue = DispatchQueue(label: "vkcup.document.serial.queue", qos: .userInitiated)
    
    init(viewModelConverter: DocumentsViewModelConverter,
         documentsService: DocumentsService) {
        self.documentsService = documentsService
        self.viewModelConverter = viewModelConverter
    }
    
    func fetchDocuments() {
        loadingQueue.async {
            self.asyncFetchingDocuments()
        }
    }
    
    private func asyncFetchingDocuments() {
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
    
    private func documentStartLoading() {
        isLoading = true
    }
    
    private func documentsFinishLoading(with items: [DocumentItem]) {
        DispatchQueue.main.sync {
            self.output?.didReceiveInitial(viewModels: items.map(self.viewModelConverter.convert))
        }
        isLoading = false
        pageOffset += pageCount
        canLoadNextPage = items.count == pageCount
    }
    
    private func documentFinishLoading(with error: Error) {
        isLoading = false
        
        DispatchQueue.main.sync {
            self.output?.didReceive(error: error)
        }
    }
}
