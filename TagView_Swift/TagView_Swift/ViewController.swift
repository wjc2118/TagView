//
//  ViewController.swift
//  TagView_Swift
//
//  Created by Mac-os on 16/12/26.
//  Copyright © 2016年 risen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var tagView: TagView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let tag = TagView(/*frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300)*/)
//        tag.backgroundColor = UIColor.gray
        view.addSubview(tag)
        tag.dataSource = self
//        tag.titlePlace = .right
        tag.showIndicatorAt(.bottom)
        tagView = tag
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 300)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tagView.titlePlace = .right
        tagView.showIndicatorAt(.right)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if size.width > size.height {
            tagView.titlePlace = .left
            tagView.showIndicatorAt(.right)
        } else {
            tagView.titlePlace = .top
            tagView.showIndicatorAt(.bottom)
        }
    }

    let titles: [String] = ["A", "BB", "CCC", "DDDD", "EEEEE", ]

}

extension ViewController: TagViewDataSource {
    
    func numberOfTags(in tagView: TagView) -> Int {
        return titles.count
    }
    
    func tagView(_ tagView: TagView, sizeForTagAt index: Int) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func tagView(_ tagView: TagView, configureTagButton tagButton: UIButton, At index: Int) {
        tagButton.setTitle(titles[index], for: .normal)
//        tagButton.setTitle("XXX", for: .selected)
        tagButton.backgroundColor = UIColor.wjc.randomColor
    }
    
    func tagView(_ tagView: TagView, configureTableView tableView: UITableView, At index: Int) {
        tableView.backgroundColor = UIColor.wjc.randomColor
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
