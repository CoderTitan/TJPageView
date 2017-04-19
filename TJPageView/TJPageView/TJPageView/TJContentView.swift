//
//  TJContentView.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/14.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

private let kContentViewCell = "ContentViewCell"

protocol TJContentViewDelegate : class {
    func contentView( _ contentView : TJContentView, targetIndex : Int)
    func contentView( _ contentView : TJContentView, targetIndex : Int, progress : CGFloat)
}

class TJContentView: UIView {

    weak var delegate : TJContentViewDelegate?
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate lazy var isForbidDelegate : Bool = false
    fileprivate lazy var collecView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentViewCell)
        return collectionView
    }()

    init(frame: CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TJContentView{
    fileprivate func setupView(){
        for vc in childVcs {
            parentVc.addChildViewController(vc)
        }
        addSubview(collecView)
    }
}

// MARK: UICollectionViewDataSource
extension TJContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCell, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let vc = childVcs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension TJContentView : UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffX = scrollView.contentOffset.x
        if startOffsetX == scrollOffX || isForbidDelegate {return}
        //定义变量
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollOffX {//左滑
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollOffX - startOffsetX) / scrollView.bounds.width
        }else{//右滑
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollOffX) / scrollView.bounds.width
        }
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
    }
    private func contentEndScroll(){
        //滚动到的位置
        let index = Int(collecView.contentOffset.x / collecView.bounds.width)
        delegate?.contentView(self, targetIndex: index)
    }
    
}

// MARK: TJTitleViewDelegate
extension TJContentView : TJTitleViewDelegate{
    func titleView(_ titleView: TJTitleView, targetIndex: Int) {
        isForbidDelegate = true
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collecView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
