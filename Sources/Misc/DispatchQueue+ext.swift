//
//  DispatchQueue+ext.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/19.
//

import Dispatch

public extension DispatchQueue {
    private static var token: DispatchSpecificKey<()> = {
        let key = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()


    /// 判断当前是否是main queue
    static var isMain: Bool {
        return DispatchQueue.getSpecific(key: token) != nil
    }
}

