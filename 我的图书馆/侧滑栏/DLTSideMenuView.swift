//
//  DLTSideMenuView.swift
//  myBook
//
//  Created by dongliang on 2025/12/8.
//

import UIKit

class DLTSideMenuView: UIView {
    var closeClosure: (() -> Void)?
    var categorySelectClosure: ((DLTSideMenuCategory) -> Void)?
    var addBookClosure: (() -> Void)?
    var settingsClosure: (() -> Void)?

    private var categories: [DLTSideMenuCategory] = DLTSideMenuCategory.categories

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = DLTThemeManager.shareManager.bgColor
        layer.cornerRadius = 32
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clipsToBounds = true

        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(statsCardView)
        contentView.addSubview(addBookButton)
        contentView.addSubview(categoryHeaderLabel)
        contentView.addSubview(categoryTableView)
        contentView.addSubview(settingsButton)

        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kSafeAreaTop + 12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        statsCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }
        addBookButton.snp.makeConstraints { make in
            make.top.equalTo(statsCardView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        categoryHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(addBookButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(categories.count * 100)
        }
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTableView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }

    @objc private func closeButtonTapped() {
        closeClosure?()
    }

    @objc private func addBookButtonTapped() {
        addBookClosure?()
    }

    @objc private func settingsButtonTapped() {
        settingsClosure?()
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)

        subtitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
        }
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        return view
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "本地图书馆"
        label.font = UIFont(name: FontPingFangRe, size: 14)
        label.textColor = DLTThemeManager.shareManager.DLT_6B7280_9CA3AF
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "分类目录"
        label.font = UIFont(name: FontPingFangBold, size: 24)
        label.textColor = DLTThemeManager.shareManager.DLT_111827_FFFFFF
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = DLTThemeManager.shareManager.DLT_F5F7FB_1A1B21
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = DLTThemeManager.shareManager.DLT_E5E7EB_3A3C44?.cgColor
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = DLTThemeManager.shareManager.DLT_6B7280_9CA3AF
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var statsCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.hex("#0F172A")?.cgColor ?? UIColor.black.cgColor,
            UIColor.hex("#1E293B")?.cgColor ?? UIColor.darkGray.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 40, height: 140)
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(totalBooksTitleLabel)
        view.addSubview(totalBooksCountLabel)
        view.addSubview(categoryCountContainer)
        view.addSubview(subCategoryCountContainer)

        totalBooksTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        totalBooksCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(totalBooksTitleLabel.snp.bottom).offset(8)
        }
        categoryCountContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        subCategoryCountContainer.snp.makeConstraints { make in
            make.leading.equalTo(categoryCountContainer.snp.trailing).offset(20)
            make.centerY.equalTo(categoryCountContainer)
        }

        return view
    }()

    private lazy var totalBooksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "藏书总数"
        label.font = UIFont(name: FontPingFangRe, size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()

    private lazy var totalBooksCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(DLTSideMenuCategory.totalBooks)"
        label.font = UIFont(name: FontDINPro_Bold, size: 40)
        label.textColor = .white
        return label
    }()

    private lazy var categoryCountContainer: UIView = {
        let view = UIView()
        view.addSubview(categoryCountLabel)
        view.addSubview(categoryTextLabel)
        categoryCountLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        categoryTextLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCountLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        return view
    }()

    private lazy var categoryCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(categories.count)"
        label.font = UIFont(name: FontPingFangMe, size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        return label
    }()

    private lazy var categoryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "大类"
        label.font = UIFont(name: FontPingFangRe, size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        return label
    }()

    private lazy var subCategoryCountContainer: UIView = {
        let view = UIView()
        view.addSubview(subCategoryCountLabel)
        view.addSubview(subCategoryTextLabel)
        subCategoryCountLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        subCategoryTextLabel.snp.makeConstraints { make in
            make.top.equalTo(subCategoryCountLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        return view
    }()

    private lazy var subCategoryCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(DLTSideMenuCategory.totalSubCategories)"
        label.font = UIFont(name: FontPingFangMe, size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        return label
    }()

    private lazy var subCategoryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "小项"
        label.font = UIFont(name: FontPingFangRe, size: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        return label
    }()

    private lazy var addBookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = DLTThemeManager.shareManager.DLT_2563EB_2563EB
        button.layer.cornerRadius = 18
        button.setTitle("添加新图书", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: FontPingFangMe, size: 16)

        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(addBookButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var categoryHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "图书分类（大项）"
        label.font = UIFont(name: FontPingFangMe, size: 14)
        label.textColor = DLTThemeManager.shareManager.DLT_6B7280_9CA3AF
        return label
    }()

    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DLTSideMenuCell.self, forCellReuseIdentifier: "DLTSideMenuCell")
        return tableView
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.addSubview(settingsLabel)
        button.addSubview(settingsArrow)

        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        settingsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        settingsArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        let topLine = UIView()
        topLine.backgroundColor = DLTThemeManager.shareManager.DLT_E5E7EB_3A3C44
        button.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        settingsLabel.text = "设置"
        settingsLabel.font = UIFont(name: FontPingFangRe, size: 14)
        settingsLabel.textColor = DLTThemeManager.shareManager.DLT_6B7280_9CA3AF

        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        settingsArrow.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        settingsArrow.tintColor = DLTThemeManager.shareManager.DLT_6B7280_9CA3AF

        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var settingsLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var settingsArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

extension DLTSideMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTSideMenuCell", for: indexPath) as! DLTSideMenuCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        categorySelectClosure?(category)
    }
}
