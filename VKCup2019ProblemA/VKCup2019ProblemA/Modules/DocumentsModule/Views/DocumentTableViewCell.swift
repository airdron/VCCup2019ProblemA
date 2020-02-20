//
//  DocumentTableViewCell.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 17.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    var onMore: (() -> Void)?
    
    var paginationTrigger: UUID = UUID()
    
    private let moreButton = UIButton()
    private let documentImageView = UIImageView()
    private let infoView = InfoView()
    
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
        documentImageView.backgroundColor = .white
        
        contentView.addSubview(moreButton)
        contentView.addSubview(documentImageView)
        contentView.addSubview(infoView)
        
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
    }
    
    func configure(viewModel: DocumentViewModel) {
        documentImageView.image = viewModel.placeholder
        infoView.configure(title: viewModel.title,
                           subtitle: viewModel.subtitle,
                           tags: viewModel.tags,
                           titleNumberOfLines: viewModel.titleNumberOfLines)
        
        paginationTrigger = viewModel.uuid
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
        
        infoView.frame.origin.x = documentImageView.frame.maxX + Constants.horizontalMargin
        infoView.frame.size.width = contentView.bounds.width - infoView.frame.origin.x - Constants.moreButtonSize.width
        infoView.sizeToFit()
        infoView.center.y = contentView.center.y
    }
    
    @objc
    private func didTapMore() {
        onMore?()
    }
}

extension DocumentTableViewCell {
    
    class InfoView: UIView {
        
        private let titleLabel = UILabel()
        private let subtitleLabel = UILabel()
        private let tagsLabel = UILabel()
        private let tagImageView = UIImageView()
        
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
            titleLabel.backgroundColor = .white
            subtitleLabel.backgroundColor = .white
            tagsLabel.backgroundColor = .white
            
            tagImageView.image = UIImage(named: "TagBadge")
            
            addSubview(titleLabel)
            addSubview(subtitleLabel)
            addSubview(tagsLabel)
            addSubview(tagImageView)
        }
        
        func configure(title: NSAttributedString,
                       subtitle: NSAttributedString,
                       tags: NSAttributedString?,
                       titleNumberOfLines: Int) {
            titleLabel.attributedText = title
            subtitleLabel.attributedText = subtitle
            tagsLabel.attributedText = tags
            titleLabel.numberOfLines = titleNumberOfLines
            tagImageView.isHidden = tagsLabel.attributedText == nil
        }
        
        private func layout() {
            titleLabel.frame.size.width = bounds.width
            titleLabel.sizeToFit()
            titleLabel.frame.size.width = bounds.width
            
            subtitleLabel.frame.size.width = bounds.width
            subtitleLabel.sizeToFit()
            subtitleLabel.frame.origin.y = titleLabel.frame.maxY + Constants.subtitleLabelTopOffset
            subtitleLabel.frame.size.width = bounds.width
            
            tagImageView.frame.size = Constants.tagImageSize
            tagImageView.frame.origin.y = subtitleLabel.frame.maxY + Constants.tagsImageTopOffset
            
            tagsLabel.frame.size.width = bounds.width - Constants.tagImageSize.width - Constants.tagsLabelLeftOffset
            tagsLabel.frame.origin.y = subtitleLabel.frame.maxY + Constants.tagsLabelTopOffset
            tagsLabel.frame.origin.x = tagImageView.frame.maxX + Constants.tagsLabelLeftOffset
            
            if tagsLabel.attributedText != nil {
                tagsLabel.sizeToFit()
                tagsLabel.frame.size.width = bounds.width - Constants.tagImageSize.width - Constants.tagsLabelLeftOffset
            } else {
                tagsLabel.frame.size = .zero
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layout()
        }
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            frame.size.width = size.width
            if #available(iOS 11.0, *) {
                frame.size.width -= (safeAreaInsets.left + safeAreaInsets.right)
            } else {
                // do nothing
            }
            layout()
            return CGSize(width: bounds.size.width, height: tagsLabel.frame.maxY)
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
    static let tagImageSize = CGSize(width: 11, height: 11)
    static let tagsLabelLeftOffset: CGFloat = 6
    static let tagsLabelTopOffset: CGFloat = 4
    static let tagsImageTopOffset: CGFloat = 7
    static let subtitleLabelTopOffset: CGFloat = 3
}
