//
//  CommonTask.swift
//  HHHKit
//
//  Created by huahuahu on 2019/5/8.
//

import Foundation

enum HHKitCommon {
    func addVCAsSubviewIn(_ containerVC: UIViewController, containerView: UIView, subVC: UIViewController) {
        containerVC.addChild(subVC)
        containerView.addSubview(subVC.view)
        subVC.didMove(toParent: containerVC)
    }
}
