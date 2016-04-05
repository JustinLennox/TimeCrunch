
import UIKit
import QuartzCore

class RingLayer : CAShapeLayer {
    
    override init() {
        super.init()
    }
    
    override init(layer: AnyObject) {
        super.init()
        
    }
    
    init(x: Double, y: Double, width: Double, height: Double){
        super.init()
        fillColor = UIColor.clearColor().CGColor
        lineWidth = 15.0
        let bezPath = UIBezierPath(ovalInRect: CGRect(x: x, y: y, width: width, height: height))
        bezPath.lineCapStyle = .Round
        path = bezPath.CGPath
        lineCap = kCALineCapRound
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateStroke(timerSeconds : Int) {
        let seconds = timerSeconds % 60
        strokeColor = UIColor.TimeCrunchBlue().CGColor
        let strokeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = seconds > 0 ? Float(seconds) / 60.0 : 0
        strokeAnimation.toValue = seconds > 0 ? Float(seconds + 1) / 60.0 : 0.0166667
        strokeAnimation.duration = 1.1
        addAnimation(strokeAnimation, forKey: nil)
    }
}
