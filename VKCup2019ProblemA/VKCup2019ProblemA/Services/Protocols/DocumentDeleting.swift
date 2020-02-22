//
//  DocumentDeleting.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 22.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentDeleting {
    
    func delete(documentBy id: Int,
                completion: ((Result<Bool, Error>) -> Void)?)
}
