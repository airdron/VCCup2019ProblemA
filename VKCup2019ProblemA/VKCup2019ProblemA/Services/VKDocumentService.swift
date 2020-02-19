//
//  VKDocumentService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKDocumentService: DocumentsService {
        
    func fetchDocuments(count: Int, offset: Int, completion: ((Result<Documents, Error>) -> Void)?) {
        guard let userId = VKSdk.accessToken()?.userId else {
            print("user id is not found")
            return
        }
        
        let documentsRequset = VKRequest(method: "docs.search", parameters: [VK_API_OWNER_ID: userId,
                                                                             VK_API_OFFSET: offset,
                                                                             VK_API_COUNT: count,
                                                                             "return_tags": 1,
                                                                             VK_API_Q: "book"])
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

enum VKDefaultError: Error {
    
    case `default`
    
    var localizedDescription: String {
        L10n.alertErrorDefaultMessage
    }
}
