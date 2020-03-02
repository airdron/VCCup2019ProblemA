//
//  DocumentViewerViewController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 21.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit
import QuickLook

private class FilePreviewItem: NSObject, QLPreviewItem {
    
    var previewItemURL: URL?
    var previewItemTitle: String?
    
    init(url: URL? = nil, previewItemTitle: String = "") {
        self.previewItemURL = url
        self.previewItemTitle = previewItemTitle
        super.init()
    }
}

class DocumentViewerViewController: QLPreviewController, QLPreviewControllerDataSource {
        
    private let url: URL
    private let fileExtension: String
    private let fileName: String
    
    private var fileItem: QLPreviewItem = FilePreviewItem()
    
    private let downloadDocumentService: DocumentDownloading
    
    private let activityIndicator = UIActivityIndicatorView()

    public init(url: URL,
                fileExtension: String,
                fileName: String,
                downloadDocumentService: DocumentDownloading) {
        self.url = url
        self.fileExtension = fileExtension
        self.fileName = fileName
        self.downloadDocumentService = downloadDocumentService
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.center = view.center
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        if #available(iOS 11.0, *) {
            view.addSubview(activityIndicator)
        }

        downloadDocumentService.downloadDocument(by: url, fileExtension: fileExtension) { [weak self] result in
            switch result {
            case .success(let fileUrl):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.handleFile(url: fileUrl)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(error: error)
                }
            }
        }
    }
    
    private func handleFile(url: URL) {
        let fileItem = FilePreviewItem(url: url,
                                       previewItemTitle: fileName)
        self.fileItem = fileItem
        if QLPreviewController.canPreview(fileItem) {
            self.reloadData()
        } else {
            self.showAlert(error: VKDefaultError.unsupportedFormat)
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileItem
    }
}
