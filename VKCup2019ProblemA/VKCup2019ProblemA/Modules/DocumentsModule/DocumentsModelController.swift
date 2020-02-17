//
//  DocumentsModelController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

protocol DocumentsModelControllerOutput: class {
    
    func didReceiveInitial(viewModels: [DocumentViewModel])
    func didReceive(error: Error)
}

class DocumentsModelController {
    
    weak var output: DocumentsModelControllerOutput?
    
    private let pageCount = 20
    private var pageOffset = 0
    private var isLoading = false
    private var canLoadNextPage = true
        
    private let documentsService: DocumentsService
    private let viewModelConverter: DocumentsViewModelConverter
    
    init(viewModelConverter: DocumentsViewModelConverter,
         documentsService: DocumentsService) {
        self.documentsService = documentsService
        self.viewModelConverter = viewModelConverter
    }
    
    func fetchInitialDocuments() {
        documentsService.fetchDocuments(
            count: pageCount,
            offset: 0
        ) { [weak self] result in
            switch result {
            case .success(let documents):
                guard let self = self else { return }
                let items = documents.response.items
                self.output?.didReceiveInitial(viewModels: items.map(self.viewModelConverter.convert))
            case .failure(let error):
                self?.output?.didReceive(error: error)
            }
        }
    }
}
