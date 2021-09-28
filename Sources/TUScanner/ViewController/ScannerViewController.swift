//
//  ScannerViewController.swift
//  TUScanner
//
//  Created by ice on 2021/9/1.
//

import UIKit
import AVFoundation
import IITool
import TUStyle

public class ScannerViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    public typealias Complete = (String) -> Void
    public var readCallback: Complete?
    
    public var qrcodeImage: UIImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupMask()
        setupCaptureSession()
        
        qrCodeImageView.image = qrcodeImage
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startReading()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopReading()
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
    
    @objc func closeVC() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupNavigationBar() {
        title = "多功能掃描"
        let closeBtn = UIBarButtonItem(image: UIImage(named: "icPageClose"), style: .plain, target: self, action: #selector(closeVC))
        navigationItem.rightBarButtonItem = closeBtn
        navigationController?.navigationBar.tintColor = UIColor.dark
    }
    
    private func setupMask() {
        let mask = ScannerMask(with: view.bounds, maskColor: .dark.withAlphaComponent(0.7), topSpace: 75)
        view.insertSubview(mask, at: 0)
    }
    
    private func setupCaptureSession() {
        let captureDevice = AVCaptureDevice.default(for: .video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            if captureSession.inputs.count == 0 {
                captureSession.addInput(input)
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.qr]
                
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer.frame = view.layer.bounds
                view.layer.insertSublayer(videoPreviewLayer, at: 0)
                
                captureSession.startRunning()
            }
        } catch {
        }
    }
    
    private func stopReading() {
        captureSession.stopRunning()
    }
    
    private func startReading() {
        captureSession.startRunning()
    }
}

extension ScannerViewController {
    public static func newVC() -> ScannerViewController {
        return ScannerViewController.instantiate(from: "Scanner", bundle: .module)
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var decode = ""
        for metaData in metadataObjects {
            stopReading()
            let decodedData = metaData as! AVMetadataMachineReadableCodeObject
            decode = decodedData.stringValue ?? "-"
            
            break
        }
        
        readCallback?(decode)
        closeVC()
    }
}

public extension Notification.Name {
    static let showCheckingScanner = Notification.Name("showCheckingQRCodeScanner")
}
