//
//  HBCAShowCell.swift
//  HBCAAnimator
//
//  Created by jianghongbao on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class HBCAShowCell: UICollectionViewCell {
    var manager = HBCAManager()
    
    var imageView = UIImageView()
    var showLabel = UILabel()
    var image = UIImage() {
        didSet{
            imageView.image = image
        }
    }
    
    var introduce : String = "Introduce" {
        didSet{
            showLabel.text = introduce
            if introduce == "cornerRadius" {
                imageView.layer.masksToBounds = true
            }else {
                imageView.layer.masksToBounds = false
            }
            
            if introduce == "shadowRadius" {
                imageView.layer.shadowColor = UIColor.red.cgColor
            }else {
                imageView.layer.shadowColor = UIColor.gray.cgColor
            }
        }
    }
    var animType : Any?
    var params : Params?
    var type : CAType = .keyFrame {
        didSet{
            if let p = params as? KeyFrameParams {
                p.position = CGPoint.init(x: imageView.center.x, y: imageView.frame.maxY)
                manager.params = p
                manager.HBCAAnimate(keyType: animType, caType: type, layer: imageView.layer)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.layer.removeAllAnimations()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.layer.cornerRadius = 10 //0
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        imageView.layer.shadowOpacity = 0.5 //[0...1]
        imageView.layer.shadowRadius = 5 //3
        addSubview(imageView)
        showLabel.textAlignment = .center
        showLabel.text = "Introduce"
        showLabel.font = UIFont.systemFont(ofSize: 13)
        showLabel.textColor = .black
        addSubview(showLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageWidth : CGFloat = bounds.width * 0.7
        imageView.frame = CGRect.init(x: (bounds.width - imageWidth) / 2, y: 0, width: imageWidth, height: imageWidth)
        showLabel.frame = CGRect.init(x: 0, y: imageView.frame.maxY, width: bounds.width, height: bounds.height * 0.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
