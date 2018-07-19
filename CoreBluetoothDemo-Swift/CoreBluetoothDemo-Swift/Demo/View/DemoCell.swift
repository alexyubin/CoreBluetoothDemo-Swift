//
//  DemoCell.swift
//  CoreBluetoothDemo-Swift
//
//  Created by 陈煜彬 on 2018/7/18.
//  Copyright © 2018年 陈煜彬. All rights reserved.
//

import UIKit
import SnapKit

class DemoCell: UITableViewCell {

    // 蓝牙名字
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = UIFont.systemFont(ofSize: 16)
        titleLab.textColor = UIColor.black
        return titleLab
    }()
    
    // 蓝牙Signal 信号
    lazy var signalLab: UILabel = {
        let signalLab = UILabel()
        signalLab.font = UIFont.boldSystemFont(ofSize: 14)
        signalLab.textColor = UIColor.black
        return signalLab
    }()
    
    //信号图片
    lazy var signalImageView : UIImageView = {
        let signalImageView = UIImageView()
        signalImageView.image = UIImage(named: "信号-1")
        return signalImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
        self.addSnap()
    }
    
    func setUpUI() {
        self.addSubview(titleLab)
        self.addSubview(signalLab)
        self.addSubview(signalImageView)
    }
    
    func addSnap() {
        
        signalImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(15)
        }
        
        signalLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.signalImageView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self.signalImageView)
            make.height.equalTo(20)
        }
        
        titleLab.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(self.signalImageView)
            make.height.equalTo(self.signalImageView)
            make.leading.equalTo(self.signalImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self).offset(-15)
            
        }
    
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
