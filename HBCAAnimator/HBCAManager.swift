//
//  HBCAManager.swift
//  HBCAAnimator
//
//  Created by jianghongbao on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

enum KLAnchorType {
    case topLeft
    case topCenter
    case topRight
    case centerLeft
    case center
    case centerRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint.init(x: 0, y: 0)
        case .topCenter:
            return CGPoint.init(x: 0.5, y: 0)
        case .topRight:
            return CGPoint.init(x: 1, y: 0)
        case .centerLeft:
            return CGPoint.init(x: 0, y: 0.5)
        case .center:
            return CGPoint.init(x: 0.5, y: 0.5)
        case .centerRight:
            return CGPoint.init(x: 1, y: 0.5)
        case .bottomLeft:
            return CGPoint.init(x: 0, y: 1)
        case .bottomCenter:
            return CGPoint.init(x: 0.5, y: 1)
        case .bottomRight:
            return CGPoint.init(x: 1, y: 1)
        }
    }
}

protocol CAAnimationTypeProtocol {
    
}

enum CARotate: String, CAAnimationTypeProtocol {
    case x = "transform.rotation.x"
    case y = "transform.rotation.y"
    case z = "transform.rotation.z"
    case all = "transform.rotation" //默认围绕z轴
}

enum CAScale: String, CAAnimationTypeProtocol {
    case x = "transform.scale.x"
    case y = "transform.scale.y"
    case z = "transform.scale.z"
    case all = "transform.scale" //所有方向缩放
}

enum CATranslation: String, CAAnimationTypeProtocol {
    case x = "transform.translation.x"
    case y = "transform.translation.y"
    case z = "transform.translation.z"
    case all = "transform.translation" //移动到点
}

enum CAProperty: String, CAAnimationTypeProtocol {
    case opacity         = "opacity"
    case backgroundColor = "backgroundColor" //CGColor
    case cornerRadius    = "cornerRadius"
    case borderWidth     = "borderWidth"
    case bounds          = "bounds"
    case contents        = "contents"
    case contentsRect    = "contentsRect"
    case isHidden        = "hidden"
    case position        = "position"
    case shadowColor     = "shadowColor"
    case shadowOffset    = "shadowOffset"
    case shadowOpacity   = "shadowOpacity"
    case shadowRadius    = "shadowRadius"
}

enum CAType {
    case group
    case property
    case basic
    case keyFrame
    case spring
}

protocol Params {
    func caType() -> CAType
}

class BasicParams: Params {
    func caType() -> CAType {
        return .basic
    }
    
    /// default 0
    var from: CGFloat = 0
    /// default 0
    var to: CGFloat = 0
    /// default 3
    var duration: TimeInterval = 3
    /// default .infinity
    var max: Float = .infinity
    /// default CACurrentMediaTime()
    var beginTime: CFTimeInterval = CACurrentMediaTime()
    /// default kCAMediaTimingFunctionLinear
    var timing: CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

class PropertyParams: Params {
    func caType() -> CAType {
        return .property
    }
    
    /// default false
    var isAdditive: Bool = false
    /// default false
    var isCumulative: Bool = false
    /// default nil
    var valueFunction: CAValueFunction? = nil
    /// default true
    var isRemovedOnCompletion: Bool = true
    /// default kCAMediaTimingFunctionLinear
    var timing: CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

class KeyFrameParams: Params {
    func caType() -> CAType {
        return .keyFrame
    }
    
    /// default [0]
    var values: [Any]?
    /// default 3
    var duration: TimeInterval = 3
    /// default false
    var autoreverses: Bool = false
    /// default .infinity
    var max: Float = .infinity
    /// default CACurrentMediaTime()
    var beginTime: CFTimeInterval = CACurrentMediaTime()
    /// default .bottomCenter
    var anchorType: KLAnchorType = .bottomCenter
    /// default .zero
    var position: CGPoint = .zero
    /// default .kCAMediaTimingFunctionLinear
    var timing: CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

class SpringParams: Params {
    func caType() -> CAType {
        return .spring
    }
    
