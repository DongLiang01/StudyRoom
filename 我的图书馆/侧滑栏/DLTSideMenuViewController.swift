//
//  DLTSideMenuViewController.swift
//  myBook
//
//  Created by dongliang on 2025/12/8.
//

import UIKit

class DLTSideMenuViewController: DLTBaseViewController {
    
    var menuWidth: CGFloat = (kScreenWidth / 3 * 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.dimView)
        self.view.addSubview(self.menuView)
    }
    
    func openMenu() {
        UIView.animate(withDuration: 0.25) {
            self.menuView.frame.origin.x = 0
            self.dimView.alpha = 1
            self.view.frame.origin.x = 0
        }
    }
    
    @objc private func closeMenu() {
        self.view.endEditing(false)
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.x = -self.view.bounds.size.width
            self.menuView.frame.origin.x = -self.menuWidth
            self.dimView.alpha = 0
        }
    }
    
    private lazy var menuView: DLTSideMenuView = {
        let view = DLTSideMenuView()
        view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: kScreenHeight)
        return view
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        view.backgroundColor = UIColor.hex("#000000")?.withAlphaComponent(0.4)
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        view.addGestureRecognizer(tap)
        return view
    }()
    
}
