
//
//  ViewController.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/13.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "底部", style: .done, target: self, action: #selector(self.nextClick))
        
//        view.backgroundColor = UIColor.red
        automaticallyAdjustsScrollViewInsets = false
        
//        let titles = ["游戏","娱乐","音乐","电影","滑稽","话剧"]
        let titles = ["游戏大王","赞","音乐痴","电影迷","滑稽","话剧","游戏大王","娱乐大修娱乐大修","音乐痴音乐","电影迷电影迷","滑稽音乐痴音乐","话剧"]
        
        let style  = TJTitleStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        style.isShowCover = true
        
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        /**初始化方法
         * frame    : 坐标
         * titles   : 标题数组
         * style    : 样式
         * childVcs : 自控制器数组
         * parentVc : 父控制器
         */
        let pageView = TJPageView(frame: frame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }

    @objc fileprivate func nextClick(){
        navigationController?.pushViewController(NextViewController(), animated: true)
    }
}