    /// default 1
    var mass: CGFloat = 1
    /// default 10
    var damping: CGFloat = 10
    /// default 100
    var stiffness: CGFloat = 100
    /// default 0
    var initialVelocity: CGFloat = 0 //<正负取值>
}

class HBCAManager: NSObject, CAAnimationDelegate {
    
    open var animBeginHandler: ((_ anim: CAAnimation) -> ())?
    open var animEndHandler: ((_ anim: CAAnimation,_ flag: Bool,_ hold: UIView?) -> ())?
    weak private var hold: UIView?
    
    var params: Params?
    var keyPath: String = ""
    var layer: CALayer?
    
    /** basic type
     */
    func basicAnimate(keyPath:String,
                      layer:CALayer) -> () {
        if let param = params as? BasicParams {
            let anim = CABasicAnimation.init(keyPath: keyPath)
            anim.fromValue = param.from
            anim.toValue = param.to
            anim.duration = param.duration
            anim.repeatCount = param.max
            anim.beginTime = param.beginTime
            anim.timingFunction = param.timing
            anim.delegate = self
            layer.add(anim, forKey: "\(self)\(keyPath)")
        }
    }
    
    /** property type
     */
    func propertyAnimate(keyPath:String,
                         layer:CALayer) -> () {
        if let param = params as? PropertyParams {
            let anim = CAPropertyAnimation.init(keyPath: keyPath)
            anim.isAdditive = param.isAdditive
            anim.isCumulative = param.isCumulative
            if let valueFunction = param.valueFunction {
                anim.valueFunction = valueFunction
            }
            anim.isRemovedOnCompletion = param.isRemovedOnCompletion
            anim.timingFunction = param.timing
            layer.add(anim, forKey: "\(self)\(keyPath)")
        }
    }
    
    /** keyFrame type
     */
    func keyFrameAnimate(keyPath:String,
                        layer:CALayer) -> () {
        if let param = params as? KeyFrameParams {
            let anim = CAKeyframeAnimation.init(keyPath: keyPath)
            if let values = param.values {
                print("❤️ ---> \(values)")
                anim.values = values
            }
            anim.duration = param.duration
            anim.autoreverses = param.autoreverses
            anim.repeatCount = param.max
            anim.beginTime = param.beginTime
            anim.timingFunction = param.timing
            anim.delegate = self
            layer.anchorPoint = param.anchorType.point
            layer.position = param.position
            layer.add(anim, forKey: "\(self)\(keyPath)")
        }
    }
    
    /** spring type
     */
    func springAnimate(keyPath:String,
                       layer:CALayer) -> () {
        if let param = params as? SpringParams {
            let anim = CASpringAnimation.init(keyPath: keyPath)
            anim.mass = param.mass
            anim.damping = param.damping
            anim.stiffness = param.stiffness
            anim.initialVelocity = param.initialVelocity
            layer.add(anim, forKey: "\(self)\(keyPath)")
        }
    }
    
    func HBCAAnimate<T>(keyType:T?,caType:CAType,layer:CALayer) -> () {
        self.layer = layer
        if let realType = keyType as? CARotate {
            keyPath = realType.rawValue
        }else if let realType = keyType as? CAScale {
            keyPath = realType.rawValue
        }else if let realType = keyType as? CATranslation {
            keyPath = realType.rawValue
        }else if let realType = keyType as? CAProperty {
            keyPath = realType.rawValue
        }
        switch caType {
        case .basic:
            basicAnimate(keyPath: keyPath, layer: layer)
            break
        case .group:
            
            break
        case .keyFrame:
            keyFrameAnimate(keyPath: keyPath, layer: layer)
            break
        case .property:
            propertyAnimate(keyPath: keyPath, layer: layer)
            break
        case .spring:
            springAnimate(keyPath: keyPath, layer: layer)
            break
        }
    }
    
}

extension HBCAManager {
    func animationDidStart(_ anim: CAAnimation) {
        self.animBeginHandler?(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animEndHandler?(anim,flag,hold)
    }
}
