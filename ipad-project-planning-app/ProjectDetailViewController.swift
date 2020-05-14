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
    var mainDelegate: ViewProjectTableViewController?
    var dateUtils: DateUtils = DateUtils()
    
    let colours: Colours = Colours()
    @IBOutlet weak var completeProgress: CircularProgressBar!
    
    @IBOutlet weak var dayProgress: CircularProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectName.text = project?.value(forKey: "name") as? String
        
        if ((project?.value(forKey: "note")) != nil) {
            descField.text = project?.value(forKey: "note") as? String
        }
        
        taskTable.delegate = self
        taskTable.dataSource = self
        
        let startDate = project?.value(forKey: "startDate")
        let dueDate = project?.value(forKey: "date")
        
        let daysRemaining = self.dateUtils.getRemainingTimePercentage(startDate! as! Date, end: dueDate! as! Date)
        let daysRemainingCount = self.dateUtils.getDateDiff(Date(), end: dueDate as! Date)
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(40)
            self.completeProgress?.customSubtitle = "Completed"
            self.completeProgress?.startGradientColor = colours[0]
            self.completeProgress?.endGradientColor = colours[1]
            self.completeProgress?.progress = CGFloat(40) / 100
            self.completeProgress?.isHidden = false
        }
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(daysRemaining)
            self.dayProgress?.customTitle = "\(daysRemainingCount)"
            self.dayProgress?.customSubtitle = "Days Left"
            self.dayProgress?.startGradientColor = colours[0]
            self.dayProgress?.endGradientColor = colours[1]
            self.dayProgress?.progress = CGFloat(daysRemaining) / 100
            self.dayProgress?.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func removeProject(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(project!)
            try managedContext.save();
        }catch{}
        
        mainDelegate?.loadData();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        
        let num = indexPath.row + 1
        cell.taskNumber.text = "Task " + String(num)
        return cell
    }
    
}
