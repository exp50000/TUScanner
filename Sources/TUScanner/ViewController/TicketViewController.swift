//
//  TicketViewController.swift
//  TUScanner
//
//  Created by ice on 2021/9/7.
//

import UIKit
import IITool
import TUStyle

public class TicketViewController: UIViewController {
    @IBOutlet weak var ticketBackgroudView: UIView! {
        didSet {
            ticketBackgroudView.layer.cornerRadius = 10
            ticketBackgroudView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var tagLabel: UILabel! {
        didSet {
            tagLabel.layer.cornerRadius = 3
            tagLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var qrcodeTitleLabel: UILabel!
    @IBOutlet weak var qrcodeTimeLabel: UILabel!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var dashLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var button: BordButton!
    
    public var qrcodeImage: UIImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        qrcodeImageView.image = qrcodeImage
    }
    
    @objc @IBAction func closeVC() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonAction() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension TicketViewController {
    public static func newVC() -> TicketViewController {
        return TicketViewController.instantiate(from: "Scanner", bundle: .module)
    }
}

