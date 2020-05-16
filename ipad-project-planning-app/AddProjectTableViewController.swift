//
//  AddProjectTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddProjectTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    var projects: [NSManagedObject] = []
    
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDate: UIDatePicker!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var addToCalendarSwitch: UISwitch!
    var project : NSManagedObject? = nil
    @IBOutlet weak var moduleName: UITextField!
    
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var value: UITextField!
    
    @IBOutlet weak var marks: UITextField!
    
    var editingMode: Bool = false
    
    var mainDelegate: ViewProjectTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(editingMode){
            title = "Edit Project"
            projectName.text = project?.value(forKey: "name") as? String
            projectDate.date = project?.value(forKey: "date") as! Date
            projectDescription.text = project?.value(forKey: "note") as? String
            moduleName.text = project?.value(forKey: "moduleName") as? String
            level.text = project?.value(forKey: "level") as? String
            
            let val = project?.value(forKey: "value") as! Int
            value.text = String(val)
            
            let mark = project?.value(forKey: "mark") as! Int
            marks.text = String(mark)
            print(project)
        }
        
        projectDate.minimumDate = NSDate() as Date
    }
    
    @IBAction func save(_ sender: Any) {
        let name =  projectName.text
        let note = projectDescription.text
        let date = projectDate.date
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)!
        
        let project: NSManagedObject
        if(editingMode == false){
            project = NSManagedObject(entity: entity, insertInto: managedContext)
            project.setValue(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()), forKey: "projectNum")
            project.setValue(Date(), forKeyPath: "startDate")
        }else{
            project = self.project!
        }
        
        project.setValue(name, forKeyPath: "name")
        project.setValue(note, forKeyPath: "note")
        project.setValue(date, forKeyPath: "date")
        project.setValue(level.text, forKey: "level")
        project.setValue(moduleName.text, forKey: "moduleName")
        
        let val = value.text!
        project.setValue(Int(val ), forKey: "value")
        project.setValue(Int(marks.text ?? "0"), forKey: "mark")
        
        do {
            try managedContext.save()
            projects.append(project)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        let eventStore = EKEventStore()
        var calendarIdentifier = ""
        
        if addToCalendarSwitch.isOn {
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in
                    calendarIdentifier = self.createEvent(eventStore, title: name!, startDate: Date(), endDate: date)
                })
            } else {
                calendarIdentifier = createEvent(eventStore, title: name!, startDate: Date(), endDate: date)
            }
            
            if calendarIdentifier != "" {
                print("Added to calendaer")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
        mainDelegate?.loadData()

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

extension AddProjectTableViewController {
    
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
        
        // Make Notes text view bigger: 80
        if indexPath.section == 2 && indexPath.row == 0 {
            return 50.0
        }
        return 0
    }
    
}
