//
//  Proxy.swift
//  HHHKit
//
//  Created by huahuahu on 2019/5/8.
//

import Foundation
extension HHKitCommon {

    /// 读取系统的proxy设置
    public static func readSystemProxyURL() -> URL? {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() else { return nil }

        if let httpEnabled = unsafeBitCast(
                CFDictionaryGetValue(proxySettings, Unmanaged.passUnretained(kCFNetworkProxiesHTTPEnable).toOpaque()),
                to: Unmanaged<AnyObject>?.self)?.takeUnretainedValue() as? Bool,
            httpEnabled,
            let proxy = unsafeBitCast(
                CFDictionaryGetValue(proxySettings, Unmanaged.passUnretained(kCFNetworkProxiesHTTPProxy).toOpaque()),
                to: Unmanaged<CFString>?.self)?.takeUnretainedValue() as String?,
            var components = URLComponents(string: "http://\(proxy)") {
            if let port = unsafeBitCast(
                    CFDictionaryGetValue(proxySettings, Unmanaged.passUnretained(kCFNetworkProxiesHTTPPort).toOpaque()),
                    to: Unmanaged<AnyObject>?.self)?.takeUnretainedValue() as? Int
            {
                components.port = port
            }
            return components.url
        }

        return nil
    }
}

