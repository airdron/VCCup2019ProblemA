//
//  DocumentsService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentsService {
    
    func fetchDocuments(count: Int, offset: Int, completion: ((Result<Documents, Error>) -> Void)?)
}
