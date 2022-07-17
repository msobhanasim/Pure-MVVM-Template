//
//  PlaceholderTextView.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import UIKit

@IBDesignable class CustomTextView: UIView {

    private(set) var textView: UITextView = UITextView(frame: CGRect.zero)
    private(set) var placeholderLabel: UILabel = UILabel(frame: CGRect.zero)

    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        textView.delegate = self
        addSubview(textView)
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center

        addSubview(placeholderLabel)
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 0

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshViews()
    }

    fileprivate func refreshViews() {
        UIView.performWithoutAnimation {
            textView.frame = self.bounds

            let optimalSize = textView.sizeThatFits(bounds.size)
            textView.frame = CGRect(x: 0.0, y: max((bounds.size.height-optimalSize.height)*0.5, 0.0), width: bounds.width, height: min(optimalSize.height, bounds.size.height))
            placeholderLabel.frame = bounds
            placeholderLabel.backgroundColor = UIColor.clear

            if textView.text.isEmpty && textView.isFirstResponder == false {
                placeholderLabel.text = placeholder
                placeholderLabel.isHidden = false
                textView.isHidden = true
            } else {
                placeholderLabel.isHidden = true
                textView.isHidden = false
            }
        }
    }

    @objc private func onTap() {
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }

}

extension CustomTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        refreshViews()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        refreshViews()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        refreshViews()
    }

}
