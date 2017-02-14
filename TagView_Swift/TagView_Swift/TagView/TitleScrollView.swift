//
//  TitleScrollView.swift
//  TagView_Swift
//
//  Created by Mac-os on 16/12/26.
//  Copyright © 2016年 risen. All rights reserved.
//

import UIKit

private let LINE_INDICATOR_MINLENGTH: CGFloat = 1.0

class TitleScrollView: UIScrollView {
    
    // MARK: - internal
    
    enum LayoutDirection {
        case horizontal
        case vertical
    }
    
    var layoutDirection: LayoutDirection = .horizontal {
        didSet {
            if layoutDirection != oldValue {
                layoutTagButtons()
            }
        }
    }
    
    var tagCount = 0 {
        didSet {
            guard tagCount > 0 else { return }
            reloadData()
        }
    }
    
    var tagSize: ((Int)->CGSize)?
    
    var tagButtonConfigure: ((Int, UIButton)->())?
    
    var tagBtnClick: ((Int, UIButton)->())?
    
    var selectedIndex: Int {
        get { return tagBtns.index(of: selectedBtn) ?? 0 }
        set {
            guard newValue >= 0 && newValue < tagBtns.count else { return }
            selectedBtn = tagBtns[newValue]
        }
    }
    
    var totalSize: CGSize = CGSize.zero
    
//    var showsLineIndicator: Bool = false {
//        didSet {
//            if showsLineIndicator {
//                addSubview(lineIndicator)
//                if selectedBtn != nil { layoutLineIndicator() }
//            } else {
//                lineIndicator.removeFromSuperview()
//            }
//        }
//    }
    
    var lineIndicatorPlace: TagView.LayoutPlace? {
        didSet {
            if lineIndicatorPlace != nil {
                addSubview(lineIndicator)
                if selectedBtn != nil { layoutLineIndicator() }
            } else {
                lineIndicator.removeFromSuperview()
            }
        }
    }
    
    func layoutLineIndicator() {
        
        guard let place = lineIndicatorPlace else { return }
        
        let selectedTagBtnTitleSize = (selectedBtn.title(for: .selected) as NSString?)?.size(attributes: [NSFontAttributeName: selectedBtn.titleLabel?.font as Any]) ?? CGSize.zero
        let selectedTagBtnImageSize = selectedBtn.image(for: .selected)?.size ?? CGSize.zero
        
        lineIndicator.backgroundColor = selectedBtn.titleColor(for: .selected)
        
        switch layoutDirection {
        case .horizontal:
            lineIndicator.frame.size = CGSize(width: selectedTagBtnTitleSize.width + selectedTagBtnImageSize.width, height: LINE_INDICATOR_MINLENGTH)
            lineIndicator.center.x = selectedBtn.center.x
            if place == .top {
                lineIndicator.frame.origin.y = 0
            } else {  // as .bottom
                lineIndicator.frame.origin.y = totalSize.height - LINE_INDICATOR_MINLENGTH
            }
        case .vertical:
            lineIndicator.frame.size = CGSize(width: LINE_INDICATOR_MINLENGTH, height: max(selectedTagBtnTitleSize.height , selectedTagBtnImageSize.height))
            lineIndicator.center.y = selectedBtn.center.y
            if place == .left {
                lineIndicator.frame.origin.x = 0
            } else {  // as .right
                lineIndicator.frame.origin.x = totalSize.width - LINE_INDICATOR_MINLENGTH
            }
        }
    }
    
    func adjustContentOffset() {
        switch layoutDirection {
        case .horizontal:
            if selectedBtn.center.x < frame.width * 0.5 { // left
                setContentOffset(CGPoint.zero, animated: false)
            } else if contentSize.width - selectedBtn.center.x < frame.width * 0.5 { // right
                setContentOffset(CGPoint(x: contentSize.width - frame.width, y: 0), animated: false)
            } else {
                setContentOffset(CGPoint(x: selectedBtn.center.x - frame.width * 0.5, y: 0), animated: false)
            }
        case .vertical:
            
            if selectedBtn.center.y < frame.height * 0.5 {  // up
                setContentOffset(CGPoint.zero, animated: false)
            } else if contentSize.height - selectedBtn.center.y < frame.height * 0.5 { // low
                setContentOffset(CGPoint(x: 0, y: contentSize.height - frame.height), animated: false)
            } else {
                setContentOffset(CGPoint(x: 0, y: selectedBtn.center.y - frame.height * 0.5), animated: false)
            }
        }
    }
    
    func adjustLineIndicator() {
        
    }
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - private
    
    private lazy var tagBtns: [UIButton] = [UIButton]()
    
    private var selectedBtn: UIButton! {
        didSet {
            oldValue?.isSelected = false
            selectedBtn.isSelected = true
        }
    }
    
    private lazy var lineIndicator: UIView = {
        let v = UIView()
        return v
    }()
    
    private func reloadData() {
        
        tagBtns.removeAll()
        for i in 0..<tagCount {
            let btn = UIButton()
            tagButtonConfigure?(i, btn)
            btn.frame.size = tagSize?(i) ?? CGSize.zero
            btn.addTarget(self, action: #selector(TitleScrollView.btnClick(_:)), for: .touchUpInside)
            addSubview(btn)
            tagBtns.append(btn)
        }
        selectedIndex = 0
        
        layoutTagButtons()
        
        layoutLineIndicator()
    }
    
    private func layoutTagButtons() {
        guard !tagBtns.isEmpty else { return }
        totalSize = CGSize.zero
        switch layoutDirection {
        case .horizontal:
            for btn in tagBtns {
                btn.frame.origin = CGPoint(x: totalSize.width, y: 0)
                totalSize.width += btn.frame.width
                if totalSize.height < btn.frame.height {
                    totalSize.height = btn.frame.height
                }
            }
        case .vertical:
            for btn in tagBtns {
                btn.frame.origin = CGPoint(x: 0, y: totalSize.height)
                totalSize.height += btn.frame.height
                if totalSize.width < btn.frame.width {
                    totalSize.width = btn.frame.width
                }
            }
        }
        
        contentSize = totalSize
    }
    
    @objc private func btnClick(_ btn: UIButton) {
        guard let idx = tagBtns.index(of: btn), selectedBtn != btn else { return }
        tagBtnClick?(idx, btn)
    }
    
    
    
    
    
    
}

