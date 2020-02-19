//
//  DocumentsViewController.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 16.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {

    private let modelController: DocumentsModelController
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var viewModels: [DocumentViewModel] = []
    private let rowHeight: CGFloat = 84
    
    init(modelController: DocumentsModelController) {
        self.modelController = modelController
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
        
        modelController.fetchDocuments()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageHeight = CGFloat(modelController.pageCount) * rowHeight
        let contentHeight = tableView.contentSize.height
        
        print("<=====")
        print(scrollView.contentOffset.y)
        print(pageHeight)
        print(contentHeight)
        print("=====>")
        
        if scrollView.contentOffset.y >= (contentHeight - pageHeight / 2) {
            modelController.fetchDocuments()
        }
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

extension DocumentsViewController: DocumentsModelControllerOutput {
    
    func didReceive(error: Error) {
        showAlert(error: error)
    }
    
    func didReceiveInitial(viewModels: [DocumentViewModel]) {
        self.viewModels += viewModels
        tableView.reloadData()
    }
}

private struct Constants {
    
    static let tableContentInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
}
