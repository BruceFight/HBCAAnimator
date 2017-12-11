//
//  HBCAShowCell.swift
//  HBCAAnimator
//
//  Created by jianghongbao on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class HBCAShowCell: UICollectionViewCell {
    var imageView = UIImageView()
    var showLabel = UILabel()
    var image = UIImage() {
        didSet{
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
