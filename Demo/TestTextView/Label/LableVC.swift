//
//  LableVC.swift
//  TestTextView
//
//  Created by huahuahu on 2019/1/5.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import UIKit
import HHHKit
import SnapKit

class LableVC: UIViewController {

    let label: HHLabel = {
        let label =  HHLabel.init()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 3
        label.text = "this is a test"
        return label
    }()

    let selector: AlignmentSelector = {
        let selector = AlignmentSelector.init()
        selector.layer.borderColor = UIColor.yellow.cgColor
        selector.layer.borderWidth = 3
        return selector
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.size.equalTo(CGSize.init(width: view.bounds.width, height: 200))
        }

        view.addSubview(selector)
        selector.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(80)
            make.height.equalTo(selector.snp.width)
            make.top.equalTo(label.snp.bottom).offset(100)
        }

        selector.delegate = self

        // Do any additional setup after loading the view.
    }

}

extension LableVC: AlignmentSelectorDelegate {
    func selector(_ selector: AlignmentSelector, didSelectVerticalAlignment verticalAlignment: HHLabel.VertialAlignment, horizontalAliment: HHLabel.HorizontalAlignment) {
        label.horizontalAliment = horizontalAliment
        label.verticalAliment = verticalAlignment
        label.setNeedsDisplay()
    }
}
