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
            print("UIApplication's keyWindow still hasn't been created.")
        }
    }
    
    public class func showInWindow(window: UIWindow) {
        window.addSubview(self.sharedInstance.view)
    }
    
    public class func disappear() {
        self.sharedInstance.view.removeFromSuperview()
    }
    
    public class func isShowing() -> Bool {
        if let _ = self.sharedInstance.view.superview {
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
    
    private let view = LittleConsoleView(frame: CGRect(x: 0.0, y: 20.0, width: 200.0, height: 150.0))
}

private class LittleConsoleView: UIView {
    var size: CGSize = CGSize() {
        didSet {
            self.updateFrameToCurrentSize()
        }
    }
    
    private let toggleFullScreenButton = UIButton()
    private let clearConsoleButton = UIButton()
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
    
    required init?(coder aDecoder: NSCoder) {
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
    
    @objc private func clearConsole(sender: UIButton) {
        self.textLabel.text = ""
        self.textLabel.sizeToFit()
        self.scrollView.contentSize = self.textLabel.bounds.size
        self.scrollView.contentOffset = CGPointZero
    }
    
    private func setup() {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor()
        
        self.setupScrollView()
        self.setupTextLabel()
        self.setupToggleFullScreenButton()
        self.setupClearConsoleButton()
        self.setupConstraints()
    }
    
    private func setupScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.scrollView)
    }
    
    private func setupTextLabel() {
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont.systemFontOfSize(CGFloat(14.0))
        self.textLabel.numberOfLines = 0
        self.textLabel.userInteractionEnabled = true
        self.scrollView.addSubview(self.textLabel)
    }
    
    private func setupToggleFullScreenButton() {
        self.setupButton(self.toggleFullScreenButton, title: "F", selectorString: "toggleFullScreen:")
        self.addSubview(self.toggleFullScreenButton)
    }
    
    private func setupClearConsoleButton() {
        self.setupButton(self.clearConsoleButton, title: "C", selectorString: "clearConsole:")
        self.addSubview(self.clearConsoleButton)
    }
    
    private func setupButton(button: UIButton, title: String, selectorString: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.setBackgroundImage(UIColor.whiteColor().image(), forState: .Normal)
        button.setBackgroundImage(UIColor.blackColor().image(), forState: .Selected)
        button.setBackgroundImage(UIColor.blackColor().image(), forState: .Highlighted)
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: Selector(selectorString), forControlEvents: .TouchUpInside)
    }
    
    private func setupConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .Trailing, relatedBy: .Equal, toItem: self.toggleFullScreenButton, attribute: .Left, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 32.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.toggleFullScreenButton, attribute: .Top, multiplier: 1.0, constant: -2.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
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
