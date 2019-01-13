//
//  CoreGraphDemoVC.swift
//  CoreGraphFunc
//
//  Created by huahuahu on 2019/1/13.
//  Copyright © 2019 huahuahu. All rights reserved.
//

import UIKit

enum CoreGraphDemoEnum: String, CaseIterable {
    case demo1
    case demo2
}

class CoreGraphDemoVC: UITableViewController {
    let identifier = "id"

    let demos: [CoreGraphDemoEnum] = CoreGraphDemoEnum.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        cell.textLabel?.text = demos[indexPath.row].rawValue
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demoVC = CoreGraphDemo.init(nibName: nil, bundle: nil)
        demoVC.demo = demos[indexPath.row]
        navigationController?.pushViewController(demoVC, animated: true)
    }

}
