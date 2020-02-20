//
//  DocumentViewerContainer.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 21.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

class DocumentViewerContainer {
    
    private let dependencyService: DependencyService
    
    init(dependencyService: DependencyService) {
        self.dependencyService = dependencyService
    }
    
    func make(url: URL,
              fileExtension: String,
              fileName: String) -> DocumentViewerViewController {
        return DocumentViewerViewController(url: url,
                                            fileExtension: fileExtension,
                                            fileName: fileName,
                                            downloadDocumentService: dependencyService.resolve())
    }
}
