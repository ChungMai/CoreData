//
//  PrepareTVC.swift
//  Groceries
//
//  Created by MacMini on 11/3/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import UIKit

class PrepareTVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Trigger Demo Code
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.demoInsert()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
}
