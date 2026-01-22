//
//  File.swift
//  myBook
//
//  Created by dongliang on 2026/1/20.
//

import UIKit

class DLTCategoryView: UIView {
    var titleFont = UIFont(name: FontPingFangRe, size: 16)
    var selectedTitleFont = UIFont(name: FontPingFangMe, size: 18)
    var titleColor = DLTThemeManager.shareManager.DLT_888C95_888C95
    var selectedTitleColor = DLTThemeManager.shareManager.DLT_333333_FFFFFF
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //首次布局时设置defaultSelectedIndex不居中时需要这里居中
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func addUI() -> () {
        addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //修正SelectedIndex
    private func adjustSelectedIndexIfNeeded(_ index: Int) -> Int {
        guard !titles.isEmpty else {return 0}
        return max(0, min(index, titles.count - 1))
    }
    
    // MARK: -setter
    var defaultSelectedIndex: Int = 0 {
        didSet {
            if titles.isEmpty {
                //没有修正selectedIndex的意义，因为后续设置titles的时候，也会修正
                selectedIndex = defaultSelectedIndex
            }else{
                selectedIndex = adjustSelectedIndexIfNeeded(defaultSelectedIndex)
            }
        }
    }
    
    private var selectedIndex = 0 {
        didSet {
            let old = oldValue
            let new = selectedIndex
            guard old != new else {return}
            guard !titles.isEmpty else {return}
            
            let oldIndexPath = IndexPath(item: old, section: 0)
            let newIndexPath = IndexPath(item: new, section: 0)
            collectionView.reloadItems(at: [oldIndexPath,newIndexPath])
            //移动到水平方向屏幕中间
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    var titles: [String] = [] {
        didSet {
            collectionView.reloadData()
            selectedIndex = adjustSelectedIndexIfNeeded(selectedIndex)
            setNeedsLayout()
        }
    }
    
    // MARK: -懒加载
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = DLTThemeManager.shareManager.bgColor
        cv.backgroundColor = UIColor.randomColor()
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DLTCategoryCell.self, forCellWithReuseIdentifier: String(describing: DLTCategoryCell.self))
        return cv
    }()
}

extension DLTCategoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: -UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DLTCategoryCell.self), for: indexPath) as! DLTCategoryCell
        if selectedIndex == indexPath.item {
            cell.reload(title: titles[indexPath.item], font: selectedTitleFont ?? .systemFont(ofSize: 18), color: selectedTitleColor)
        }else{
            cell.reload(title: titles[indexPath.item], font: titleFont ?? .systemFont(ofSize: 16), color: titleColor)
        }
        return cell
    }
    
    // MARK: -UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
    
    // MARK: -UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title: String = titles[indexPath.item]
        let font = selectedIndex == indexPath.item ? (selectedTitleFont ?? .systemFont(ofSize: 18)) : (titleFont ?? .systemFont(ofSize: 16))
        let width = title.size(withAttributes: [.font: font]).width
        return CGSize(width: width + 12, height: bounds.height)
    }
}
