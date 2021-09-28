//
//  LocateSheetAlertController.swift
//  TUScanner
//
//  Created by ice on 2021/9/8.
//

import UIKit
import IITool
import TUStyle
import Hero

public class LocateSheetAlertController: UIViewController {
    public typealias Action = (BordButton?) -> Void
    public var leftButtonAction: Action?
    public var rightButtonAction: Action?
    public var canScan = false
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftButton: BordButton! {
        didSet {
            leftButton.borderColor = .clear
        }
    }
    @IBOutlet weak var rightButton: BordButton! {
        didSet {
            rightButton.borderColor = .black2
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel! {
        didSet {
            let string = warningLabel.text ?? ""
            let attributedString = NSMutableAttributedString(string: string, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .light),
                .foregroundColor: UIColor.tomato
                ])
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 15, weight: .medium)
            ], range: (string as NSString).range(of: "注意"))
            warningLabel.attributedText = attributedString
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        contentView.hero.modifiers = [.translate(y: 100)]
        
        rightButton.isHidden = !canScan
        rightButton.isHidden = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentViewRoundCorners()
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    private func contentViewRoundCorners() {
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
    }
    
    @objc @IBAction func closeVC() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func rightButtonIBAction(_ sender: BordButton?) {
        rightButtonAction?(sender)
    }
    
    @IBAction func LeftButtonIBAction(_ sender: BordButton?) {
        leftButtonAction?(sender)
    }
    
    public func closeSheet() {
        closeVC()
    }
}

extension LocateSheetAlertController {
    public static func newVC() -> LocateSheetAlertController {
        return LocateSheetAlertController.instantiate(from: "Scanner", bundle: .module)
    }
}
