//
//  ViewController.swift
//  TestTextView
//
//  Created by huahuahu on 2019/1/3.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import UIKit
import SnapKit
import HHHKit

class ViewController: UIViewController {

    let textView: UITextView = {
        let view = UITextView.init()
        view.backgroundColor = .white
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let settingButton: UIButton = {
        let button = UIButton.init()
        button.setTitle("settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    let colorPicker: ColorPicker = {
        let picker = ColorPicker.init(frame: CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 300))
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.height.equalTo(30)
        }
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
        }
        settingButton.addTarget(self, action: #selector(onSetting(_:)), for: .touchUpInside)
    }

    @objc func onSetting(_ button: UIButton) {
        if colorPicker.superview == nil {
            view.addSubview(colorPicker)
        } else {
            let color = colorPicker.currentSelectColor
            textView.tintColor = color
            colorPicker.removeFromSuperview()
        }
    }

}
