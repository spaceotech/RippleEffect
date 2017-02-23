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
    
    var circleShape = CALayer()
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        if (self.imageView!.image != nil) {
            self.circleShape = self.createImageShapeWithPosition(CGPointMake(width / 2, height / 2), pathRect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.imageView!.image!.size.width, self.imageView!.image!.size.height))
            self.circleShape.contents = (self.imageView!.image!.CGImage! as AnyObject)
        }
        else {
            self.circleShape = self.createCircleShapeWithPosition(CGPointMake(width / 2, height / 2), pathRect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height), radius: self.layer.cornerRadius)
        }
        self.layer.addSublayer(self.circleShape)
        return true
    }
    
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        let point = touch!.locationInView(self)
        if point.x < 0 || point.y < 0 || point.x > self.bounds.size.width || point.y > self.bounds.size.height {
            self.circleShape.removeFromSuperlayer()
        }
        else {
            let scale: CGFloat = 2.5
            let groupAnimation = self.createFlashAnimationWithScale(scale, duration: 0.5)
            //
            //groupAnimation["circleShaperLayer"] = self!.circleShape
            groupAnimation.delegate = self
            self.circleShape.addAnimation(groupAnimation, forKey: nil)
        }
    }
    
    
    func createImageShapeWithPosition(position: CGPoint, pathRect rect: CGRect) -> CALayer {
        let imageLayer = CALayer()
        imageLayer.bounds = rect
        imageLayer.position = position
        return imageLayer
    }
    
    
    func createCircleShapeWithPosition(position: CGPoint, pathRect rect: CGRect, radius: CGFloat) -> CAShapeLayer {
        let circleShape = CAShapeLayer()
        circleShape.path = self.createCirclePathWithRadius(rect, radius: radius)
        circleShape.position = position
        circleShape.fillColor = UIColor.clearColor().CGColor
        circleShape.strokeColor = UIColor.purpleColor().CGColor
        circleShape.opacity = 0
        circleShape.lineWidth = 1
        return circleShape
    }
    
    
    func createFlashAnimationWithScale(scale: CGFloat, duration: CGFloat) -> CAAnimationGroup {
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
    
    
    func createCirclePathWithRadius(frame: CGRect, radius: CGFloat) -> CGPathRef {
        return UIBezierPath(roundedRect: frame, cornerRadius: radius).CGPath
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //var layer = (anim.valueForKey("circleShaperLayer") as! String)
//        if layer != nil {
//            layer.removeFromSuperlayer()
//        }
    }

}
