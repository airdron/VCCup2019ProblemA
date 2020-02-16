//
//  DocumentsModelController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

protocol DocumentsModelControllerOutput: class {
    
}

class DocumentsModelController {
    
    weak var output: DocumentsModelControllerOutput?
    
    private let documentsService: DocumentsService
    
    init(documentsService: DocumentsService) {
        self.documentsService = documentsService
    }
}
