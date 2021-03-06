//
//  TJPageCollectionView.swift
//  TJPageView
//
//  Created by zcm_iOS on 2017/5/31.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

//MARK: 代理
protocol TJPageCollectionViewDateSource : class {
    func numberOfSections(in pageCollectionView : TJPageCollectionView) -> Int
    func pageCollectionView(_ collectionView : TJPageCollectionView, numberOfItemsInSection section : Int) -> Int
    func pageCollectionView(_ pageCollectionView : TJPageCollectionView, _ collectionView : UICollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell
}

protocol TJPageCollectionViewDelegate : class {
    func pageCollectionView(_ pageCollectionView : TJPageCollectionView, didSelectorItemAt indexPath : IndexPath)
}

//MARK: 常量
private let kCollectionViewCell = "kCollectionViewCell"

class TJPageCollectionView: UIView {

    // MARK: 代理
    weak var dataSource : TJPageCollectionViewDateSource?
    weak var delegate : TJPageCollectionViewDelegate?
    // MARK: 页面属性
    fileprivate var style : TJTitleStyle
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var layout : TJPageCollectionLayout
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var titleView : TJTitleView!
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect, style : TJTitleStyle, titles : [String], isTitleInTop : Bool, layout : TJPageCollectionLayout) {
        self.style = style
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: 界面搭建
extension TJPageCollectionView{
    fileprivate func setupUI(){
        //1.创建titleView
        let titleViewY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        titleView = TJTitleView(frame: CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titleHeight), titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        //2.创建pageControl
        let pageControllHeight : CGFloat = 20
        let pageControlY = isTitleInTop ? bounds.height - pageControllHeight : bounds.height - pageControllHeight - style.titleHeight
        pageControl = UIPageControl(frame: CGRect(x: 0, y: pageControlY , width: bounds.width, height: pageControllHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        addSubview(pageControl)
        
        //3.创建collectionView
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControllHeight), collectionViewLayout: layout)
        //        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCell)
        addSubview(collectionView)
        pageControl.backgroundColor = collectionView.backgroundColor
    }
}

// MARK: 对外暴露的方法
extension TJPageCollectionView{
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension TJPageCollectionView : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}

// MARK: UICollectionVIewDelegate
extension TJPageCollectionView : UICollectionViewDelegate{
    //结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    //结束滑动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    fileprivate func scrollViewEndScroll(){
        //取出在屏幕中显示的cell
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x + 1, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        //判断分组是否发生改变
        if sourceIndexPath.section != indexPath.section {
            //修改pageController的个数
            let itemCOunt = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCOunt - 1) / (layout.cols * layout.rows) + 1
            //设置titleView的位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            //记录
            sourceIndexPath = indexPath
        }
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectorItemAt: indexPath)
    }
}

// MARK: TJTitleViewDelegate
extension TJPageCollectionView : TJTitleViewDelegate{
    func titleView(_ titleView: TJTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        //此处若为true,则会重新调用EndDecelerating和EndDragging方法
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
}
