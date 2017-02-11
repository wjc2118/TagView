//
//  ContentScrollView.swift
//  TagView_Swift
//
//  Created by Mac-os on 16/12/26.
//  Copyright © 2016年 risen. All rights reserved.
//

import UIKit

class ContentScrollView: UIScrollView {
    
    // MARK: - internal
    
    var contentType: TagView.ContentType = .tableView {
        didSet {
            if contentType != oldValue {
                setupContentViewAt(index: 0)
            }
        }
    }
    
    var contentDirection: TitleScrollView.LayoutDirection = .horizontal {
        didSet {
            if contentDirection != oldValue {
//                relayout()
            }
        }
    }
    
    var contentCount: Int = 0 {
        didSet {
            setupContentViewAt(index: 0)
        }
    }
    
    var tableViewConfigure: ((Int, UITableView)->())?
    
    var collectionViewConfigure: ((Int, UICollectionViewFlowLayout, UICollectionView)->())?
    
    var customViewConfigure: ((Int, UIView)->())?
    
    lazy var contentViews: [UIView?] = [UIView?](repeating: nil, count: self.contentCount)
    
    func setupContentViewAt(index: Int) {
        guard contentCount > 0, contentViews[index] == nil else { return }
        
        let zeroFrame = CGRect.zero
        switch contentType {
        case .tableView:
            let tableView = UITableView(frame: zeroFrame, style: .plain)
            tableViewConfigure?(index, tableView)
            addSubview(tableView)
            contentViews[index] = tableView
        case .collectionView:
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: zeroFrame, collectionViewLayout: layout)
            collectionViewConfigure?(index, layout, collectionView)
            addSubview(collectionView)
            contentViews[index] = collectionView
        case .customView:
            let customView = UIView()
            customViewConfigure?(index, customView)
            addSubview(customView)
            contentViews[index] = customView
        }
    }
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounces = false
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        relayout()
    }
    
    // MARK: - private

    private func relayout() {
        guard !contentViews.isEmpty else { return }
        
        switch contentDirection {
        case .horizontal:
            contentSize = CGSize(width: frame.width * CGFloat(contentCount), height: 0)
            for (idx, view) in contentViews.enumerated() {
                guard let view = view else { continue }
                view.frame = CGRect(x: CGFloat(idx) * frame.width, y: 0, width: frame.width, height: frame.height)
            }
        case .vertical:
            contentSize = CGSize(width: 0, height: frame.height * CGFloat(contentCount))
            for (idx, view) in contentViews.enumerated() {
                guard let view = view else { continue }
                view.frame = CGRect(x: 0, y: CGFloat(idx) * frame.height, width: frame.width, height: frame.height)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
