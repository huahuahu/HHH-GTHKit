//
//  ViewController.swift
//  CoreGraphFunc
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import UIKit
import HHHKit
import SnapKit

class CoreGraphDemo: UIViewController {
    var demo: CoreGraphDemoEnum!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let bounds = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        let example = getDiagram(for: demo)
        let image = renderer.image { (context) in
            context.cgContext.draw(example, in: bounds)
        }

        let imageView = UIImageView.init(image: image)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    private func getDiagram(for demo: CoreGraphDemoEnum) -> Diagram {
        switch demo {
        case .demo1:
            let bluesquare = Diagram.square(side: 1).filled(.blue)
            let redsquare = Diagram.square(side: 2).filled(.red)
            let greenCircle = Diagram.circle(diameter: 1).filled(.green)
            let example = bluesquare ||| greenCircle ||| redsquare
            return example
        case .demo2:
            let values: [CGFloat] = [5, 7, 6.5, 1, 3]
            let bars = values.normalized.map { (value) -> Diagram in
                return Diagram.rect(width: 1, height: 3 * value).filled(.black).aligned(to: .bottom)
            }.hcat
            let strings = ["Moscow", "Shanghai", "Istanbul", "Berlin", "New York"]
            let labels = strings.map { (label) -> Diagram in
                return Diagram.text(label, width: 1, height: 0.3).aligned(to: .top)
            }.hcat
            let example = bars --- labels
            return example
        }
    }

}

extension Sequence where Element == CGFloat {
    var normalized: [CGFloat] {

        let maxVal = reduce(0, Swift.max)
        return map {$0 / maxVal}
    }
}
