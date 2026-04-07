//
//  DLTCategoryContainerView.swift
//  myBook
//
//  Created by dongliang on 2026/1/23.
//

import UIKit

class DLTCategoryContainerView: UIView {
    // MARK: -Public Properties
    var defaultSelectedIndex: Int = 0 {
        didSet {
            currentIndex = adjustSelectedIndexIfNeeded(defaultSelectedIndex)
        }
    }
    //weak可以避免循环引用
    weak var delegate: (any DLTCategoryListContainerDelegate)?
    
    
    // MARK: -init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frameIsZero = scrollView.frame.isEmpty
        let sizeChanged = scrollView.frame.size != self.bounds.size
        if frameIsZero || sizeChanged {
            scrollView.frame = self.bounds
            let num = delegate?.numberOfListsInlistContainerView() ?? 0
            let width = scrollView.bounds.size.width
            scrollView.contentSize = CGSize(width: CGFloat(num) * width, height: scrollView.bounds.size.height)
            
        }else{
            scrollView.frame = self.bounds
            let num = delegate?.numberOfListsInlistContainerView() ?? 0
            let width = scrollView.bounds.size.width
            scrollView.contentSize = CGSize(width: CGFloat(num) * width, height: scrollView.bounds.size.height)
        }
    }
    
    // MARK: -Private Properties
    private var validListDict: [Int: DLTCategoryListContentDelegate] = [:]
    private(set) var currentIndex : Int = 0
    
    // MARK: -Private Methods
    private func addUI() {
        addSubview(containerVC.view)
        addSubview(scrollView)
    }
    
    //修正SelectedIndex
    private func adjustSelectedIndexIfNeeded(_ index: Int) -> Int {
        guard let delegate = delegate else {return 0}
        let num = delegate.numberOfListsInlistContainerView()
        guard num > 0 else {return 0}
        return max(0, min(index, num - 1))
    }
    
    // MARK: -getter
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
        vc.viewWillAppear = {
            print("WillAppear")
        }
        vc.viewDidAppear = {
            print("DidAppear")
        }
        return vc
    }()
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
