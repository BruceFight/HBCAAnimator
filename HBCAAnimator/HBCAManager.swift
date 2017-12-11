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
    
    var point : CGPoint {
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

enum CARotate : String {
    case x = "transform.rotation.x"
    case y = "transform.rotation.y"
    case z = "transform.rotation.z"
    case all = "transform.rotation"
}

enum CAScale : String {
    case x = "transform.scale.x"
    case y = "transform.scale.y"
    case z = "transform.scale.z"
    case all = "transform.scale"
}

enum CATranslation : String {
    case x = "transform.translation.x"
    case y = "transform.translation.y"
    case z = "transform.translation.z"
    case all = "transform.translation"
}

enum CAProperty : String {
    /*
    case rotationX       = "transform.rotation.x"
    case rotationY       = "transform.rotation.y"
    case rotationZ       = "transform.rotation.z"
    case rotationAll     = "transform.rotation"
    case scaleX          = "transform.scale.x"
    case scaleY          = "transform.scale.y"
    case scaleZ          = "transform.scale.z"
    case scaleAll        = "transform.scale"
    case translationX    = "transform.translation.x"
    case translationY    = "transform.translation.y"
    case translationZ    = "transform.translation.z"
    case translationAll  = "transform.translation"
     */
    case opacity         = "opacity"
    case backgroundColor = "backgroundColor"
    case cornerRadius    = "cornerRadius"
    case borderWidth     = "borderWidth"
    case bounds          = "bounds"
    case contents        = "contents"
    case contentsRect    = "contentsRect"
    case hidden          = "hidden"
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
    
    /*
    var params : Params {
        switch self {
        case .group:
            BasicParams.init(from: <#T##CGFloat#>, to: <#T##CGFloat#>, duration: <#T##TimeInterval#>, max: <#T##Float#>, beginTime: <#T##CFTimeInterval#>, timing: <#T##CAMediaTimingFunction#>)
            break
        case .property:
            
            break
        case .basic:
            
            break
        case .keyFrame:
            
            break
        case .spring:
            
            break
        }
    }
    */
}

protocol Params {
    
}
struct BasicParams : Params {
    var from : CGFloat = 0
    var to : CGFloat = 0
    var duration : TimeInterval = 3
    var max : Float = 0
    var beginTime : CFTimeInterval = 0
    var timing : CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

struct PropertyParams : Params {
    var isAdditive : Bool = false
    var isCumulative : Bool = false
    var valueFunction : CAValueFunction? = nil
    var isRemovedOnCompletion : Bool = true
    var timing : CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

struct KeyFrameParams : Params {
    var values : [CFloat] = [0]
    var duration : TimeInterval = 3
    var autoreverses : Bool = false
    var max : Float = 0
    var beginTime : CFTimeInterval = 0
    var anchorType : KLAnchorType = .bottomCenter
    var position : CGPoint = .zero
    var timing : CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
}

struct SpringParams : Params {
    var mass : CGFloat = 1
    var damping : CGFloat = 10
    var stiffness : CGFloat = 100
    var initialVelocity : CGFloat = 0 //<正负取值>
}

class HBCAManager: NSObject ,CAAnimationDelegate {
    open var animBeginHandler : ((_ anim: CAAnimation) -> ())?
    open var animEndHandler : ((_ anim: CAAnimation,_ flag: Bool,_ hold: UIView?) -> ())?
    weak fileprivate var hold = UIView()
    
    var params : Params?
    /** basic type
     */
    func basicAnimate(keyPath:String,
                      layer:CALayer
                      /*
                      from:CGPoint,
                      to:CGPoint,
                      duration:TimeInterval = 3,
                      max:Float,
                      beginTime:CFTimeInterval,
                      timing:CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
                     */
                     ) -> () {
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
                         layer:CALayer
        /*
                         isAdditive:Bool,
                         isCumulative:Bool,
                         valueFunction:CAValueFunction? = nil,
                         isRemovedOnCompletion:Bool,
                         timing:CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)*/
                        ) -> () {
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
    
    /** property type
     */
    func keyFrameAnimate(keyPath:String,
                        layer:CALayer
                        /*
                        values:[CGFloat],
                        duration:TimeInterval = 3,
                        autoreverses:Bool,
                        max:Float,
                        beginTime:CFTimeInterval,
                        anchorType:KLAnchorType = .bottomCenter,
                        position:CGPoint,
                        timing:CAMediaTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)*/
                        ) -> () {
        if let param = params as? KeyFrameParams {
            let anim = CAKeyframeAnimation.init(keyPath: keyPath)
            anim.values = param.values
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
                       layer:CALayer
                        /*
                       mass:CGFloat,
                       damping:CGFloat,
                       stiffness:CGFloat,
                       initialVelocity:CGFloat*/
                       ) -> () {
        if let param = params as? SpringParams {
            let anim = CASpringAnimation.init(keyPath: keyPath)
            anim.mass = param.mass
            anim.damping = param.damping
            anim.stiffness = param.stiffness
            anim.initialVelocity = param.initialVelocity
            //anim.settlingDuration = settlingDuration
            layer.add(anim, forKey: "\(self)\(keyPath)")
        }
    }
    
    func HBCAAnimate<T>(keyType:T?,caType:CAType,layer:CALayer) -> () {
        var keyPath : String = ""
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
