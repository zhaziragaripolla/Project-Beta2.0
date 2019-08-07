//
//  SectionClearHeader.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/7/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

protocol HistoryCleanable: class {
    func cleanHistory()
}

class SectionClearHeader: UIView {

    weak var delegate: HistoryCleanable!
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("clear", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapClearHistory), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    @objc func didTapClearHistory() {
        delegate.cleanHistory()
    }
}
