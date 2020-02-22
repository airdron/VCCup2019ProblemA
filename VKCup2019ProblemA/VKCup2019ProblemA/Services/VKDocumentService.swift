//
//  VKDocumentService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKDocumentService: DocumentsLoading {
        
    func fetchDocuments(count: Int, offset: Int, completion: ((Result<Documents, Error>) -> Void)?) {
        guard let userId = VKSdk.accessToken()?.userId else {
            print("user id is not found")
            return
        }
        
        let documentsRequset = VKRequest(method: "docs.search", parameters: [VK_API_OWNER_ID: userId,
                                                                             VK_API_OFFSET: offset,
                                                                             VK_API_COUNT: count,
                                                                             "return_tags": 1,
                                                                             VK_API_Q: "linkin"])
        documentsRequset?.execute(resultBlock: { response in
            guard let responseString = response?.responseString else {
                return
            }
            
            // не нашел где можно байты с ответа забрать, хорошо бы добавить метод без конвертаций всяких
            guard let responseData = responseString.data(using: .utf8) else {
                return
            }
            do {
                let documents = try JSONDecoder().decode(Documents.self, from: responseData)
                completion?(.success(documents))
            } catch {
                completion?(.failure(error))
            }
            
        }, errorBlock: { error in
            completion?(.failure(error ?? VKDefaultError.default))
        })
    }
}

extension VKDocumentService: DocumentDownloading {
    
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

extension VKDocumentService: DocumentDeleting {
    
    func delete(documentBy id: Int,
                completion: ((Result<Bool, Error>) -> Void)?) {
        guard let userId = VKSdk.accessToken()?.userId else {
            print("user id is not found")
            return
        }
        
        let documentsRequset = VKRequest(method: "docs.delete", parameters: [VK_API_OWNER_ID: userId,
                                                                             VK_API_DOC_ID: id])
        
        documentsRequset?.execute(resultBlock: { response in
            guard let responseString = response?.responseString else {
                return
            }
            
            // не нашел где можно байты с ответа забрать, хорошо бы добавить метод без конвертаций всяких
            guard let responseData = responseString.data(using: .utf8) else {
                return
            }
            do {
                let result = try JSONDecoder().decode(OperationResult.self, from: responseData)
                completion?(.success(result.response == 1 ? true : false))
            } catch {
                completion?(.failure(error))
            }
            
        }, errorBlock: { error in
            completion?(.failure(error ?? VKDefaultError.default))
        })
        
    }
}
