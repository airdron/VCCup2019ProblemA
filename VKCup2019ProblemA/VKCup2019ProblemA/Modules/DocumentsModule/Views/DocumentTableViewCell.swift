//
//  DocumentTableViewCell.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 17.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    private let moreButton = UIButton()
    private let documentImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        moreButton.setImage(Constants.moreButtonImage, for: .normal)
        moreButton.backgroundColor = .white
        
        documentImageView.contentMode = .scaleAspectFill
        documentImageView.image = optimizedImage(from: UIImage(named: "PlaceholderVideo"))
        documentImageView.isOpaque = true
        documentImageView.backgroundColor = .white
        
        contentView.addSubview(moreButton)
        contentView.addSubview(documentImageView)
    }
    
    func configure(viewModel: DocumentViewModel) {
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moreButton.frame.size = Constants.moreButtonSize
        moreButton.center.y = contentView.center.y
        moreButton.frame.origin.x = contentView.bounds.width - Constants.moreButtonSize.width
        
        documentImageView.frame.origin.x = Constants.horizontalMargin
        documentImageView.frame.size = Constants.documentImageSize
        documentImageView.center.y = contentView.center.y
    }
}

private struct Constants {
    
    static let documentImageSize = CGSize(width: 72, height: 72)
    static let horizontalMargin: CGFloat = 12
    static let verticalMargin: CGFloat = 6
    static let moreButtonSize: CGSize = CGSize(width: 48, height: 48)
    static let moreButtonImage = optimizedImage(from: UIImage(named: "MoreIcon"))
    static let tagImage = optimizedImage(from: UIImage(named: "TagBadge"))
}
