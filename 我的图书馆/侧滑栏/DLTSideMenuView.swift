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
    //cell快照
    private var snapshot: UIView?
    //长按的cell对应的indexPath
    private var sourceIndexPath: IndexPath?
    
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
        cell.dragAction = { [weak self] longPressGesture in
            self?.dragAction(longPressGesture)
        }
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
    
    @objc func dragAction(_ longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: self.tableView)
        switch state {
        case .began:
            if let indexPath = tableView.indexPathForRow(at: location) {
                if let cell = tableView.cellForRow(at: indexPath) {
                    sourceIndexPath = indexPath
                    guard let tmpSnapshot = self.snapshotFromView(cell) else { return }
                    snapshot = tmpSnapshot
                    tmpSnapshot.center = cell.center
                    tmpSnapshot.alpha = 0
                    tableView.addSubview(tmpSnapshot)
                    UIView.animate(withDuration: 0.25) {
                        tmpSnapshot.center = CGPoint(x: cell.center.x, y: location.y)
                        tmpSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        tmpSnapshot.alpha = 0.98
                        cell.alpha = 0
                    } completion: { finished in
                        cell.isHidden = true
                    }
                }
            }
            //fallthrough 贯穿效果，用这个就相当于oc不写break的效果
        case .changed:
            guard let tmpSnapshot = snapshot else { return }
            guard let tmpSourceIndexPath = sourceIndexPath else { return }
            tmpSnapshot.center = CGPoint(x: tmpSnapshot.center.x, y: location.y)
            if let indexPath = tableView.indexPathForRow(at: location),
                indexPath != tmpSourceIndexPath {
                dataArray.exchangeObject(at: indexPath.row, withObjectAt: tmpSourceIndexPath.row)
                tableView.moveRow(at: tmpSourceIndexPath, to: indexPath)
                sourceIndexPath = indexPath
            }
        case .ended:
            guard let tmpSourceIndexPath = sourceIndexPath else { return }
            guard let cell = tableView.cellForRow(at: tmpSourceIndexPath) else { return }
            guard let tmpSnapshot = snapshot else { return }
            UIView.animate(withDuration: 0.25) {
                tmpSnapshot.center = cell.center
                tmpSnapshot.transform = CGAffineTransformIdentity
                tmpSnapshot.alpha = 0
                cell.alpha = 1
            } completion: { finished in
                cell.isHidden = false
                tmpSnapshot.removeFromSuperview()
                self.snapshot = nil
                self.sourceIndexPath = nil
            }
        default:
            break
        }
    }
    
    func snapshotFromView(_ view: UIView) -> UIView? {
        let snapshot = view.snapshotView(afterScreenUpdates: true)
        snapshot?.layer.masksToBounds = false
        snapshot?.layer.cornerRadius = 0
        snapshot?.layer.shadowOffset = CGSize(width: -5.0, height: 0)
        snapshot?.layer.shadowRadius = 5
        snapshot?.layer.shadowOpacity = 0.4
        return snapshot ?? nil
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

