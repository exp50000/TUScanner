//
//  BordButton.swift
//  
//
//  Created by ice on 2021/9/7.
//

import UIKit

@IBDesignable
public class BordButton: UIButton {

    public var borderWidth: CGFloat = 2.0
    public var borderColor = UIColor.white {
        didSet {
            layoutSubviews()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height / 2.0
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
