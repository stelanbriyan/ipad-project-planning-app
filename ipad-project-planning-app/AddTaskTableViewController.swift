//
//  AddTaskTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/14/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddTaskTableViewController: UITableViewController {
    
    @IBOutlet weak var addToCalendarSwitch: UISwitch!
    var tasks: [NSManagedObject] = []
    var projectNum: Int? = nil
    var maxDate: Date? = nil
    var delegate: ProjectDetailViewController? = nil
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskNote: UITextField!
    
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var notificationSpinner: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDate.minimumDate = NSDate() as Date
        dueDate.maximumDate = maxDate
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
        
        let eventStore = EKEventStore()
        var calendarIdentifier = ""
        
        if addToCalendarSwitch.isOn {
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in
                    calendarIdentifier = self.createEvent(eventStore, title: self.taskName.text!, startDate: Date(), endDate: self.dueDate.date)
                })
            } else {
                calendarIdentifier = createEvent(eventStore, title: taskName.text!, startDate: Date(), endDate: dueDate.date)
            }
            
            if calendarIdentifier != "" {
                print("Added to calendaer")
            }
        }
        
        dismiss(animated: true, completion: nil)
        delegate?.loadData()
    }
    
    // Creates an event in the EKEventStore
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) -> String {
        let event = EKEvent(eventStore: eventStore)
        var identifier = ""
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            identifier = event.eventIdentifier
        } catch {
            let alert = UIAlertController(title: "Error", message: "Calendar event could not be created!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return identifier
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
