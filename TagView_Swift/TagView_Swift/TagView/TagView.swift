//
//  TagView.swift
//  TagView_Swift
//
//  Created by Mac-os on 16/12/26.
//  Copyright © 2016年 risen. All rights reserved.
//

import UIKit

public protocol TagViewDataSource: class {
    
    func numberOfTags(in tagView: TagView) -> Int
    func tagView(_ tagView: TagView, sizeForTagAt index: Int) -> CGSize
    func tagView(_ tagView: TagView, configureTagButton tagButton: UIButton, At index: Int)
    
    func tagView(_ tagView: TagView, configureTableView tableView: UITableView, At index: Int)
    func tagView(_ tagView: TagView, configureCollectionView collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout, At index: Int)
    func tagView(_ tagView: TagView, configureCustomView customView: UIView, At index: Int)
    
}

extension TagViewDataSource {
    
    func tagView(_ tagView: TagView, configureTableView tableView: UITableView, At index: Int) {}
    func tagView(_ tagView: TagView, configureCollectionView collectionView: UICollectionView, flowLayout: UICollectionViewFlowLayout, At index: Int) {}
    func tagView(_ tagView: TagView, configureCustomView customView: UIView, At index: Int) {}
}

public class TagView: UIView {
    
    // MARK: - public
    
    public enum LayoutPlace {
        case top
        case bottom
        case left
        case right
    }
    
    public enum ContentType {
        case tableView
        case collectionView
        case customView
    }

    weak public var dataSource: TagViewDataSource? {
        didSet {
            guard let dataSource = dataSource else { return }
            
            titleView.tagSize = { [unowned self] in dataSource.tagView(self, sizeForTagAt: $0) }
            titleView.tagButtonConfigure = { [unowned self] in dataSource.tagView(self, configureTagButton: $1, At: $0) }
            titleView.tagBtnClick = { [unowned self] in self.tagBtnClick(idx: $0, btn: $1) } // TagView.tagBtnClick(self)
            
            contentView.tableViewConfigure = { [unowned self] in dataSource.tagView(self, configureTableView: $1, At: $0) }
            contentView.collectionViewConfigure = { [unowned self] in dataSource.tagView(self, configureCollectionView: $2, flowLayout: $1, At: $0) }
            contentView.customViewConfigure = { [unowned self] in dataSource.tagView(self, configureCustomView: $1, At: $0)}
            
            tagCount = dataSource.numberOfTags(in: self)
        }
    }
    
    public var titlePlace: LayoutPlace = .top {
        didSet {
            if titlePlace != oldValue {
                titleView.layoutDirection = (titlePlace == .top || titlePlace == .bottom) ? .horizontal : .vertical
                contentView.contentDirection = (titlePlace == .top || titlePlace == .bottom) ? .horizontal : .vertical
                setNeedsLayout()
                layoutIfNeeded()
            }
        }
    }
    
    public var contentType: ContentType {
        get { return contentView.contentType }
        set { contentView.contentType = newValue }
    }
    
//    public var showsIndicator: Bool {
//        get { return titleView.showsLineIndicator }
//        set { titleView.showsLineIndicator = newValue }
//    }
    
    public func showIndicatorAt(_ place: LayoutPlace) {
//        titleView.showsLineIndicator = true
        titleView.lineIndicatorPlace = place
    }
    
    public func hideIndicator() {
//        titleView.showsLineIndicator = false
        titleView.lineIndicatorPlace = nil
    }
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        addSubview(contentView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        switch titlePlace {
        case .top:
            let titleWidth = titleView.totalSize.width > frame.width ? frame.width : titleView.totalSize.width
            titleView.frame = CGRect(x: (frame.width - titleWidth) * 0.5, y: 0, width: titleWidth, height: titleView.totalSize.height)
            contentView.frame = CGRect(x: 0, y: titleView.totalSize.height, width: frame.width, height: frame.height - titleView.totalSize.height)
            contentView.setContentOffset(CGPoint(x: contentView.frame.width * CGFloat(titleView.selectedIndex), y: 0), animated: false)
        case .bottom:
            let titleWidth = titleView.totalSize.width > frame.width ? frame.width : titleView.totalSize.width
            titleView.frame = CGRect(x: (frame.width - titleWidth) * 0.5, y: frame.height - titleView.totalSize.height, width: titleWidth, height: titleView.totalSize.height)
            contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - titleView.totalSize.height)
            contentView.setContentOffset(CGPoint(x: contentView.frame.width * CGFloat(titleView.selectedIndex), y: 0), animated: false)
        case .left:
            let titleHeight = titleView.totalSize.height > frame.height ? frame.height : titleView.totalSize.height
            titleView.frame = CGRect(x: 0, y: (frame.height - titleHeight) * 0.5, width: titleView.totalSize.width, height: titleHeight)
            contentView.frame = CGRect(x: titleView.totalSize.width, y: 0, width: frame.width - titleView.totalSize.width, height: frame.height)
            contentView.setContentOffset(CGPoint(x: 0, y: contentView.frame.height * CGFloat(titleView.selectedIndex)), animated: false)
        case .right:
            let titleHeight = titleView.totalSize.height > frame.height ? frame.height : titleView.totalSize.height
            titleView.frame = CGRect(x: frame.width - titleView.totalSize.width, y: (frame.height - titleHeight) * 0.5, width: titleView.totalSize.width, height: titleHeight)
            contentView.frame = CGRect(x: 0, y: 0, width: frame.width - titleView.totalSize.width, height: frame.height)
            contentView.setContentOffset(CGPoint(x: 0, y: contentView.frame.height * CGFloat(titleView.selectedIndex)), animated: false)
        }
    }
    
    // MARK: - private
    
    fileprivate lazy var titleView: TitleScrollView = {
        let v = TitleScrollView()
        return v
    }()
    
    fileprivate lazy var contentView: ContentScrollView = {
        let v = ContentScrollView()
        v.delegate = self
        return v
    }()
    
    private var tagCount: Int {
        get { return titleView.tagCount }
        set { titleView.tagCount = newValue; contentView.contentCount = newValue }
    }
    
    private func tagBtnClick(idx: Int, btn: UIButton) {
        let offSet: CGPoint
        switch titlePlace {
        case .top, .bottom:
            offSet = CGPoint(x: CGFloat(idx) * contentView.frame.width, y: 0)
        case .left, .right:
            offSet = CGPoint(x: 0, y: CGFloat(idx) * contentView.frame.height)
        }
        contentView.setContentOffset(offSet, animated: true)
    }
    
}

extension TagView: UIScrollViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let index: Int
        switch titlePlace {
        case .top, .bottom:
            index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        case .left, .right:
            index = Int(scrollView.contentOffset.y / scrollView.frame.height)
        }
        
        titleView.selectedIndex = index
        titleView.adjustContentOffset()
//        titleView.adjustLineIndicator()
        titleView.layoutLineIndicator()
        
        if contentView.contentViews[index] == nil {
            contentView.setupContentViewAt(index: index)
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll--\(scrollView.contentSize)")
    }
    
}
















