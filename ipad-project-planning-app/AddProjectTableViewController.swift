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
    
    @IBOutlet weak var moduleName: UITextField!
    
    @IBOutlet weak var value: UITextField!
    
    @IBOutlet weak var marks: UITextField!
    
    var mainDelegate: ViewProjectTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let project = NSManagedObject(entity: entity, insertInto: managedContext)
        
        project.setValue(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()), forKey: "projectNum")
        project.setValue(name, forKeyPath: "name")
        project.setValue(note, forKeyPath: "note")
        project.setValue(date, forKeyPath: "date")
        project.setValue(moduleName.text, forKey: "moduleName")
        project.setValue(Date(), forKeyPath: "startDate")
        
        let val = value.text!
        project.setValue(Int(val ), forKey: "value")
        project.setValue(Int(marks.text ?? "0"), forKey: "mark")
        
        do {
            try managedContext.save()
            projects.append(project)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        dismiss(animated: true, completion: nil)
        
        mainDelegate?.loadData()

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
