//
//  TicketViewController.swift
//  TUScanner
//
//  Created by ice on 2021/9/7.
//

import UIKit
import IITool
import TUStyle
import RxSwift
import RxCocoa

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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
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
    @IBOutlet weak var closeButton: UIButton!
    
    public var viewModel = TicketViewModel()
    
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketBackgroudView.isHidden = true
        bindViewModel()
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
    
    @objc @IBAction func closeVC() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonAction() {
        let id = viewModel.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .tuTicketScanButtonAction, object: nil, userInfo: ["eventid": id ?? -1])
        }
        
        closeVC()
    }
}

private extension TicketViewController {
    func bindViewModel() {
        viewModel.title.asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.subTitle.asDriver()
            .drive(subTitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.qrcode.asDriver()
            .drive(qrcodeImageView.rx.image)
            .disposed(by: disposeBag)
        viewModel.createTime                                //
            .subscribe(onNext: { [unowned self] string in
                qrcodeTimeLabel.text = "產生時間：\(string)"
            }).disposed(by: disposeBag)
        viewModel.createTime.asDriver()
            .map({ "產生時間：\($0)" })
            .drive(qrcodeTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.oneDayOnly.asDriver()
            .drive(dashLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.oneDayOnly.asDriver()
            .drive(endDateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.oneDayOnly.asDriver()
            .drive(endTimeLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.beginDay.asDriver()
            .drive(beginDateLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.beginTime.asDriver()
            .drive(beginTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.endDay.asDriver()
            .drive(endDateLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.endTime.asDriver()
            .drive(endTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.tip.asDriver()
            .drive(tipLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.status
            .observe(on: MainScheduler.instance)
            .subscribe (onNext: { [unowned self] status in
                switch status {
                case .processing:
                    showLoading(true)
                    self.ticketBackgroudView.isHidden = true
                case .done(_, _):
                    self.ticketBackgroudView.isHidden = false
                default:
                    hideLoading()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension TicketViewController {
    public static func newVC() -> TicketViewController {
        let vc = TicketViewController.instantiate(from: "Scanner", bundle: .module)
        return vc
    }
}

public extension Notification.Name {
    static let tuTicketScanButtonAction = Notification.Name("tuTicketScanButtonAction")
}
