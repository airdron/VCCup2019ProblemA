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
        selectionStyle = .none
        
        moreButton.setImage(Constants.moreButtonImage, for: .normal)
        moreButton.setImage(Constants.moreButtonImageSelected, for: .highlighted)
        moreButton.backgroundColor = .white
        
        documentImageView.contentMode = .scaleAspectFill
        documentImageView.isOpaque = true
        documentImageView.backgroundColor = .white
        
        contentView.addSubview(moreButton)
        contentView.addSubview(documentImageView)
    }
    
    func configure(viewModel: DocumentViewModel) {
        documentImageView.image = viewModel.placeholder
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

extension DocumentTableViewCell {
    
    class InfoView: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initialSetup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initialSetup() {
            backgroundColor = .white
        }
    }
}

private struct Constants {
    
    static let documentImageSize = CGSize(width: 72, height: 72)
    static let horizontalMargin: CGFloat = 12
    static let verticalMargin: CGFloat = 6
    static let moreButtonSize: CGSize = CGSize(width: 48, height: 48)
    static let moreButtonImage = UIImage(named: "MoreIcon")
    static let tagImage = UIImage(named: "TagBadge")
    static let moreButtonImageSelected = UIImage(named: "MoreIconSelected")
}
