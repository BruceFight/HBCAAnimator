//
//  ViewController.swift
//  HBCAAnimator
//
//  Created by jianghongbao on 2017/12/6.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
/*
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
 transform.translation 移动 参数：移动到的点
 
 /// 属性
 opacity 透明度 参数：透明度 0.5
 backgroundColor 背景颜色 参数：颜色 CGColor
 cornerRadius 圆角 参数：圆角半径 5
 borderWidth 边框宽度 参数：边框宽度 5
 bounds 大小 参数：CGRect
 contents 内容 参数：CGImage
 contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
 hidden
 position
 shadowColor
 shadowOffset
 shadowOpacity
 shadowRadius *
 */

class ViewController: UIViewController ,CAAnimationDelegate ,UICollectionViewDelegate ,UICollectionViewDataSource {
    fileprivate var animImages : [UIImage] = [
        #imageLiteral(resourceName: "lufei6"),
        #imageLiteral(resourceName: "lufei2"),
        #imageLiteral(resourceName: "lufei8"),
        #imageLiteral(resourceName: "lufei4"),
        #imageLiteral(resourceName: "trans"),
        #imageLiteral(resourceName: "lufei1"),
        #imageLiteral(resourceName: "lufei7"),
        #imageLiteral(resourceName: "lufei3"),
        #imageLiteral(resourceName: "lufei9"),
        #imageLiteral(resourceName: "lufei10"),
        #imageLiteral(resourceName: "lufei12"),
        #imageLiteral(resourceName: "lufei13"),
        #imageLiteral(resourceName: "lufei14"),
        #imageLiteral(resourceName: "lufei15"),
        #imageLiteral(resourceName: "lufei16"),
        #imageLiteral(resourceName: "lufei11")]
    fileprivate var introduces : [String] = [
        "rotation",
        "scale",
        "translation",
        "opacity",
        "backgroundColor",
        "cornerRadius",
        "borderWidth",
        "bounds",
        "contents",
        "contentsRect",
        "isHidden",
        "position",
        "shadowColor",
        "shadowOffset",
        "shadowOpacity",
        "shadowRadius"
    ]
    fileprivate var valuesArray : [[Any]] = [
        [-CGFloat.pi/2,0,CGFloat.pi/2],
        [0.6,1,1.3],
        [-10,0,10],
        [0.3,0.7,1,0.7,0.3],
        [UIColor.red.cgColor,UIColor.blue.cgColor,UIColor.purple.cgColor],
        [10,20,30,20,10],
        [1,5,10,5,1],
        [CGRect.init(x: 0, y: 0, width: 20, height: 20),CGRect.init(x: 0, y: 0, width: 40, height: 40),CGRect.init(x: 0, y: 0, width: 60, height: 60)],
        [#imageLiteral(resourceName: "lufei16").cgImage!,#imageLiteral(resourceName: "lufei15").cgImage!,#imageLiteral(resourceName: "lufei9").cgImage!],
        [CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5),CGRect.init(x: 0, y: 0, width: 0.7, height: 0.7),CGRect.init(x: 0, y: 0, width: 1, height: 1)],
        [true,false,true,false],
        [CGPoint.init(x: 0, y: 0),CGPoint.init(x: 20, y: 20),CGPoint.init(x: 40, y: 40)],
        [UIColor.red.cgColor,UIColor.blue.cgColor,UIColor.purple.cgColor],
        [CGSize.init(width: 0, height: 4),CGSize.init(width: 0, height: 10),CGSize.init(width: 0, height: 20)],
        [0.3,0.5,1],
        [5,15,30,60]
    ]
    fileprivate var animTypes : [Any] = [CARotate.z,
                                         CAScale.all,
                                         CATranslation.x,
                                         CAProperty.opacity,
                                         CAProperty.backgroundColor,
                                         CAProperty.cornerRadius,
                                         CAProperty.borderWidth,
                                         CAProperty.bounds,
                                         CAProperty.contents,
                                         CAProperty.contentsRect,
                                         CAProperty.isHidden,
                                         CAProperty.position,
                                         CAProperty.shadowColor,
                                         CAProperty.shadowOffset,
                                         CAProperty.shadowOpacity,
                                         CAProperty.shadowRadius
    ]
    fileprivate var paramses = [Any]()
    
    fileprivate var tree = UIImageView()
    fileprivate var mainCollectionView : UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< valuesArray.count {
            let values = valuesArray[i]
            let param = KeyFrameParams()
            param.values = values
            param.autoreverses = true
            paramses.append(param)
        }
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
        return animImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var resultCell : HBCAShowCell?
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CAShowCell", for: indexPath) as? HBCAShowCell {
            resultCell = cell
        }
        if let cell = resultCell {
            cell.image = animImages[indexPath.row]
            cell.introduce = introduces[indexPath.row]
            cell.animType = animTypes[indexPath.row]
            if let params = paramses[indexPath.row] as? Params {
                cell.params = params
            }
            cell.type = .keyFrame
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
}
