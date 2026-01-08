//
//  DLTBaseViewController.swift
//  myBook
//
//  Created by dongliang on 2025/12/9.
//

import UIKit

class DLTBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DLTThemeManager.shareManager.bgColor
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
