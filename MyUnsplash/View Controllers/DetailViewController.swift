//
//  DetailViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel: DetailViewModel!
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    func layoutUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        tabBarController?.tabBar.isHidden = true
        let yPosition = UIApplication.shared.statusBarFrame.size.height
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.width, height: 44))
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        setupImages()
    }
    
    func setupImages(){
        
        for i in 0..<viewModel.photos.count {
            let imageView = UIImageView()
            imageView.af_setImage(withURL: viewModel.showPhoto(at: i)!)
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            let xInitialPos = UIScreen.main.bounds.width *  CGFloat(viewModel.startIndex)
            scrollView.contentOffset = CGPoint(x: xInitialPos, y: 0)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
        }
        
    }
    
    @objc func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
}
