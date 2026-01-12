//
//  DLTSideMenuCell.swift
//  myBook
//
//  Created by dongliang on 2025/12/28.
//

import UIKit

class DLTSideMenuCell: UITableViewCell {
    var dragAction: ((UILongPressGestureRecognizer) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubUI() {
        self.contentView.backgroundColor = DLTThemeManager.shareManager.bgColor
        self.contentView.addSubview(self.nameTF)
        self.contentView.addSubview(self.dragImgView)
        self.contentView.addSubview(self.bottomLine)
        nameTF.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(dragImgView.snp.leading).offset(-20)
        }
        dragImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        bottomLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: -action
    func refreshData(_ editState: Bool, _ columnName: String) {
        dragImgView.isHidden = !editState
        nameTF.isEnabled = editState
        nameTF.text = columnName
        if editState {
            nameTF.layer.borderWidth = 1
            nameTF.backgroundColor = DLTThemeManager.shareManager.DLT_F7F8FA_20242C
        }else{
            nameTF.layer.borderWidth = 0
            nameTF.backgroundColor = DLTThemeManager.shareManager.bgColor
        }
    }
    
    @objc func longPressToDrag(sender: UILongPressGestureRecognizer) {
        dragAction?(sender)
    }
    
    // MARK: -getter
    private lazy var nameTF: DLTTextField = {
        let tf = DLTTextField()
        tf.textColor = DLTThemeManager.shareManager.DLT_333333_FFFFFF
        tf.font = UIFont(name: FontPingFangRe, size: 16)
        tf.text = "你好"
        tf.delegate = self
        tf.isEnabled = false
        tf.padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = DLTThemeManager.shareManager.DLT_F7F8FA_20242C?.cgColor
        return tf
    }()
    
    private lazy var dragImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "dlt_icon_drag"))
        imgView.isHidden = true
        imgView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToDrag(sender:)))
        imgView.addGestureRecognizer(longPress)
        return imgView
    }()
    
    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = DLTThemeManager.shareManager.DLT_F7F8FA_20242C
        return line
    }()
}

extension DLTSideMenuCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
