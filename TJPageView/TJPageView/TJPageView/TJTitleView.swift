//
//  TJTitleView.swift
//  TJPageView
//
//  Created by 田全军 on 2017/4/14.
//  Copyright © 2017年 Quanjun. All rights reserved.
//

import UIKit

protocol TJTitleViewDelegate : class {
    func titleView( _ titleView : TJTitleView, targetIndex : Int)
}

class TJTitleView: UIView {
    
    weak var delegate : TJTitleViewDelegate?
    fileprivate var titles : [String]
    fileprivate var style : TJTitleStyle
    fileprivate var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var  currentIndex : Int = 0
    fileprivate lazy var scrollView : UIScrollView = {
       let scrolView = UIScrollView(frame: self.bounds)
        scrolView.showsHorizontalScrollIndicator = false
        scrolView.scrollsToTop = false
        return scrolView
    }()

    init(frame: CGRect, titles : [String], style : TJTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupTitleView();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TJTitleView{
    fileprivate func setupTitleView(){
        addSubview(scrollView)
        
        addTitleLabels()
        //设置label的frame
        setupTitleLabelFrame()
    }
    private func addTitleLabels(){
        for (i ,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: style.titleFont)
            titleLabel.textAlignment = .center
            titleLabel.tag = i
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
        }
    }
    private func setupTitleLabelFrame(){
        let count = titles.count
        for (i , label) in titleLabels.enumerated() {
            var x : CGFloat = 0
            var w : CGFloat = 0
            
            if style.isScrollEnable {//可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: style.titleFont)], context: nil).width
                x = i == 0 ? style.itemMargin * 0.5 : titleLabels[i - 1].frame.maxX + style.itemMargin
            }else{//不可以滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }
            label.frame = CGRect(x: x, y: 0, width: w, height: bounds.height)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK: 监听事件
extension TJTitleView{
    //红色下划线_表示不需要外部参数
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer){
        let targetLabel = tap.view as! UILabel
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        //设置代理
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    
    fileprivate func adjustTitleLabel(targetIndex : Int){
        if targetIndex == currentIndex  {return}
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        targetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        //记录下标值
        currentIndex = targetIndex
        
        //调整位置
        if style.isScrollEnable {
            var offerX = targetLabel.center.x - scrollView.bounds.width * 0.5
            if offerX < 0 {
                offerX = 0
            }
            if offerX > scrollView.contentSize.width - scrollView.bounds.width{
                offerX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offerX, y: 0), animated: true)
        }
        
    }
}

// MARK: TJContentViewDelegate
extension TJTitleView : TJContentViewDelegate{
    func contentView(_ contentView: TJContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    func contentView( _ contentView : TJContentView, targetIndex : Int, progress : CGFloat){
        //取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        print(currentIndex,targetIndex)
        //修改渐变颜色
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)

    }
}
