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
        if let window = UIApplication.shared.keyWindow {
            self.showInWindow(window)
        } else {
            print("UIApplication's keyWindow still hasn't been created.")
        }
    }
    
    public class func showInWindow(_ window: UIWindow) {
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
    
    public class func setSize(_ size: CGSize) {
        self.sharedInstance.view.size = size
    }
    
    public class func setBackgroundColor(_ backgroundColor: UIColor) {
        self.sharedInstance.view.backgroundColor = backgroundColor
    }
    
    public class func setTextColor(_ textColor: UIColor) {
        self.sharedInstance.view.textLabel.textColor = textColor
    }
    
    public class func setTextSize(_ textSize: Float) {
        self.sharedInstance.view.textLabel.font = UIFont.systemFont(ofSize: CGFloat(textSize))
    }
    
    private static var sharedInstance = LittleConsole()
    
    private let view = LittleConsoleView(frame: CGRect(x: 0.0, y: 20.0, width: 200.0, height: 150.0))
}

fileprivate class LittleConsoleView: UIView {
    var size: CGSize = CGSize() {
        didSet {
            self.updateFrameToCurrentSize()
        }
    }
    
    fileprivate let textLabel = UILabel()
    private let toggleFullScreenButton = UIButton()
    private let clearConsoleButton = UIButton()
    private let scrollView = UIScrollView()
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter
    }()
    
    init() {
        super.init(frame: CGRect.zero)
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
    
    func log(_ message: String) {
        let shouldScrollToBottom = self.scrollViewIsAtBottom()
        
        let dateString = LittleConsoleView.dateFormatter.string(from: Date())
        if self.textLabel.text == nil || self.textLabel.text?.isEmpty == true {
            self.textLabel.text = "[\(dateString)]: \(message)"
        } else {
            self.textLabel.text = "\(self.textLabel.text!)\n[\(dateString)]: \(message)"
        }
        self.textLabel.sizeToFit()
        self.scrollView.contentSize = self.textLabel.bounds.size
        
        if shouldScrollToBottom == true {
            let y = self.scrollView.contentSize.height - self.scrollView.bounds.height
            let newOffset = CGPoint(x: 0.0, y: y)
            self.scrollView.contentOffset = newOffset
        }
    }
    
    @objc private func toggleFullScreen(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            self.updateFrameToFullScreen()
        } else {
            self.updateFrameToCurrentSize()
        }
    }
    
    @objc private func clearConsole(_ sender: UIButton) {
        self.textLabel.text = ""
        self.textLabel.sizeToFit()
        self.scrollView.contentSize = self.textLabel.bounds.size
        self.scrollView.contentOffset = CGPoint.zero
    }
    
    private func setup() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.white
        
        self.setupScrollView()
        self.setupTextLabel()
        self.setupToggleFullScreenButton()
        self.setupClearConsoleButton()
        self.setupConstraints()
    }
    
    private func setupScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.backgroundColor = UIColor.clear
        self.addSubview(self.scrollView)
    }
    
    private func setupTextLabel() {
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont.systemFont(ofSize: CGFloat(14.0))
        self.textLabel.numberOfLines = 0
        self.textLabel.isUserInteractionEnabled = true
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
    
    private func setupButton(_ button: UIButton, title: String, selectorString: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setBackgroundImage(UIColor.white.image(), for: UIControlState())
        button.setBackgroundImage(UIColor.black.image(), for: .selected)
        button.setBackgroundImage(UIColor.black.image(), for: .highlighted)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: Selector(selectorString), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32.0))
        self.addConstraint(NSLayoutConstraint(item: self.toggleFullScreenButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .trailing, relatedBy: .equal, toItem: self.toggleFullScreenButton, attribute: .leading, multiplier: 1.0, constant: -8.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32.0))
        self.addConstraint(NSLayoutConstraint(item: self.clearConsoleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.toggleFullScreenButton, attribute: .top, multiplier: 1.0, constant: -2.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0))
        self.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .leading, relatedBy: .equal, toItem: self.scrollView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    private func updateFrameToCurrentSize() {
        UIView.animate(withDuration: 0.25, animations: {
            var frame = self.frame
            frame.size = self.size
            self.frame = frame
        })
    }
    
    private func updateFrameToFullScreen() {
        UIView.animate(withDuration: 0.25, animations: {
            var frame = self.frame
            frame.size = UIScreen.main.bounds.size
            frame.size.height -= 20.0
            self.frame = frame
        })
    }
    
    private func scrollViewIsAtBottom() -> Bool {
        let contentSizeHeight = self.scrollView.contentSize.height
        let scrollViewHeight = self.scrollView.bounds.height
        
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
        context?.setFillColor(self.cgColor)
        context?.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
