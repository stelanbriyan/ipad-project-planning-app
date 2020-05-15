//
//  ViewProjectTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit
import CoreData

class ViewProjectTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    let dateFormatter : DateFormatter = DateFormatter()
    var projects: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        loadData()
    }
    
    func loadData(){
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
            print(projects.count)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func deleteProject(_ sender: Any) {
        let indexPath =  tableView.indexPathForSelectedRow
        
        if indexPath != nil {
            let alert = UIAlertController(title: "Remove Project", message: "Are you sure you want to remove selected project?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let project = self.projects[indexPath!.row]
                
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                do {
                    managedContext.delete(project as! NSManagedObject)
                    try managedContext.save();
                }catch{}
                
                self.loadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(alert, animated: true, completion: nil)
        }else{
            let refreshAlert = UIAlertController(title: "Project is not selected", message: "Please select a project to remove", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                           
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectRow();
    }
    
    func selectRow(){
        let indexPath = IndexPath(row: 0, section: 0)
        if( tableView.numberOfRows(inSection: 0) > 0){
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        if tableView.indexPathForSelectedRow != nil {
            let project = projects[indexPath.row]
            self.performSegue(withIdentifier: "showProject", sender: project)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
        
        let moduleName = project.value(forKey: "moduleName")
        
        if (moduleName != nil){
            cell.moduleName.text = project.value(forKey: "moduleName") as? String
        }else{
            cell.moduleName.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        if tableView.indexPathForSelectedRow != nil {
            let project = projects[indexPath.row]
            self.performSegue(withIdentifier: "showProject", sender: project)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showProject" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let project = projects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! ProjectDetailViewController
                controller.project = project as? NSManagedObject
                controller.mainDelegate = self
            }
        }
        
        if segue.identifier == "AddProjectPopup" {
            let controller = (segue.destination as! UINavigationController).topViewController as! AddProjectTableViewController
            controller.mainDelegate = self
        }
        
    }
    
}
