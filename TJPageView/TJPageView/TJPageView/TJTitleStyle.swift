//
//  TJTitleStyle.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/14.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

class TJTitleStyle {

    var titleHeight : CGFloat = 44//高度
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    var selectColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    var titleFont   : CGFloat = 15.0//字体大小
    var isScrollEnable : Bool = false// 是否可以滚动
    var itemMargin : CGFloat = 30           //间距

    //**底部滚动条*/
    var isShowBottomLine : Bool = true//
    var bottomLineColor : UIColor = UIColor.red
    var bottomLineHeight : CGFloat = 2.0
    
    //
    var isTitleScale : Bool = false
    var scaleRange : CGFloat = 1.2

    //**表面滚动块*/
    var isShowCoverView : Bool = true
    var coverColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMagin : CGFloat = 8
    var coverHeight : CGFloat = 25
    
    
    
}
