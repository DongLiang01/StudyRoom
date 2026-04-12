//
//  DLTCategoryCell.swift
//  myBook
//
//  Created by dongliang on 2026/1/21.
//

import UIKit

class DLTCategoryTitleCell: UICollectionViewCell {
    // MARK: -Public Properties
    var titleFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    var selectedTitleFont = UIFont.systemFont(ofSize: 18)
    var titleColor: UIColor?
    var selectedTitleColor: UIColor?
    var title: String = "--" {
        didSet {
            titleLabel.text = title
        }
    }
    var selectedState: Bool = false {
        didSet {
            //这里设置titleLabel.transform而不直接设置font，是为了优化滑动结束后的突然字体变化
            if selectedState {
                let maxScale = selectedTitleFont.pointSize / titleFont.pointSize
                titleLabel.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                titleLabel.textColor = selectedTitleColor
            }else{
                titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                titleLabel.textColor = titleColor
            }
        }
    }
    
    
    // MARK: -Public Methods
    func setProgress(_ progress: CGFloat) {
        // progress: 0 ~ 1
        titleLabel.textColor = blendColor(from: titleColor!, to: selectedTitleColor!, progress: progress)
        let maxScale = selectedTitleFont.pointSize / titleFont.pointSize
        let scale = 1 + (maxScale - 1) * progress
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    // MARK: -override
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Private Methods
    private func addUI() {
        contentView.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: -Private Properties
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = DLTThemeManager.shareManager.DLT_888C95_888C95
        label.font = UIFont(name: FontPingFangRe, size: 15)
        label.textAlignment = .center
        return label
    }()
}
