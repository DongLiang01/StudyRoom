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
        //self.view.safeAreaLayoutGuide.snp.top 就是留海的下方区域
        columnBtn.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
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

}

