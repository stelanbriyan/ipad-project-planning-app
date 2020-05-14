//
//  AddTaskTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/14/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData

class AddTaskTableViewController: UITableViewController {
    
    var tasks: [NSManagedObject] = []
    var projectNum: Int? = nil
    var delegate: ProjectDetailViewController? = nil
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskNote: UITextField!
    
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notificationSpinner: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTask(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(taskName.text, forKey: "name")
        task.setValue(taskNote.text, forKey: "note")
        task.setValue(dueDate.date, forKey: "date")
        task.setValue(Date(), forKey: "startDate")
        task.setValue(notificationSpinner.value, forKey: "notify")
        task.setValue(projectNum, forKey: "projectNum")
        
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        dismiss(animated: true, completion: nil)
        delegate?.loadData()
    }
}

extension AddTaskTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            return 200.0
        }
        // Make Notes text view bigger: 80
        if indexPath.section == 0 && indexPath.row == 0 {
            return 250.0
        }
        
        return 0
    }
    
}
