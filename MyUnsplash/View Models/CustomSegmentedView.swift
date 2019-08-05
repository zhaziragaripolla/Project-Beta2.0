//
//  CustomSegmentedView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/5/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class CustomSegmentedView: UIView {

    let segmentView: UISegmentedControl = {
        let segmentView = UISegmentedControl(items: ["Photos" , "Likes", "Collections"])
        segmentView.selectedSegmentIndex = 0
        segmentView.layer.cornerRadius = 5
        return segmentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layoutUI()
    }
    
    private func layoutUI() {
        addSubview(segmentView)
        
        segmentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
