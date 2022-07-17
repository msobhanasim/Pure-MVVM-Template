//
//  UItextViewExtension.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import UIKit

extension UITextView : UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    @IBInspectable
    public var placeholderColorTV: UIColor? {
        get {
            var placeholderColorTV: UIColor?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderColorTV = placeholderLabel.textColor
            }
            
            return placeholderColorTV
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.textColor = newValue
            } else {
                self.addPlaceholder("",newValue!)
            }
        }
    }
    
    /// The UITextView placeholder text
    @IBInspectable
    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text

            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.string = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String = "", _ color:UIColor = .white) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.string = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = color.withAlphaComponent(0.5)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension UITextField {
    var string:String? {
        get {
           return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
           self.text = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
    }
    
}

extension UITextView {
    var string:String? {
        get {
           return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
           self.text = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
    }
    
}

extension UILabel {
    var string:String? {
        get {
           return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
           self.text = newValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
    }
    
}

extension UIButton {
    var string :String? {
        get {
            return self.titleLabel?.string ?? ""
        }
        set {
            self.setTitle(newValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", for: .normal)
        }
    }
}
