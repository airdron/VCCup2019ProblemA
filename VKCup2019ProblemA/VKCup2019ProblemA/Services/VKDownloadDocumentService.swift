//
//  VKDownloadDocumentService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 20.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

class VKDownloadDocumentService: DownloadDocumentService {
        
    func downloadDocument(by url: URL,
                          fileExtension: String,
                          completion: ((Result<URL, Error>) -> Void)?) {
        
        let documentsPath = FileManager.default.temporaryDirectory
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent).appendingPathExtension(fileExtension)
        guard !FileManager.default.fileExists(atPath: destinationURL.path) else {
            completion?(.success(destinationURL))
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { locationFileUrl, _, error in
            guard let locationFileUrl = locationFileUrl else { return }
            do {
                try FileManager.default.copyItem(at: locationFileUrl, to: destinationURL)
                completion?(.success(destinationURL))
            } catch let error {
                completion?(.failure(error))
            }
        }
        downloadTask.resume()
    }
}
