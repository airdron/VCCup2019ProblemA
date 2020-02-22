//
//  DocumentDownloading.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 20.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol DocumentDownloading {
    
    func downloadDocument(by url: URL,
                          fileExtension: String,
                          completion: ((Result<URL, Error>) -> Void)?)
}
