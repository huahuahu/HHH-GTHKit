//
//  ColorPicker.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/3.
//

import UIKit


/// 颜色选择器
public class ColorPicker: UIView {

    enum LayerType: CaseIterable {
        case H
        case S
        case B

        var caseCount: Int {
            switch self {
            case .H: return 0
            case .S: return 1
            case .B: return 2
            }
        }
    }

    lazy private var hSelecotor: UIControl = {
        let control = UIControl.init()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(onPan(gesture:)))
        control.addGestureRecognizer(gesture)
        return control
    }()

    lazy private var sSelecotor: UIControl = {
        let control = UIControl.init()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(onPan(gesture:)))
        control.addGestureRecognizer(gesture)
        return control
    }()

    lazy private var bSelecotor: UIControl = {
        let control = UIControl.init()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(onPan(gesture:)))
        control.addGestureRecognizer(gesture)
        return control
    }()


    private let hLayer = CALayer.init()
    private let sLayer = CALayer.init()
    private let bLayer = CALayer.init()

    private let resultLayer = CALayer.init()
    private let resultLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let inset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)

    private var currentH: CGFloat = 0.5
    private var currentS: CGFloat = 0.5
    private var currentB: CGFloat = 0.5
    
    public var currentSelectColor: UIColor {
        return UIColor.init(hue: currentH, saturation: currentS, brightness: currentB, alpha: 1)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setLayer(type: .B)
        setLayer(type: .S)
        setLayer(type: .H)

        resultLayer.frame = resultLayerFrame
        resultLayer.backgroundColor = currentSelectColor.cgColor
        layer.addSublayer(resultLayer)
        resultLabel.frame = resultLabelFrame
        resultLabel.text = currentColorString
        addSubview(resultLabel)
    }

    private let step = 0.02

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayer(type: LayerType) {
        let targetLayer = layerFor(type: type)
        layer.addSublayer(targetLayer)
        targetLayer.frame = frameFor(type: type)
        let gradientLayer = CAGradientLayer.init()
        let locations = stride(from: 0, to: 1.0 + step, by: step).map { $0 }
        gradientLayer.colors = locations.map { colorFor(type, percent: CGFloat($0)) }
        gradientLayer.locations = locations.map(NSNumber.init)
        gradientLayer.frame = targetLayer.bounds
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        targetLayer.addSublayer(gradientLayer)

        let targetControl = controlFor(type: type)
        targetControl.center = CGPoint.init(x: centerXFor(targetControl), y: targetLayer.frame.midY)
        targetControl.bounds = CGRect.init(origin: .zero, size: .init(width: layerHeight + 15, height: layerHeight + 15))
        targetControl.backgroundColor = colorFor(targetControl)
        targetControl.layer.borderColor = UIColor.white.cgColor
        targetControl.layer.borderWidth = 1
        targetControl.layer.masksToBounds = true
        targetControl.layer.cornerRadius = targetControl.bounds.size.width / 2
        addSubview(targetControl)
    }

    private func updateLayers() {
        func updateLayer(_ type: LayerType) {
            let targetLayer = layerFor(type: type)
            targetLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            let gradientLayer = CAGradientLayer.init()
            let locations = stride(from: 0, to: 1.0 + step, by: step).map { $0 }
            gradientLayer.colors = locations.map { colorFor(type, percent: CGFloat($0)) }
            gradientLayer.locations = locations.map(NSNumber.init)
            gradientLayer.frame = targetLayer.bounds
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
            targetLayer.addSublayer(gradientLayer)
        }

        LayerType.allCases.forEach { updateLayer($0) }
    }

    private func updateStatus() {
        updateLayers()
        [hSelecotor, sSelecotor, bSelecotor].forEach { $0.backgroundColor = colorFor($0)}
        resultLayer.backgroundColor = currentSelectColor.cgColor
        resultLabel.text = currentColorString
    }

}

