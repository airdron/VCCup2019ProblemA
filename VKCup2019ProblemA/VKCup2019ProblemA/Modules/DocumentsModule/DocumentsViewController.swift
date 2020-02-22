//
//  DocumentsViewController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

protocol DocumentsModuleInput: class {
    
    func renameFile(at index: Int)
    func deleteFile(at index: Int)
}

class DocumentsViewController: UIViewController {

    var onOpen: ((_ src: URL, _ ext: String, _ name: String) -> Void)?
    var onBottomSheet: ((_ documentIndex: Int) -> Void)?
    
    private let pagingController: DocumentsPagingController
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var viewModels: [DocumentViewModel] = []
    private let rowHeight: CGFloat = 84
    private var paginationTrigger: UUID = UUID()
    
    init(pagingController: DocumentsPagingController) {
        self.pagingController = pagingController
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.addSubview(tableView)
        
        pagingController.fetchDocuments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame.origin.x = 0
        tableView.frame.origin.y = topLayoutEdgeInset
        tableView.frame.size.width = view.bounds.width
        tableView.frame.size.height = view.bounds.height - topLayoutEdgeInset - bottomLayoutEdgeInset
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? DocumentTableViewCell
        cell?.configure(viewModel: viewModels[indexPath.row])
        
        cell?.onMore = { [weak self] in
            self?.onBottomSheet?(indexPath.row)
        }
        
        guard let documentCell = cell else {
            return UITableViewCell()
        }
        
        return documentCell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { nil }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { nil }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DocumentTableViewCell else { return }
        
        if cell.paginationTrigger == paginationTrigger {
            pagingController.fetchDocuments()
            paginationTrigger = UUID()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let src = viewModels[indexPath.row].meta.src
        let ext = viewModels[indexPath.row].meta.ext
        let fileName = viewModels[indexPath.row].meta.fileName
        onOpen?(src, ext, fileName)
    }
}

extension DocumentsViewController: DocumentsModuleInput {
    
    func renameFile(at index: Int) {
        print(viewModels[index].meta.fileName)
    }
    
    func deleteFile(at index: Int) {
        print(viewModels[index].meta.fileName)
    }
}

private extension DocumentsViewController {
    
    func setupUI() {
        title = L10n.documentsTitle
        view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.backgroundColor = .white
        
        tableView.register(DocumentTableViewCell.self,
                           forCellReuseIdentifier: DocumentTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset = Constants.tableContentInsets
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DocumentsViewController: DocumentsPagingControllerOutput {
    
    func documentsPagingControllerDidReceive(error: Error) {
        paginationTrigger = viewModels.last?.uuid ?? UUID()
        showAlert(error: error)
    }
    
    func documentsPagingControllerDidReceive(viewModels: [DocumentViewModel]) {
        handle(viewModels: viewModels)
    }
    
    private func handle(viewModels: [DocumentViewModel]) {
        self.viewModels += viewModels
        paginationTrigger = viewModels[(0 + viewModels.count) / 2].uuid
        tableView.reloadData()
    }
   
//    mb better
//    private func handle(viewModels: [DocumentViewModel]) {
//        let previousCount = self.viewModels.count
//        self.viewModels += viewModels
//        paginationTrigger = viewModels[(0 + viewModels.count) / 2].uuid
//        let newCount = self.viewModels.count
//
//        tableView.beginUpdates()
//        tableView.insertRows(at: (previousCount..<newCount).map { IndexPath(row: $0, section: 0) }, with: .none)
//        tableView.endUpdates()
//    }
}

private struct Constants {
    
    static let tableContentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
}
