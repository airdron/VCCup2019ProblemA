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
        let loadingQueue = DispatchQueue(label: "vkcup.document.serial.queue", qos: .userInitiated)
        let dateConverter = DateConverter()
        let viewModelConverter = DocumentsViewModelConverter(dateConverter: dateConverter)
        
        let pagingController = DocumentsPagingController(viewModelConverter: viewModelConverter,
                                                         documentsService: dependencyService.resolve(),
                                                         loadingQueue: loadingQueue)
        
        let deletingController = DocumentsDeletingController(documentsService: dependencyService.resolve(),
                                                             loadingQueue: loadingQueue)
        
        let renamingController = DocumentsRenamingController(viewModelConverter: viewModelConverter,
                                                             documentsService: dependencyService.resolve(),
                                                             loadingQueue: loadingQueue)
        
        let viewController = DocumentsViewController(pagingController: pagingController,
                                                     deletingController: deletingController,
                                                     renamingController: renamingController)
        pagingController.output = viewController
        deletingController.output = viewController
        renamingController.output = viewController
        return viewController
    }
}
