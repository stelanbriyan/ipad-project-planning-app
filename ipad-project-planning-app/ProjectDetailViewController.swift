//
//  ProjectDetailViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData

class ProjectDetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    var project : NSManagedObject? = nil
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var descField: UILabel!
    
    @IBOutlet weak var taskTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectName.text = project?.value(forKey: "name") as? String
        
        if ((project?.value(forKey: "note")) != nil) {
            descField.text = project?.value(forKey: "note") as? String
        }

        taskTable.delegate = self
        taskTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        
        let num = indexPath.row + 1
        cell.taskNumber.text = "Task " + String(num)
        return cell
    }
    
}
