//
//  ViewController.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/5.
//

import UIKit

class DLTHomeViewController: DLTBaseViewController {

    let menuVC = DLTSideMenuViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUI()
        addMenuVC()
    }
    
    func addUI() {
        view.addSubview(self.columnBtn)
        view.addSubview(self.catrgoryView)
        //self.view.safeAreaLayoutGuide.snp.top 就是留海的下方区域
        columnBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            //make.top.equalTo(kSafeAreaTop)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        catrgoryView.snp.makeConstraints { make in
            make.top.equalTo(columnBtn.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
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

    lazy var catrgoryView: DLTCategoryView = {
        let view = DLTCategoryView()
        
        view.titles = ["武侠","人物","历史记录","悬幻","武侠","人物","历史记录","悬幻","武侠","人物","历史记录","悬幻"]
        view.defaultSelectedIndex = 18
        return view
    }()
}

