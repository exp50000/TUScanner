//
//  TicketJagged.swift
//  TUScanner
//
//  Created by ice on 2021/9/7.
//

import UIKit

public class TicketJagged: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        
        let aPath = UIBezierPath(rect: CGRect(origin: .zero, size: frame.size))
        
        let aDegree = CGFloat.pi / 180
        let radius = frame.height / 2
        
        let bCenter = CGPoint(x: 0, y: radius)
        let bPath = UIBezierPath(arcCenter: bCenter, radius: radius, startAngle: aDegree * 90, endAngle: aDegree * 270, clockwise: false)
        
        let cCenter = CGPoint(x: frame.width, y: radius)
        let cPath = UIBezierPath(arcCenter: cCenter, radius: radius, startAngle: aDegree * -90, endAngle: aDegree * -270, clockwise: false)
       
        aPath.append(bPath)
        aPath.append(cPath)
        
        let masklayer = CAShapeLayer()
        masklayer.path = aPath.cgPath
        masklayer.fillColor = UIColor.white.cgColor
        
        layer.addSublayer(masklayer)
        
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.lightGray.cgColor
        
        lineLayer.lineWidth = 1
        lineLayer.lineJoin = CAShapeLayerLineJoin.round
        lineLayer.lineDashPhase = 0
        lineLayer.lineDashPattern = [5, 2]
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: radius, y: radius))
        path.addLine(to: CGPoint(x: frame.width - radius, y: radius))
        lineLayer.path = path.cgPath
        layer.addSublayer(lineLayer)
    }
}
