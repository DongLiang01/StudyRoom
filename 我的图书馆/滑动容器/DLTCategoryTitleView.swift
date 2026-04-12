//
//  File.swift
//  myBook
//
//  Created by dongliang on 2026/1/20.
//

import UIKit

class DLTCategoryTitleView: UIView {
    // MARK: -Public Properties
    var titleFont = UIFont(name: FontPingFangRe, size: 16)
    var selectedTitleFont = UIFont(name: FontPingFangMe, size: 18)
    var titleColor = DLTThemeManager.shareManager.DLT_888C95_888C95
    var selectedTitleColor = DLTThemeManager.shareManager.DLT_333333_FFFFFF
    var containerView: DLTCategoryContainerView? {
        didSet {
            containerView?.delegate = self
            containerView?.scrollTo(index: selectedIndex, animated: false)
        }
    }
    //点击后给外部响应
    var  onSelect: ((Int)->Void)?
    //默认选中
    var defaultSelectedIndex: Int = 0 {
        didSet {
            if titles.isEmpty {
                //没有修正selectedIndex的意义，因为后续设置titles的时候，也会修正
                selectedIndex = defaultSelectedIndex
            }else{
                selectedIndex = adjustSelectedIndexIfNeeded(defaultSelectedIndex)
            }
            containerView?.scrollTo(index: selectedIndex, animated: false)
        }
    }
    //默认标题
    var titles: [String] = [] {
        didSet {
            collectionView.reloadData()
            selectedIndex = adjustSelectedIndexIfNeeded(selectedIndex)
            containerView?.scrollTo(index: selectedIndex, animated: false)
            setNeedsLayout()
        }
    }
    
    // MARK: -override
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
    
    
    // MARK: -Private Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = DLTThemeManager.shareManager.bgColor
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DLTCategoryTitleCell.self, forCellWithReuseIdentifier: String(describing: DLTCategoryTitleCell.self))
        return cv
    }()
    
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
    
    // MARK: -Private Methods
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
}

extension DLTCategoryTitleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: -UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DLTCategoryTitleCell.self), for: indexPath) as! DLTCategoryTitleCell
        cell.titleFont = titleFont!
        cell.titleColor = titleColor
        cell.selectedTitleFont = selectedTitleFont!
        cell.selectedTitleColor = selectedTitleColor
        cell.title = titles[indexPath.item]
        cell.selectedState = selectedIndex == indexPath.item
        return cell
    }
    
    // MARK: -UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let num = abs(indexPath.item - selectedIndex)
        selectedIndex = indexPath.item
        //跨页的话，animated变成false
        containerView?.scrollTo(index: selectedIndex, animated: num == 1)
        onSelect?(indexPath.item)
    }
    
    // MARK: -UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //按最大字体去计算宽度，防止切换后宽度的突然变化
        let title: String = titles[indexPath.item]
        let font = selectedTitleFont ?? .systemFont(ofSize: 18)
        let width = title.size(withAttributes: [.font: font]).width
        return CGSize(width: width + 12, height: bounds.height)
    }
}

extension DLTCategoryTitleView: DLTCategoryContainerViewDelegate {
    func containerViewDidScroll(_ containerView: DLTCategoryContainerView, percent: CGFloat) {
        guard titles.count > 0 else { return }
        let leftIndex = Int(floor(percent))
        let rightIndex = leftIndex + 1
        guard leftIndex >= 0, rightIndex < titles.count else { return }
        let progress = percent - CGFloat(leftIndex)
        let leftIndexPath = IndexPath(item: leftIndex, section: 0)
        let rightIndexPath = IndexPath(item: rightIndex, section: 0)
        
        guard let leftCell = collectionView.cellForItem(at: leftIndexPath) as? DLTCategoryTitleCell,
              let rightCell = collectionView.cellForItem(at: rightIndexPath) as? DLTCategoryTitleCell else {
            return
        }
        // 渐变
        leftCell.setProgress(1 - progress)
        rightCell.setProgress(progress)
    }
    
    func containerViewDidChangeIndex(_ containerView: DLTCategoryContainerView, index: Int) {
        selectedIndex = index
    }
}
