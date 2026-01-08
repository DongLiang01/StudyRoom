//
//  DLTSideMenuView.swift
//  myBook
//
//  Created by dongliang on 2025/12/8.
//

import UIKit

class DLTSideMenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    var editState: Bool = false
    var dataArray: NSMutableArray = ["栏目1","栏目2","栏目3","栏目4"]
    
    
    // MARK: -override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DLTThemeManager.shareManager.bgColor
        
        addSubview(self.tableView)
        addSubview(self.editButton)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(editButton.snp.top)
        }
        editButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeAreaBottom)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DLTSideMenuCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DLTSideMenuCell.self), for: indexPath) as! DLTSideMenuCell
        let name: String = dataArray[indexPath.row] as! String
        cell.refreshData(self.editState, name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name: String = dataArray[indexPath.row] as! String
        print("点击了:" + name)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: -action
    @objc func editColumn() {
        self.editState = !self.editState
        if self.editState {
            editButton.setTitle("完成", for: .normal)
        }else{
            editButton.setTitle("编辑栏目", for: .normal)
        }
        tableView.reloadData()
    }
    
    // MARK: -getter
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.backgroundColor = DLTThemeManager.shareManager.bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(DLTSideMenuCell.self, forCellReuseIdentifier:String(describing: DLTSideMenuCell.self))
        return tableView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("编辑栏目", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: FontPingFangRe, size: 16)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(editColumn), for: .touchUpInside)
        return button
    }()
}

