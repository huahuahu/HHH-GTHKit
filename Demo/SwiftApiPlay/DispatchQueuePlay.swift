//
//  DispatchQueuePlay.swift
//  SwiftApiPlay
//
//  Created by huahuahu on 2019/5/8.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import XCTest
import Quick
import Nimble
//swiftlint:disable function_body_length
class DispatchPlay: QuickSpec {
    override func spec() {
        describe("优先级") {
            it("可以获取优先级", closure: {
                //requested QOS class of the current thread.
                let qos = qos_class_self()
                expect(qos).to(equal(QOS_CLASS_USER_INTERACTIVE))
            })
            it("获取指定qos的队列", closure: {
                //全局队列
                var queue = DispatchQueue.global(qos: .utility)
                expect(queue.qos).to(equal(DispatchQoS.utility))
                let group = DispatchGroup.init()
                group.enter()
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))

                queue.async {
                    expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))
                    group.leave()
                }
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))
                group.wait()

                //串行队列
                queue = DispatchQueue.init(label: "test", qos: .background)
                group.enter()
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))

                queue.async {
                    expect(qos_class_self()).to(equal(QOS_CLASS_BACKGROUND))
                    group.leave()
                }
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))
                group.wait()
            })
            it("block：默认是queue的qos", closure: {
                let group = DispatchGroup.init()
                let queue = DispatchQueue.init(label: "test",
                                               qos: .utility,
                                               target: DispatchQueue.global(qos: .background))
                group.enter()
                let item = DispatchWorkItem.init(qos: .userInitiated, block: {
                    expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))
                    group.leave()
                })
                queue.async(execute: item)
                group.wait()
            })
            it("block：target queue的qos", closure: {
                let group = DispatchGroup.init()
                let queue = DispatchQueue.init(label: "test", target: DispatchQueue.global(qos: .background))
                group.enter()
                let item = DispatchWorkItem.init(qos: .userInitiated, block: {
                    expect(qos_class_self()).to(equal(QOS_CLASS_BACKGROUND))
                    group.leave()
                })
                queue.async(execute: item)
                group.wait()

            })
            it("block：block 的qos", closure: {
                let group = DispatchGroup.init()
                let queue = DispatchQueue.init(label: "test")
                group.enter()
                let item = DispatchWorkItem.init(qos: .userInitiated, block: {
                    expect(qos_class_self()).to(equal(QOS_CLASS_USER_INITIATED))
                    group.leave()
                })
                queue.async(execute: item)
                group.wait()
            })

            it("block：提交线程的qos？？？", closure: {
                let group = DispatchGroup.init()
                let queue = DispatchQueue.init(label: "test")
                group.enter()
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))

                let item = DispatchWorkItem.init(block: {
//                    expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))
                    group.leave()
                })
                queue.async(execute: item)
                group.wait()
            })
            it("同步block 的qos", closure: {
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))
                let group = DispatchGroup.init()

                let item = DispatchWorkItem.init(qos: .userInitiated, block: {
                    //block指定了qos，使用指定的qos
                    expect(qos_class_self()).to(equal(QOS_CLASS_USER_INITIATED))
                })
                let item2 = DispatchWorkItem.init(qos: .background, block: {
                    //block指定了qos，比当前线程qos低，使用当前线程的的qos
                    expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))

                })
                DispatchQueue.global(qos: .utility).async {
                    expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))

                    DispatchQueue.global(qos: .userInteractive).sync(execute: {
                        //当前block没有制定qos，使用当前线程的qos
                        expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))
                        item.perform()
                        expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))
                        item2.perform()
                        expect(qos_class_self()).to(equal(QOS_CLASS_UTILITY))
                    })
                    group.leave()
                }
                group.enter()
                expect(qos_class_self()).to(equal(QOS_CLASS_USER_INTERACTIVE))
                group.wait()
            })

        }
    }
}
