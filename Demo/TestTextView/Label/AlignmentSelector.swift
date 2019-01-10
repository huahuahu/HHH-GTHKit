//
//  AlignmentSelector.swift
//  TestTextView
//
//  Created by huahuahu on 2019/1/5.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import UIKit
import HHHKit
import SnapKit

protocol AlignmentSelectorDelegate: class {
    func selector(_ selector: AlignmentSelector,
                  didSelectVerticalAlignment verticalAlignment: HHLabel.VertialAlignment,
                  horizontalAliment: HHLabel.HorizontalAlignment )
}

class AlignmentSelector: UIView {

    private var alimentors = [Alimentor]()
    weak var delegate: AlignmentSelectorDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView.init(frame: bounds)
        HHLabel.VertialAlignment.allCases.forEach { (vertical) in
            let subStackView = UIStackView.init()
            HHLabel.HorizontalAlignment.allCases.forEach({ (horizontal) in
                let alimentor = Alimentor.init(vertical: vertical, horizontal: horizontal)
                alimentors.append(alimentor)
                subStackView.addArrangedSubview(alimentor.button)
                alimentor.button.addTarget(self, action: #selector(onSelect(_:)), for: .touchUpInside)
            })
            subStackView.axis = .horizontal
            subStackView.alignment = .center
            subStackView.distribution = .equalSpacing
            stackView.addArrangedSubview(subStackView)
            subStackView.snp.makeConstraints({ (make) in
                make.width.equalToSuperview()
            })

        }
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution  = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onSelect(_ button: UIButton) {
        guard !button.isSelected else {
            return
        }
        alimentors.forEach { $0.setSelected($0.button == button) }

        if delegate != nil, let selected = alimentors.first(where: {$0.button == button}) {
            delegate!.selector(self, didSelectVerticalAlignment: selected.vertical,
                               horizontalAliment: selected.horizontal)
        }
    }

}

private extension AlignmentSelector {
    struct Alimentor {
        let button: UIButton = {
            let button = UIButton.init()
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.blue, for: .selected)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.black.cgColor
            return button
        }()
        let vertical: HHLabel.VertialAlignment
        let horizontal: HHLabel.HorizontalAlignment

        init(vertical: HHLabel.VertialAlignment, horizontal: HHLabel.HorizontalAlignment  ) {
            self.vertical = vertical
            self.horizontal = horizontal
            configButton()
        }

        private func configButton() {
            let title = vertical.toStr + horizontal.toString
            button.setTitle(title, for: .normal)
        }

        func setSelected(_ selected: Bool) {
            button.isSelected = selected
            if selected {
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                button.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
}

extension HHLabel.VertialAlignment {
    var toStr: String {
        switch self {
        case .bottom: return "B"
        case .middle: return "M"
        case .top: return "T"
        }
    }
}

extension HHLabel.HorizontalAlignment {
    var toString: String {
        switch self {
        case .left: return "L"
        case .middle: return "M"
        case .right: return "R"
        }
    }
}
