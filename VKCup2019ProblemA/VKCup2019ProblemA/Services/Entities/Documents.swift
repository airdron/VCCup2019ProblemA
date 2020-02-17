//
//  Documents.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

// VKDocs не сооветсвует последнему апи 5.103

// MARK: - Documents
struct Documents: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [DocumentItem]
}

// MARK: - Item
struct DocumentItem: Codable {
    let id, ownerID: Int
    let title: String
    let size: Int
    let ext: String
    let url: URL
    let date: Int
    let type: DocumentType
    let preview: Preview?
    let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, size, ext, url, date, type, preview, tags
    }
}

// MARK: - Preview
struct Preview: Codable {
    let photo: Photo
}

// MARK: - Photo
struct Photo: Codable {
    
    // MARK: - Size

    struct Size: Codable {
        let src: URL
        let width, height: Int
        let type: String
    }
    
    let sizes: [Size]
}

