//
//  DocumentsViewModelConverter.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 17.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentsViewModelConverter {

    private let titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    private let subtitleAndTagFont: UIFont = UIFont.systemFont(ofSize: 13)
    private let titleColor: UIColor = .black
    private let subtitleAndTagColor: UIColor = UIColor(red: 129.0 / 255,
                                                       green: 140.0 / 255,
                                                       blue: 153.0 / 255,
                                                       alpha: 1)
    private let titleKern: CGFloat = -0.32
    private let subtitleAndTagKern: CGFloat = -0.08
    private let titleLineHeight: CGFloat = 20
    private let subtitleLineHeight: CGFloat = 16

    private let byteCountFormatterStyle: ByteCountFormatter.CountStyle = .file

    private let titleAttributes: [NSAttributedString.Key: Any]
    private let subtitleAndTagAttributes: [NSAttributedString.Key: Any]
    
    private let dateConverter: DateConverter
    private let byteCountFormatter: ByteCountFormatter
    
    init(dateConverter: DateConverter) {
        self.dateConverter = dateConverter
        
        let titleParagraph = NSMutableParagraphStyle()
        titleParagraph.minimumLineHeight = titleLineHeight
        titleParagraph.lineBreakMode = .byTruncatingTail
        
        titleAttributes = [.font: titleFont,
                           .kern: titleKern,
                           .foregroundColor: titleColor,
                           .paragraphStyle: titleParagraph]
        
        let subtitleAndTagParagraph = NSMutableParagraphStyle()
        subtitleAndTagParagraph.minimumLineHeight = subtitleLineHeight
        subtitleAndTagParagraph.lineBreakMode = .byTruncatingTail
        
        subtitleAndTagAttributes = [.font: subtitleAndTagFont,
                                    .kern: subtitleAndTagKern,
                                    .foregroundColor: subtitleAndTagColor,
                                    .paragraphStyle: subtitleAndTagParagraph]
        
        byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.countStyle = byteCountFormatterStyle
    }
    
    private func makeTitle(documentItem: DocumentItem) -> NSAttributedString {
        return NSAttributedString(string: documentItem.title,
                                  attributes: titleAttributes)
    }
    
    private func makeSubtitle(documentItem: DocumentItem) -> NSAttributedString {
        let extString = documentItem.ext.uppercased()
        let bytesCountString = byteCountFormatter.string(fromByteCount: Int64(documentItem.size)).replacingOccurrences(of: ",", with: ".")
        
        let dateString = dateConverter.documentFormatedDate(interval: TimeInterval(documentItem.date))
        
        let subtitleString: String
        if isTextFileWithExtensionName(documentItem: documentItem) {
            subtitleString = dateString + " · " + bytesCountString
        } else {
            subtitleString = extString + " · " + bytesCountString + " · " + dateString
        }
        
        return NSAttributedString(string: subtitleString, attributes: subtitleAndTagAttributes)
    }
    
    private func makeTags(documentItem: DocumentItem) -> NSAttributedString? {
        guard let tags = documentItem.tags, !tags.isEmpty else {
            return nil
        }
        
        let string = tags.joined(separator: ", ")
        return NSAttributedString(string: string, attributes: subtitleAndTagAttributes)
    }
    
    private func titleNumberOfLines(documentItem: DocumentItem) -> Int {
        return documentItem.tags?.isEmpty == false ? 1 : 2
    }
    
    private func isTextFileWithExtensionName(documentItem: DocumentItem) -> Bool {
        guard case .text = documentItem.type else { return false }
        
        let fileNameExtension = URL(fileURLWithPath: documentItem.title).pathExtension
        return !fileNameExtension.isEmpty
    }
    
    func convert(documentItem: DocumentItem) -> DocumentViewModel {
        return DocumentViewModel(placeholder: documentItem.type.placeholderImage,
                                 titleNumberOfLines: titleNumberOfLines(documentItem: documentItem),
                                 title: makeTitle(documentItem: documentItem),
                                 subtitle: makeSubtitle(documentItem: documentItem),
                                 tags: makeTags(documentItem: documentItem),
                                 meta: DocumentViewModel.Meta(src: documentItem.url,
                                                              ext: documentItem.ext,
                                                              fileName: documentItem.title,
                                                              id: documentItem.id))
    }
}
