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

extension DispatchQueue {
    // ref https://juejin.im/post/5a31f000518825585132b566

    private static var _onceTracker = [String]()

    static public func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = file + ":" + function + ":" + String(line)
        self.once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    static public func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if DispatchQueue._onceTracker.contains(token) {
            return
        }
        DispatchQueue._onceTracker.append(token)
        block()
    }
}

