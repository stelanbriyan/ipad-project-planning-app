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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(project?.value(forKey: "name") ?? "A")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
           
        return cell
    }
    
}
