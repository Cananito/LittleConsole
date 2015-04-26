//
//  LittleConsole.swift
//  LittleConsole
//
//  Created by Rogelio Gudino on 3/26/15.
//  Copyright (c) 2015 Rogelio Gudino. All rights reserved.
//

import UIKit

public class LittleConsole {
    public class func log(message: String) {
        self.sharedInstance.view.log(message)
    }
    
    public class func show() {
        if let window = UIApplication.sharedApplication().keyWindow {
            self.showInWindow(window)
        } else {
            println("UIApplication's keyWindow still hasn't been created.")
        }
    }
    
    public class func showInWindow(window: UIWindow) {
        window.addSubview(self.sharedInstance.view)
    }
    
    public class func disappear() {
        self.sharedInstance.view.removeFromSuperview()
    }
    
    public class func isShowing() -> Bool {
        if let superview = self.sharedInstance.view.superview {
            return true
        }
        return false
    }
    
    public class func setSize(size: CGSize) {
        self.sharedInstance.view.size = size
    }
    
    public class func setBackgroundColor(backgroundColor: UIColor) {
        self.sharedInstance.view.backgroundColor = backgroundColor
    }
    
    public class func setTextColor(textColor: UIColor) {
        self.sharedInstance.view.textLabel.textColor = textColor
    }
    
    public class func setTextSize(textSize: Float) {
        self.sharedInstance.view.textLabel.font = UIFont.systemFontOfSize(CGFloat(textSize))
    }
    
    private static var sharedInstance = LittleConsole()
    
    private let view = LittleConsoleView(frame: CGRect(x: 0.0, y: 20.0, width: 150.0, height: 150.0))
}

private class LittleConsoleView: UIView {
    var size: CGSize = CGSize() {
        didSet {
            self.updateFrameToCurrentSize()
        }
    }
    
    private let toggleFullScreenButton = UIButton()
    private let scrollView = UIScrollView()
    private let textLabel = UILabel()
    private static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter
    }()
    
    init() {
        super.init(frame: CGRectZero)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.size = frame.size
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.size = self.bounds.size
    }
    
    func log(message: String) {
        let shouldScrollToBottom = self.scrollViewIsAtBottom()
        
        let dateString = LittleConsoleView.dateFormatter.stringFromDate(NSDate())
        if self.textLabel.text == nil || self.textLabel.text?.isEmpty == true {
            self.textLabel.text = "[\(dateString)]: \(message)"
        } else {
            self.textLabel.text = "\(self.textLabel.text!)\n[\(dateString)]: \(message)"
        }
        self.textLabel.sizeToFit()
        self.scrollView.contentSize = self.textLabel.bounds.size
        
        if shouldScrollToBottom == true {
            let y = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds)
            let newOffset = CGPoint(x: 0.0, y: y)
            self.scrollView.contentOffset = newOffset
        }
    }
    
    @objc private func toggleFullScreen(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected == true {
            self.updateFrameToFullScreen()
        } else {
            self.updateFrameToCurrentSize()
        }
    }
    
    private func setup() {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor()
        
        self.setupScrollView()
        self.setupTextLabel()
        self.setupToggleFullScreenButton()
        self.setupConstraints()
    }
    
    private func setupScrollView() {
        self.scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.scrollView)
    }
    
    private func setupTextLabel() {
        self.textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.textLabel.font = UIFont.systemFontOfSize(CGFloat(14.0))
        self.textLabel.numberOfLines = 0
        self.textLabel.userInteractionEnabled = true
        self.scrollView.addSubview(self.textLabel)
    }
    
    private func setupToggleFullScreenButton() {
        self.toggleFullScreenButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.toggleFullScreenButton.setTitle("F", forState: .Normal)
        self.toggleFullScreenButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.toggleFullScreenButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        self.toggleFullScreenButton.setBackgroundImage(UIColor.whiteColor().image(), forState: .Normal)
        self.toggleFullScreenButton.setBackgroundImage(UIColor.blackColor().image(), forState: .Selected)
        self.toggleFullScreenButton.layer.borderColor = UIColor.blackColor().CGColor
        self.toggleFullScreenButton.layer.borderWidth = 1.0
        self.toggleFullScreenButton.addTarget(self, action: Selector("toggleFullScreen:"), forControlEvents: .TouchUpInside)
        self.addSubview(self.toggleFullScreenButton)
    }
    
    private func setupConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 22.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 22.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.toggleFullScreenButton, attribute: .Trailing, multiplier: 1.0, constant: 2.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.toggleFullScreenButton, attribute: .Trailing, multiplier: 1.0, constant: 2.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    }
    
    private func updateFrameToCurrentSize() {
        UIView.animateWithDuration(0.25, animations: {
            var frame = self.frame
            frame.size = self.size
            self.frame = frame
        })
    }
    
    private func updateFrameToFullScreen() {
        UIView.animateWithDuration(0.25, animations: {
            var frame = self.frame
            frame.size = UIScreen.mainScreen().bounds.size
            frame.size.height -= 20.0
            self.frame = frame
        })
    }
    
    private func scrollViewIsAtBottom() -> Bool {
        let contentSizeHeight = self.scrollView.contentSize.height
        let scrollViewHeight = CGRectGetHeight(self.scrollView.bounds)
        
        if contentSizeHeight <= scrollViewHeight {
            return true
        }
        
        let bottom = contentSizeHeight - scrollViewHeight
        if self.scrollView.contentOffset.y >= bottom {
            return true
        }
        return false
    }
}

extension UIColor {
    func image() -> UIImage {
        let frame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