private extension ColorPicker {
    func layerFor(type: LayerType) -> CALayer {
        switch type {
        case .H: return hLayer
        case .S: return sLayer
        case .B: return bLayer
        }
    }

    func frameFor(type: LayerType) -> CGRect {
        return CGRect.init(x: layerStart, y: minYFor(type: type), width: layerWidth, height: layerHeight)
    }

    private var layerWidth: CGFloat {
        return bounds.width - inset.left - inset.top
    }

    private var layerStart: CGFloat {
        return inset.left
    }

    private var layerHeight: CGFloat {
        return 5
    }

    private var layerPadding: CGFloat {
        return (bounds.height / 2 - inset.top - layerHeight * CGFloat(LayerType.allCases.count)) / CGFloat(LayerType.allCases.count)
    }

    private func minYFor(type: LayerType) -> CGFloat {
        return inset.top + CGFloat(type.caseCount) * (layerHeight + layerPadding)
    }

    private func colorFor(_ type: LayerType, percent: CGFloat) -> CGColor {
        guard !(percent < 0), !(percent > 1) else  { fatalError() }
        switch type {
        case .H: return UIColor.init(hue: percent, saturation: 1, brightness: 1, alpha: 1).cgColor
        case .S: return UIColor.init(hue: currentH, saturation: percent, brightness: 1, alpha: 1).cgColor
        case .B: return UIColor.init(hue: currentH, saturation: currentS, brightness: percent, alpha: 1).cgColor
        }
    }

    var resultLayerFrame: CGRect {
        return CGRect.init(x: bounds.width/2 - 5.0, y: bounds.height * 3 / 4 - 5.0, width: 10, height: 10)
    }

    var resultLabelFrame: CGRect {
        return CGRect.init(x: 0, y: self.resultLayerFrame.maxY + 5, width: bounds.width, height: 20)
    }


    var currentColorString: String {
        return currentSelectColor.rgbString
    }
}


// MARK: - 选择器逻辑
private extension ColorPicker {

    @objc private func onPan(gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }
        guard let control = gesture.view as? UIControl else { fatalError() }
        let xPosition = gesture.translation(in: control).x
        let layer = layerForControl(control)
        var percent = (control.center.x + xPosition - layer.frame.minX) / layer.frame.width
        print("\(percent), trans is \(xPosition), width is \(layer.frame.width)")
        percent = percent < 0 ? 0 : ( percent > 1 ? 1 : percent)
        switch control {
        case hSelecotor:  currentH = percent
        case sSelecotor:  currentS = percent
        case bSelecotor:  currentB = percent
        default: fatalError()
        }
        gesture.setTranslation(.zero, in: control)

        control.center = CGPoint.init(x: centerXFor(control), y: control.center.y)
        updateStatus()
    }

    func layerForControl(_ control: UIControl) -> CALayer {
        switch control {
        case hSelecotor: return hLayer
        case sSelecotor: return sLayer
        case bSelecotor: return bLayer
        default: fatalError()
        }

    }

    func controlFor(type: LayerType) -> UIControl {
        switch type {
        case .H: return hSelecotor
        case .S: return sSelecotor
        case .B: return bSelecotor
        }
    }

    func colorFor(_ control: UIControl) -> UIColor {
        switch control {
        case hSelecotor: return UIColor.init(hue: currentH, saturation: 1, brightness: 1, alpha: 1)
        case sSelecotor: return UIColor.init(hue: currentH, saturation: currentS, brightness: 1, alpha: 1)
        case bSelecotor: return UIColor.init(hue: currentH, saturation: currentS, brightness: currentB, alpha: 1)
        default: fatalError()
        }
    }

    func centerXFor(_ control: UIControl) -> CGFloat {
        switch control {
        case hSelecotor: return hLayer.frame.minX + hLayer.frame.width * currentH
        case sSelecotor: return sLayer.frame.minX + sLayer.frame.width * currentS
        case bSelecotor: return bLayer.frame.minX + bLayer.frame.width * currentB
        default: fatalError()
        }

    }
}
