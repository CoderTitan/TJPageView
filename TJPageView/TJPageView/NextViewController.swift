//
//  NextViewController.swift
//  TJPageView
//
//  Created by zcm_iOS on 2017/6/12.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit
private let kEmoticonCellID = "kEmoticonCellID"

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        titleVi()
        
        setupCollectionView()
    }
}

extension NextViewController{
    fileprivate func titleVi(){
        let styl = TJTitleStyle()
        let titleVi = TJTitleView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), titles: [], style: styl)
        view.addSubview(titleVi)
    }
    
    
    fileprivate func setupCollectionView(){
        // 1.设置显示样式
        let style = TJTitleStyle()
        style.isShowBottomLine = true
        style.isShowCover = true
        
        //2.设置cell布局Layout
        let layout = TJPageCollectionLayout()
        layout.cols = 7 // 列
        layout.rows = 3 // 行
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //3.创建collectionView
        let pageCollection = TJPageCollectionView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: UIScreen.main.bounds.width, height: 300), style: style, titles: ["普通", "粉丝专属"], isTitleInTop: false, layout: layout)
        pageCollection.delegate = self
        pageCollection.dataSource = self
        view.addSubview(pageCollection)
        
        pageCollection.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
    }

}

//MARK: TJCollectionViewDateSource
extension NextViewController : TJPageCollectionViewDateSource{
    func numberOfSections(in pageCollectionView: TJPageCollectionView) -> Int {
        return EmotionViewModel.shareInstance.emotionPackArray.count
    }
    func pageCollectionView(_ collectionView: TJPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmotionViewModel.shareInstance.emotionPackArray[section].emotionsArray.count
    }
    func pageCollectionView(_ pageCollectionView: TJPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmotionViewModel.shareInstance.emotionPackArray[indexPath.section].emotionsArray[indexPath.item]
        return cell
    }
}

extension NextViewController : TJPageCollectionViewDelegate{
    func pageCollectionView(_ pageCollectionView: TJPageCollectionView, didSelectorItemAt indexPath: IndexPath) {
        let emotion = EmotionViewModel.shareInstance.emotionPackArray[indexPath.section].emotionsArray[indexPath.item]
        print(emotion.emoticonName)
    }
}

class EmotionViewModel {
    
    static let shareInstance : EmotionViewModel = EmotionViewModel()
    lazy var emotionPackArray : [EmotionPackages] = [EmotionPackages]()
    
    init() {
        emotionPackArray.append(EmotionPackages(plistName: "QHNormalEmotionSort.plist"))
        emotionPackArray.append(EmotionPackages(plistName: "QHSohuGifSort.plist"))
    }
}
