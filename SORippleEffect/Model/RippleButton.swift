//
//  RippleButton.swift
//  SORippleEffect
//
//  Created by Hitesh on 2/23/17.
//  Copyright © 2017 spaceo. All rights reserved.
//

import UIKit

class RippleButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var animateLayer = CALayer()
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        if (self.imageView!.image != nil) {
            self.animateLayer = self.drawimgShape(CGPointMake(width / 2, height / 2), rect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.imageView!.image!.size.width, self.imageView!.image!.size.height))
            self.animateLayer.contents = (self.imageView!.image!.CGImage! as AnyObject)
        }
        else {
            self.animateLayer = self.drawCircle(CGPointMake(width / 2, height / 2), rect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height), radius: self.layer.cornerRadius)
        }
        self.layer.addSublayer(self.animateLayer)
        return true
    }
    
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        let point = touch!.locationInView(self)
        if point.x < 0 || point.y < 0 || point.x > self.bounds.size.width || point.y > self.bounds.size.height {
            self.animateLayer.removeFromSuperlayer()
        }
        else {
            let scale: CGFloat = 2.5
            let groupAnimation = self.animateWithFlash(scale, duration: 0.5)
            //
            //groupAnimation["circleShaperLayer"] = self!.circleShape
            groupAnimation.delegate = self
            self.animateLayer.addAnimation(groupAnimation, forKey: nil)
        }
    }
    
    
    func drawimgShape(pos: CGPoint, rect: CGRect) -> CALayer {
        let imgLayer = CALayer()
        imgLayer.bounds = rect
        imgLayer.position = pos
        return imgLayer
    }
    
    
    func drawCircle(pos: CGPoint, rect: CGRect, radius: CGFloat) -> CAShapeLayer {
        let circleShape = CAShapeLayer()
        circleShape.path = self.drawCircleWithRadius(rect, radius: radius)
        circleShape.position = pos
        circleShape.fillColor = UIColor.clearColor().CGColor
        circleShape.strokeColor = UIColor.purpleColor().CGColor
        circleShape.opacity = 0
        circleShape.lineWidth = 1
        return circleShape
    }
    
    
    func animateWithFlash(scale: CGFloat, duration: CGFloat) -> CAAnimationGroup {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(scale, scale, 1))
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 1.0
        return animation
    }
    
    
    func drawCircleWithRadius(frame: CGRect, radius: CGFloat) -> CGPathRef {
        return UIBezierPath(roundedRect: frame, cornerRadius: radius).CGPath
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //var layer = (anim.valueForKey("circleShaperLayer") as! String)
//        if layer != nil {
//            layer.removeFromSuperlayer()
//        }
    }

}
