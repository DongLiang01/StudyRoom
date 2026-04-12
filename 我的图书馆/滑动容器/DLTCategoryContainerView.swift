//
//  DLTCategoryContainerView.swift
//  myBook
//
//  Created by dongliang on 2026/1/23.
//

import UIKit

class DLTCategoryContainerView: UIView {
    // MARK: -Public Properties
    //weak可以避免循环引用
    weak var datasource: (any DLTCategoryContainerDataSource)?
    weak var delegate: DLTCategoryContainerViewDelegate?
    
    // MARK: -Public Methods
    func scrollTo(index: Int, animated: Bool) {
        let target = adjustSelectedIndexIfNeeded(index)
        guard target != currentIndex else { return }
        currentIndex = target
        loadList(at: target)
        
        let offsetX = CGFloat(target) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)

        if !animated {
            //有动画时，会自动走滑动的代理方法，里面有通知，这里就不需要了
            //生命周期通知
            handlePageChange()
        }
    }
    
    // MARK: -override
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
        scrollView.delegate = self
        bindContainerLifecycle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameIsZero = scrollView.frame.isEmpty
        let sizeChanged = scrollView.frame.size != self.bounds.size
        if frameIsZero || sizeChanged {
            scrollView.frame = bounds
            containerVC.view.frame = bounds
            let count = datasource?.numberOfListsInlistContainerView() ?? 0
            let width = scrollView.bounds.width
            let height = scrollView.bounds.height
            scrollView.contentSize = CGSize(width: CGFloat(count) * width, height: height)
            
            // 初始化加载当前页
            if validListDict[currentIndex] == nil {
               loadList(at: currentIndex)
            }
            
            // 定位到当前页
            scrollView.contentOffset = CGPoint(
                x: CGFloat(currentIndex) * width,
                y: 0
            )
            
            for (index, list) in validListDict {
                let view = list.listView()
                view.frame = CGRect(
                    x: CGFloat(index) * scrollView.bounds.width,
                    y: 0,
                    width: scrollView.bounds.width,
                    height: scrollView.bounds.height
                )
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //通过监测containerVC的生命周期，来实现view的生命周期监测
        guard let newSuperview = newSuperview else { return }
        var responder: UIResponder? = newSuperview
        while let r = responder {
            if let parentVC = r as? UIViewController {
                guard containerVC.parent == nil else { return }
                parentVC.addChild(containerVC)
                containerVC.didMove(toParent: parentVC)
                break
            }
            responder = r.next
        }
    }
    
    // MARK: -Private Properties
    private var validListDict: [Int: DLTCategoryListContentDelegate] = [:]
    private(set) var currentIndex : Int = 0
    //防止appear重复调用
    private var currentListIsAppeared = false
    
    ///一个横向的scrollView
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = false
        return sv
    }()
    
    private let containerVC = {
        let vc = DLTCategoryContainerViewController()
        vc.view.backgroundColor = UIColor.clear
        return vc
    }()
    
    // MARK: -Private Methods
    private func addUI() {
        addSubview(containerVC.view)
        containerVC.view.addSubview(scrollView)
    }
    
    //修正SelectedIndex
    private func adjustSelectedIndexIfNeeded(_ index: Int) -> Int {
        guard let datasource = datasource else {return 0}
        let num = datasource.numberOfListsInlistContainerView()
        guard num > 0 else {return 0}
        return max(0, min(index, num - 1))
    }
    
    private func list(at index: Int) -> DLTCategoryListContentDelegate? {
        guard let datasource = datasource else { return nil }
        let num = datasource.numberOfListsInlistContainerView()
        guard index >= 0 && index < num else {return nil}
        if let list = validListDict[index] {
            return list
        }
        
        let list = datasource.listContainerViewInitListForIndex(index: index)
        validListDict[index] = list
        // 加到 scrollView
        let view = list.listView()
        scrollView.addSubview(view)
        view.frame = CGRect(
            x: CGFloat(index) * scrollView.bounds.width,
            y: 0,
            width: scrollView.bounds.width,
            height: scrollView.bounds.height
        )
        return list
    }
    
    //预加载功能
    private func loadList(at index: Int) {
        _ = list(at: index)
        _ = list(at: index + 1)
        _ = list(at: index - 1)
    }
    
    //使用containerVC来通知view生命周期
    private func bindContainerLifecycle() {
        containerVC.viewWillAppear = { [weak self] in
            guard let self else { return }
            let list = self.validListDict[self.currentIndex]
            list?.listViewWillAppear()
        }

        containerVC.viewDidAppear = { [weak self] in
            guard let self else { return }
            guard !self.currentListIsAppeared else { return }
                
            self.currentListIsAppeared = true
            let list = self.validListDict[self.currentIndex]
            list?.listViewDidAppear()
        }

        containerVC.viewWillDisappear = { [weak self] in
            guard let self else { return }
            let list = self.validListDict[self.currentIndex]
            list?.listViewWillDisappear()
        }

        containerVC.viewDidDisAppear = { [weak self] in
            guard let self else { return }
            self.currentListIsAppeared = false
            let list = self.validListDict[self.currentIndex]
            list?.listViewDidDisappear()
        }
    }
}

extension DLTCategoryContainerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let percent = scrollView.contentOffset.x / scrollView.bounds.width
        delegate?.containerViewDidScroll(self, percent: percent)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //生命周期通知
        handlePageChange()
        // 通知DLTCategoryTitleView index 变了
        delegate?.containerViewDidChangeIndex(self, index: currentIndex)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //生命周期通知
        handlePageChange()
        // 通知DLTCategoryTitleView index 变了
        delegate?.containerViewDidChangeIndex(self, index: currentIndex)
    }

    private func handlePageChange() {
        guard scrollView.bounds.width > 0 else { return }
        let index = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        guard index != currentIndex else { return }
        loadList(at: index)
        let oldList = validListDict[currentIndex]
        let newList = validListDict[index]
        oldList?.listViewWillDisappear()
        newList?.listViewWillAppear()
        oldList?.listViewDidDisappear()
        newList?.listViewDidAppear()
        currentIndex = index
    }
}

//用它的生命周期来检测UIScrollView上的page生命周期
class DLTCategoryContainerViewController: UIViewController {
    var viewWillAppear: (() -> Void)?
    var viewDidAppear: (() -> Void)?
    var viewWillDisappear: (() -> Void)?
    var viewDidDisAppear: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppear?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappear?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisAppear?()
    }
    
    //生命周不传给子控制器
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }

}
