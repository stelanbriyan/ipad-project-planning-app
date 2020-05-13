//
//  AddProjectTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData

class AddProjectTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    var projects: [NSManagedObject] = []
    
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDate: UIDatePicker!
    @IBOutlet weak var projectDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let project = NSManagedObject(entity: entity, insertInto: managedContext)
        
        project.setValue(name, forKeyPath: "name")
        project.setValue(note, forKeyPath: "note")
        project.setValue(date, forKeyPath: "date")
        print(project)
        do {
            try managedContext.save()
            projects.append(project)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
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
            return 150.0
        }
        
        return 0
    }
    
}
