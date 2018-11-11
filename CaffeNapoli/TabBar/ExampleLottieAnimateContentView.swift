//
//  ExampleLottieAnimateContentView.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/11/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import Foundation
import Lottie
import ESTabBarController_swift
import pop


class ExampleLottieAnimateBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(red: 61/255.0, green: 206/255.0, blue: 193/255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1.0)
        iconColor = UIColor.init(red: 61/255.0, green: 206/255.0, blue: 193/255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



/*
class ExampleLottieAnimateContentView: ExampleLottieAnimateBasicContentView {
    
    let lottieView: LAAnimationView! = {
        let lottieView = LAAnimationView.animationNamed("IconTransitions")
        lottieView?.loopAnimation = true
        lottieView?.contentMode = .scaleAspectFit
        lottieView?.play()
        return lottieView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lottieView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        lottieView.frame = self.bounds.insetBy(dx: -2, dy: -2)
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        super.selectAnimation(animated: animated, completion: nil)
        lottieView.pause()
    }
    
    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        super.deselectAnimation(animated: animated, completion: nil)
        lottieView.play()
    }
    
}
*/

class ExampleBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
//        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        highlightTextColor = UIColor.tableViewBackgroundColor
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
//        highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        highlightIconColor = UIColor.tableViewBackgroundColor
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ExampleBackgroundContentView: ExampleBasicContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 165.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 165.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = UIColor.init(red: 37/255.0, green: 39/255.0, blue: 42/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 22/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0)
    }
    
    public convenience init(specialWithAutoImplies implies: Bool) {
        self.init(frame: CGRect.zero)
        textColor = .white
        highlightTextColor = .white
        iconColor = .white
        highlightIconColor = .white
        backdropColor = UIColor.init(red: 17/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 22/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0)
        if implies {
            let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ExampleBackgroundContentView.playImpliesAnimation(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc internal func playImpliesAnimation(_ sender: AnyObject?) {
        if self.selected == true || self.highlighted == true {
            return
        }
        let view = self.imageView
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.15, 0.8, 1.15]
        impliesAnimation.duration = 0.3
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        impliesAnimation.isRemovedOnCompletion = true
        view.layer.add(impliesAnimation, forKey: nil)
    }
}
class ExampleBouncesContentView: ExampleBasicContentView {
    
    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}
class ExampleAnimateTipsContentView: ExampleBackgroundContentView {
    
    var duration = 0.3
    
    override func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        super.badgeChangedAnimation(animated: animated, completion: nil)
        notificationAnimation()
    }
    
    func notificationAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        impliesAnimation.values = [0.0 ,-8.0, 4.0, -4.0, 3.0, -2.0, 0.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}

class ExampleAnimateTipsContentView2: ExampleAnimateTipsContentView {
    
    override func notificationAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        self.badgeView.layer.add(impliesAnimation, forKey: nil)
    }
}

class ExampleAnimateTipsContentView3: ExampleAnimateTipsContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        badgeColor = UIColor.clear
        badgeView.imageView.image = UIImage.init(named: "tips2")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 25, right: 25)).withRenderingMode(.alwaysTemplate)
        badgeView.tintColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleHighlightableContentView: ExampleBackgroundContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = imageView.transform.scaledBy(x: 0.8, y: 0.8)
        imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)
        UIView.commitAnimations()
        completion?()
    }
    
}
class ExampleIrregularityBasicContentView: ExampleBouncesContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        backdropColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ExampleIrregularityContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.imageView.backgroundColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.imageView.backgroundColor = UIColor.tableViewBackgroundColor
        self.imageView.layer.borderWidth = 3.0
//        self.imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
        self.imageView.layer.borderColor = UIColor.tableViewBackgroundColor.cgColor
        self.imageView.layer.cornerRadius = 35
        self.insets = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        self.superview?.bringSubviewToFront(self)
        
//        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        textColor = UIColor.tableViewBackgroundColor
        highlightTextColor = UIColor.tableViewBackgroundColor
//        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.tableViewBackgroundColor
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }
    
    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
    
    public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
        view.layer.cornerRadius = 1.0
        view.layer.opacity = 0.5
        view.backgroundColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
        self.addSubview(view)
        playMaskAnimation(animateView: view, target: self.imageView, completion: {
            [weak view] in
            view?.removeFromSuperview()
            completion?()
        })
    }
    
    public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    

    private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> ())?) {
        view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)
        
        let scale = POPBasicAnimation.init(propertyNamed: kPOPLayerScaleXY)
        scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.0, height: 1.0))
        scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 36.0, height: 36.0))
        scale?.beginTime = CACurrentMediaTime()
        scale?.duration = 0.3
        scale?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        scale?.removedOnCompletion = true
        
        let alpha = POPBasicAnimation.init(propertyNamed: kPOPLayerOpacity)
        alpha?.fromValue = 0.6
        alpha?.toValue = 0.6
        alpha?.beginTime = CACurrentMediaTime()
        alpha?.duration = 0.25
        alpha?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        alpha?.removedOnCompletion = true
        
        view.layer.pop_add(scale, forKey: "scale")
        view.layer.pop_add(alpha, forKey: "alpha")
        
        scale?.completionBlock = ({ animation, finished in
            completion?()
        })
    }
    
}

class ExampleTipsBasicContentView: ExampleBouncesContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        backdropColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 10/255.0, green: 66/255.0, blue: 91/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleTipsContentView: ExampleTipsBasicContentView {
    
    var tipsImageView: UIImageView = {
        let tipsImageView = UIImageView.init(image: UIImage.init(named: "tips")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 10, left: 10, bottom: 25, right: 25), resizingMode: UIImage.ResizingMode.stretch))
        return tipsImageView
    }()
    
    var tipsLabel: UILabel = {
        let tipsLabel = UILabel.init(frame: CGRect.zero)
        tipsLabel.text = "发现新版本"
        tipsLabel.font = UIFont.systemFont(ofSize: 14.0)
        tipsLabel.textColor = UIColor.white
        return tipsLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tipsImageView)
        self.addSubview(self.tipsLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipsImageView.frame = CGRect.init(x: bounds.size.width - 92, y: -38, width: 92, height: 36)
        tipsLabel.sizeToFit()
        tipsLabel.center = CGPoint.init(x: tipsImageView.center.x, y: tipsImageView.center.y - 3)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
