//
//  ViewProjectTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData

class ViewProjectTableViewController: UITableViewController {
    
    let dateFormatter : DateFormatter = DateFormatter()
    var projects: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            projects = try managedContext.fetch(fetchRequest)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectTableViewCell
        
        let project = projects[indexPath.row] as! NSManagedObject;
        cell.name.text = project.value(forKey: "name") as? String;
        
        let date = project.value(forKey: "date")
        
        if (date != nil) {
            cell.date.text = dateFormatter.string(from: date as! Date)
        }else{
            cell.date.text = ""
        }
        return cell
    }
    
}
