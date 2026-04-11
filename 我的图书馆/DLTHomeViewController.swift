//
//  ViewController.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/5.
//

import UIKit

class DLTHomeViewController: DLTBaseViewController {

    let menuVC = DLTSideMenuViewController()
    let titles = ["武侠","人物","历史记录","悬幻","武侠","人物","历史记录","悬幻","武侠","人物","历史记录","悬幻"]
    var views: [TestListView] {
        get {
            return titles.indices.map { index in
                TestListView(index: index)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUI()
        addMenuVC()
    }
    
    func addUI() {
        view.addSubview(self.columnBtn)
        view.addSubview(self.catrgoryView)
        view.addSubview(self.containerView)
        //self.view.safeAreaLayoutGuide.snp.top 就是留海的下方区域
        columnBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            //make.top.equalTo(kSafeAreaTop)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        catrgoryView.snp.makeConstraints { make in
            make.top.equalTo(columnBtn.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(catrgoryView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //这种方式可以监测到menuVC的生命周期
    func addMenuVC() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        menuVC.view.frame = CGRect(x: -view.bounds.width,y: 0,width: view.bounds.width,height: view.bounds.height)
    }

    @objc func openMenu() {
        menuVC.openMenu()
    }
    
    lazy var columnBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.orange
        button.setTitle("栏目", for: .normal)
        button.setTitleColor(DLTThemeManager.shareManager.DLT_333333_FFFFFF, for: .normal)
        button.titleLabel?.font = UIFont(name: FontPingFangRe, size: 14)
        button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return button
    }()

    lazy var catrgoryView: DLTCategoryTitleView = {
        let view = DLTCategoryTitleView()
        
        view.titles = titles
        view.defaultSelectedIndex = 3
        view.onSelect = { index in
            print("点击了第 \(index) 个")
        }
        view.containerView = self.containerView
        return view
    }()
    
    lazy var containerView: DLTCategoryContainerView = {
        let view = DLTCategoryContainerView()
        view.delegate = self
        return view
    }()
    
}

extension DLTHomeViewController: DLTCategoryContainerDelegate {
    func numberOfListsInlistContainerView() -> Int {
        return titles.count
    }
    
    func listContainerViewInitListForIndex(index: Int) -> any DLTCategoryListContentDelegate {
        print("开始创建第\(index+1)页")
        return TestListView(index: index)
    }
}

class TestListView: NSObject, DLTCategoryListContentDelegate {

    private let view = UIView()
    private let index: Int

    init(index: Int) {
        self.index = index
        let num = index % 4
        view.backgroundColor = [
            UIColor.red,
            UIColor.green,
            UIColor.blue,
            UIColor.orange
        ][num]

        let label = UILabel()
        label.text = "第 \(index+1) 页"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 100, width: 200, height: 40)
        view.addSubview(label)
    }

    func listView() -> UIView {
        return view
    }

    // 生命周期（你已经接好了）
    func listViewWillAppear() {
        print("即将出现")
    }
    func listViewDidAppear() {
        print("出现")
    }
    func listViewWillDisappear() {
        print("即将消失")
    }
    func listViewDidDisappear() {
        print("消失")
    }
}

