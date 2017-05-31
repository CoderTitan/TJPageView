//
//  TJPageView.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/14.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

class TJPageView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : TJTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : TJTitleView!
    fileprivate var contentView : TJContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : TJTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置界面内容
extension TJPageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = TJTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = TJContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}


// MARK:- 设置TJContentView的代理
extension TJPageView : TJContentViewDelegate {
    func contentView(_ contentView: TJContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: TJContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置TJTitleView的代理
extension TJPageView : TJTitleViewDelegate {
    func titleView(_ titleView: TJTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
