//
//  DocumentsDeletingController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsDeletingControllerOutput: class {
    
    func documentsDeletingControllerDidReceive(viewModels: [DocumentViewModel])
    func documentsDeletingControllerDidReceive(error: Error)
}

class DocumentsDeletingController {
    
    weak var output: DocumentsDeletingControllerOutput?
    
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
}
