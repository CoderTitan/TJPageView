//
//  TJPageView.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/14.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

//protocol TJPageViewDelegate : class {
//    pageView(pageView : tjpa)
//}

class TJPageView: UIView {

    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : TJTitleStyle
    fileprivate var titleView : TJTitleView!
    
    init(frame: CGRect , titles : [String], childVcs : [UIViewController], parentVc : UIViewController, style : TJTitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = style
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 设置UI界面
extension TJPageView{
    fileprivate func setupViews(){
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView(){
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleHeight)
        titleView = TJTitleView(frame: titleFrame, titles: titles, style: titleStyle)
        addSubview(titleView)
    }
    
    private func setupContentView(){
        let contentFrame = CGRect(x: 0, y: titleStyle.titleHeight, width: bounds.width, height: bounds.height - titleStyle.titleHeight)
        let contentView = TJContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
        
        //contentView和titleView互相成为代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
}

