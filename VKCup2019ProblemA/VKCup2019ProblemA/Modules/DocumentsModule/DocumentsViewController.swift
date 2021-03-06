//
//  DocumentsViewController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

protocol DocumentsModuleInput: class {
    
    func renameFile(at index: Int, with newName: String)
    func deleteFile(at index: Int)
}

class DocumentsViewController: UIViewController {

    var onOpen: ((_ src: URL, _ ext: String, _ name: String) -> Void)?
    var onBottomSheet: ((_ name: String, _ documentIndex: Int) -> Void)?
    
    private let pagingController: DocumentsPagingController
    private let deletingController: DocumentsDeletingController
    private let renamingController: DocumentsRenamingController
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var viewModels: [DocumentViewModel] = []
    
    private var paginationTrigger: UUID = UUID()
    
    private let waitingAlertController = UIAlertController.makeWaiting()
    
    init(pagingController: DocumentsPagingController,
         deletingController: DocumentsDeletingController,
         renamingController: DocumentsRenamingController) {
        self.pagingController = pagingController
        self.deletingController = deletingController
        self.renamingController = renamingController
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
        
        let fileName = viewModels[indexPath.row].meta.title
        cell?.onMore = { [weak self] in
            self?.onBottomSheet?(fileName, indexPath.row)
        }
        
        guard let documentCell = cell else {
            return UITableViewCell()
        }
        
        return documentCell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? DocumentTableViewCell)?.finishImageTask()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let src = viewModels[indexPath.row].meta.url
        let ext = viewModels[indexPath.row].meta.ext
        let fileName = viewModels[indexPath.row].meta.title
        
        DispatchQueue.main.async {
            self.onOpen?(src, ext, fileName)
        }
    }
}

extension DocumentsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        pagingController.loadImages(urls: indexPaths.map { self.viewModels[$0.row].photoUrl })
    }
}

extension DocumentsViewController: DocumentsModuleInput {
    
    func renameFile(at index: Int, with newName: String) {
        present(waitingAlertController, animated: true, completion: nil)
        
        let viewModel = viewModels[index]
        renamingController.rename(documentItem: viewModel.meta, newFileName: newName, index: index)
    }
    
    func deleteFile(at index: Int) {
        present(waitingAlertController, animated: true, completion: nil)
        
        deletingController.deleteDocument(id: viewModels[index].meta.id,
                                          index: index)
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
        tableView.prefetchDataSource = self
    }
}

extension DocumentsViewController: DocumentsDeletingControllerOutput {
    
    func documentsDeletingControllerDidReceive(error: Error) {
        waitingAlertController.dismiss(animated: false) {
            self.showAlert(error: error)
        }
    }
    
    func documentsDeletingControllerDidDeleteDocument(at index: Int) {
        waitingAlertController.dismiss(animated: true, completion: nil)
        viewModels.remove(at: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
}

extension DocumentsViewController: DocumentsRenamingControllerOutput {
    
    func documentsRenamingControllerDidReceive(error: Error) {
        waitingAlertController.dismiss(animated: false) {
            self.showAlert(error: error)
        }
    }
    
    func documentsRenamingControllerDidRenameDocument(viewModel: DocumentViewModel, at index: Int) {
        waitingAlertController.dismiss(animated: true, completion: nil)
        viewModels[index] = viewModel
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DocumentTableViewCell else {
            return
        }
        cell.configure(viewModel: viewModel)
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
  
// В перспективе insertRows наверно будет лучше, но в данной задаче можно и reloadData
//    private func handle(viewModels: [DocumentViewModel]) {
//        self.viewModels += viewModels
//        if !viewModels.isEmpty {
//            paginationTrigger = viewModels[(0 + viewModels.count) / 2].uuid
//            tableView.reloadData()
//        } else {
//            paginationTrigger = UUID()
//        }
//    }
 
    private func handle(viewModels: [DocumentViewModel]) {
        let isInitial = self.viewModels.isEmpty
        let previousCount = self.viewModels.count
        self.viewModels += viewModels
        if !viewModels.isEmpty {
            paginationTrigger = viewModels[(0 + viewModels.count) / 2].uuid
            let newCount = self.viewModels.count
            if isInitial {
                tableView.reloadData()
            } else {
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.insertRows(at: (previousCount..<newCount).map { IndexPath(row: $0, section: 0) }, with: .none)
                    tableView.endUpdates()
                }
            }
        } else {
            paginationTrigger = UUID()
        }
    }
}

private struct Constants {
    
    static let tableContentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
    static let rowHeight: CGFloat = 84
}
