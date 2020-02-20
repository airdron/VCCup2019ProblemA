//
//  DocumentBottomSheetController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 21.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentAlertFactory {
    
    func makeBottomSheet(renameHandler: (() -> Void)?,
                         deleteHandler: (() -> Void)?) -> UIAlertController {
        let renameAction = UIAlertAction(title: L10n.renameActionText,
                                         style: .default) { _ in
                            renameHandler?()
        }
        
        let deleteAction = UIAlertAction(title: L10n.deleteActionText,
                                         style: .destructive) { _ in
                            deleteHandler?()
        }
        
        let cancelAction = UIAlertAction(title: L10n.cancelActionText,
                                         style: .cancel,
                                         handler: nil)
        
        let controller = UIAlertController(title: nil,
                                           message: nil,
                                           preferredStyle: .actionSheet)
        controller.addAction(renameAction)
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        return controller
    }
}
