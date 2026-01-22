//
//  DLTCategoryCell.swift
//  myBook
//
//  Created by dongliang on 2026/1/21.
//

import UIKit

class DLTCategoryTitleCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(title: String, font: UIFont, color: UIColor?) {
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = color
    }
    
    private func addUI() {
        contentView.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = DLTThemeManager.shareManager.DLT_888C95_888C95
        label.font = UIFont(name: FontPingFangRe, size: 15)
        label.textAlignment = .center
        return label
    }()
}
