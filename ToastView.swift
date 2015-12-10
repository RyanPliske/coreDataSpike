import UIKit

typealias ToastViewCompletion = () -> ()

class ToastView: UIView {
    
    var toastMessage = ""
    var dismissDelayTime: NSTimeInterval = 3
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.blackColor()
        layer.cornerRadius = 5.0
        alpha = 0.0
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.blackColor()
        layer.cornerRadius = 5.0
        alpha = 0.0
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
        layer.cornerRadius = 5.0
        alpha = 0.0
    }
    
    convenience init(message: String) {
        self.init()
        toastMessage = message
    }
    
    func show(completion: ToastViewCompletion?) {
        let toastLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 999))
        toastLabel.font = UIFont.systemFontOfSize(14.0)
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .Center
        toastLabel.textColor = UIColor.whiteColor()
        toastLabel.text = toastMessage
        toastLabel.sizeToFit()
        addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 4))
        addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -4))
        addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 4))
        addConstraint(NSLayoutConstraint(item: toastLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -4))
        translatesAutoresizingMaskIntoConstraints = false
        
        if let appDelegate = UIApplication.sharedApplication().delegate {
            if let mainWindow = appDelegate.window {
                if let myWindow = mainWindow {
                    myWindow.addSubview(self)
                    myWindow.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: myWindow, attribute: .CenterX, multiplier: 1.0, constant: 0))
                    myWindow.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: myWindow, attribute: .Leading, multiplier: 1.0, constant: 8))
                    myWindow.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: myWindow, attribute: .Trailing, multiplier: 1.0, constant: -8))
                    myWindow.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem: myWindow, attribute: .Bottom, multiplier: 1.0, constant: -20))
                    
                    UIView.animateWithDuration(0.15,
                        animations: { () -> Void in
                            self.alpha = 0.8
                            myWindow.setNeedsUpdateConstraints()
                        }, completion: { [unowned self](complete) -> Void in
                            self.delay(self.dismissDelayTime, closure: { () -> () in
                                self.dismissView(WithCompletion: completion)
                            })
                        })
                }
            }
        }
    }
    
    private func dismissView(WithCompletion completion: ToastViewCompletion?) {
        UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                self.alpha = 0.0
            }, completion: { (complete) -> Void in
                self.removeFromSuperview()
                completion?()
        })
    }
    
    private func delay(delay:Double, closure:()->()) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), closure)
    }
}
