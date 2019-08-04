//
//  DoubleLabelView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/4/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class DoubleLabelView: UIView {

    let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    init(headerText: String, bodyText: String) {
        headerLabel.text = headerText
        bodyLabel.text = bodyText
        
        super.init(frame: CGRect())
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(1)
        }
        
        addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
