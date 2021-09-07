import UIKit

public class ScannerMask: UIView {
    
    public init(with frame: CGRect, maskColor: UIColor, topSpace: CGFloat) {
        super.init(frame: frame)
        setup(maskColor, topSpace: topSpace)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(_ maskColor: UIColor = .darkGray, topSpace: CGFloat = 100) {
        backgroundColor = .clear
        
        let maskView = UIView(frame: frame)
        maskView.backgroundColor = maskColor
        
        let aPath = UIBezierPath(rect: frame)
        
        let width: CGFloat = 278.0
        let x = (frame.width - width) / 2
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: x, y: topSpace), size: CGSize(width: width, height: width)), cornerRadius: 5)
        
        aPath.append(path.reversing())
        let masklayer = CAShapeLayer()
        masklayer.path = aPath.cgPath
        maskView.layer.mask = masklayer
        
        let lineWidth: CGFloat = 4
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = lineWidth
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        lineLayer.fillColor = UIColor.clear.cgColor
        
        let path1 = UIBezierPath()
        let lineSpace: CGFloat = 50
        var offsetX = x + (lineWidth / 2) + lineSpace
        var offsetY = topSpace + lineWidth / 2
        path1.move(to: CGPoint(x: offsetX, y: offsetY))
        offsetX -= lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        offsetY += lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        
        offsetY += (width - lineSpace * 2 - lineWidth)
        path1.move(to: CGPoint(x: offsetX, y: offsetY))
        offsetY += lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        offsetX += lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        
        offsetX += (width - lineSpace * 2 - lineWidth)
        path1.move(to: CGPoint(x: offsetX, y: offsetY))
        offsetX += lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        offsetY -= lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        
        offsetY -= (width - lineSpace * 2 - lineWidth)
        path1.move(to: CGPoint(x: offsetX, y: offsetY))
        offsetY -= lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        offsetX -= lineSpace
        path1.addLine(to: CGPoint(x: offsetX, y: offsetY))
        
        lineLayer.path = path1.cgPath
        layer.addSublayer(lineLayer)
        
        addSubview(maskView)
    }
}
