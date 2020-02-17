//
//  DocumentsModuleContainer.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentsModuleContainer {
    
    private let dependencyService: DependencyService
    
    init(dependencyService: DependencyService) {
        self.dependencyService = dependencyService
    }
    
    func make() -> DocumentsViewController {
        let viewModelConverter = DocumentsViewModelConverter()
        let modelController = DocumentsModelController(viewModelConverter: viewModelConverter,
                                                       documentsService: dependencyService.resolve())
        let viewController = DocumentsViewController(modelController: modelController)
        modelController.output = viewController
        return viewController
    }
}
