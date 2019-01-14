//
//  ObservingInputAccessory.swift
//  HHHKit
//
//  Created by huahuahu on 2019/1/14.
//

//https://github.com/brynbodayle/BABFrameObservingInputAccessoryView // 参考自这里。把自己作为inputAccessoryView，观察superview的frame，用于观察键盘高度的变化

import UIKit


/// 把自己作为inputAccessoryView，观察superview的frame，用于观察键盘高度的变化
public class ObservingInputAccessory: UIView {

    public typealias InputAcessoryViewFrameChangedBlock = (_ frame: CGRect) -> Void

    /// 设置这个，可以监听键盘位置的变化
    public var frameChangeBlock: InputAcessoryViewFrameChangedBlock?
    private var observation: NSKeyValueObservation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observation?.invalidate()
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        observation?.invalidate()
        // 这里只能观察center，frame观察不到，不知道为啥
        observation = newSuperview?.observe(\.center) { [weak self]  (_, change) in
            guard let `self` = self else { return }
            assert(Thread.isMainThread)
            if let frame = self.superview?.frame {
                self.frameChangeBlock?(frame)
            }
        }
        super.willMove(toSuperview: newSuperview)
    }
}
