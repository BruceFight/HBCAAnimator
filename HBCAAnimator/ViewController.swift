//
//  ViewController.swift
//  HBCAAnimator
//
//  Created by jianghongbao on 2017/12/6.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
/*
 - keyPath可以使用的key -
 #define angle2Radian(angle) ((angle)/180.0*M_PI)
 /// 形变 旋转,缩放,位移
 transform.rotation.x 围绕x轴翻转 参数：角度 angle2Radian(4)
 transform.rotation.y 围绕y轴翻转 参数：同上
 transform.rotation.z 围绕z轴翻转 参数：同上
 transform.rotation 默认围绕z轴
 
 transform.scale.x x方向缩放 参数：缩放比例 1.5
 transform.scale.y y方向缩放 参数：同上
 transform.scale.z z方向缩放 参数：同上
 transform.scale 所有方向缩放 参数：同上
 
 transform.translation.x x方向移动 参数：x轴上的坐标 100
 transform.translation.y x方向移动 参数：y轴上的坐标
 transform.translation.z x方向移动 参数：z轴上的坐标
 transform.translation 移动 参数：移动到的点 （100，100）
 
 /// 属性
 opacity 透明度 参数：透明度 0.5
 backgroundColor 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
 cornerRadius 圆角 参数：圆角半径 5
 borderWidth 边框宽度 参数：边框宽度 5
 bounds 大小 参数：CGRect
 contents 内容 参数：CGImage
 contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
 hidden 是否隐藏
 position
 shadowColor
 shadowOffset
 shadowOpacity
 shadowRadius *
 */

class ViewController: UIViewController ,CAAnimationDelegate ,UICollectionViewDelegate ,UICollectionViewDataSource {
    
    fileprivate var tree = UIImageView()
    fileprivate var mainCollectionView : UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 50) / 2
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        mainCollectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        mainCollectionView?.backgroundColor = .white
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        mainCollectionView?.register(HBCAShowCell.self, forCellWithReuseIdentifier: "CAShowCell")
        if let collection = mainCollectionView {
            view.addSubview(collection)
        }
        
        tree.frame = CGRect.init(x: 0, y: 100, width: 100, height: 100)
        tree.image = #imageLiteral(resourceName: "lufei6")
        let manager = HBCAManager()
        manager.params = KeyFrameParams.init(values: [0.2,-0.5,0.5,-0.2], duration: 3, autoreverses: true, max: .infinity, beginTime: CACurrentMediaTime(), anchorType: .bottomCenter, position: CGPoint.init(x: tree.center.x, y: tree.frame.maxY), timing: CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut))
        manager.HBCAAnimate(keyType: CARotate.z, caType: CAType.keyFrame, layer: tree.layer)
        view.addSubview(tree)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CAShowCell", for: indexPath)
        
        return cell
    }
}
