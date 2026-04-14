//
//  DLTSideMenuCell.swift
//  myBook
//
//  Created by dongliang on 2025/12/28.
//

import UIKit

class DLTSideMenuCell: UITableViewCell {
    var categorySelectAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = DLTThemeManager.shareManager.bgColor
        contentView.addSubview(containerView)
        containerView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(countLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
        }
        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(12)
            make.bottom.equalTo(containerView.snp.centerY).inset(2)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(titleLabel)
        }
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with category: DLTSideMenuCategory, isSelected: Bool = false) {
        titleLabel.text = category.name
        subTitleLabel.text = category.subTitle
        countLabel.text = "\(category.bookCount)"
        iconLabel.text = String(category.name.prefix(1))
        iconContainerView.backgroundColor = category.iconColor

        let theme = DLTThemeManager.shareManager
        if isSelected {
            containerView.backgroundColor = UIColor.hex("#EFF6FF")
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.hex("#DBEAFE")?.cgColor
            countLabel.textColor = theme.DLT_2563EB_2563EB
        } else {
            containerView.backgroundColor = theme.DLT_F5F7FB_1A1B21
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = theme.DLT_E5E7EB_3A3C44?.cgColor
            countLabel.textColor = theme.DLT_6B7280_9CA3AF
        }

        titleLabel.textColor = theme.DLT_111827_FFFFFF
        subTitleLabel.textColor = theme.DLT_6B7280_9CA3AF
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        return view
    }()

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()

    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontPingFangBold, size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontPingFangMe, size: 16)
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontPingFangRe, size: 13)
        return label
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontPingFangMe, size: 14)
        return label
    }()
}
