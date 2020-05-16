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
    var tasks: [Any] = []
    let dateFormatter : DateFormatter = DateFormatter()

    @IBOutlet weak var moduleName: UILabel!
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
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        projectName.text = (project?.value(forKey: "name") as? String)?.uppercased()
        moduleName.text = project?.value(forKey: "moduleName") as? String
        
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
            let colours = self.colours.getProgressGradient(daysRemaining, negative: true)
            self.dayProgress?.customTitle = "\(daysRemainingCount)"
            self.dayProgress?.customSubtitle = "Days Left"
            self.dayProgress?.startGradientColor = colours[0]
            self.dayProgress?.endGradientColor = colours[1]
            self.dayProgress?.progress = CGFloat(daysRemaining) / 100
            self.dayProgress?.isHidden = false
        }
        
        loadData()
    }
    
    func loadData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let predicate = NSPredicate(format: "projectNum = %@", project?.value(forKey: "projectNum") as! CVarArg)
        fetchRequest.predicate = predicate
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            print(tasks.count)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        if(tasks.count > 0){
            var daysRemaining: Int = 0
            
            for task in tasks {
                
                let startDate = (task as AnyObject).value(forKey: "startDate")
                let dueDate = (task as AnyObject).value(forKey: "date")
                
                daysRemaining += Int(self.dateUtils.getRemainingTimePercentage(startDate! as! Date, end: dueDate! as! Date))
            }
            
            let percentage = daysRemaining / tasks.count
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(percentage)
                self.completeProgress?.customSubtitle = "Completed"
                self.completeProgress?.startGradientColor = colours[0]
                self.completeProgress?.endGradientColor = colours[1]
                self.completeProgress?.progress = CGFloat(percentage) / 100
                self.completeProgress?.isHidden = false
            }
            
        }else{
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(100)
                self.completeProgress?.customSubtitle = "Completed"
                self.completeProgress?.startGradientColor = colours[0]
                self.completeProgress?.endGradientColor = colours[1]
                self.completeProgress?.progress = CGFloat(100) / 100
                self.completeProgress?.isHidden = false
            }
        }
        taskTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

    @IBAction func removeTask(_ sender: Any) {
        let indexPath =  taskTable.indexPathForSelectedRow
        
        if indexPath != nil {
            let alert = UIAlertController(title: "Remove Task", message: "Are you sure you want to remove selected task?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let task = self.tasks[indexPath!.row]
                
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                do {
                    managedContext.delete(task as! NSManagedObject)
                    try managedContext.save();
                }catch{}
                
                self.loadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(alert, animated: true, completion: nil)
        }else{
            let refreshAlert = UIAlertController(title: "Task is not selected", message: "Please select a task to remove", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                           
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        let task: NSManagedObject? = tasks[indexPath.row] as? NSManagedObject
        
        let num = indexPath.row + 1
        cell.taskNumber.text = "Task " + String(num)
        cell.taskName.text =  (((task?.value(forKey: "name") as? String))! + " (DUE: " + dateFormatter.string(from: task?.value(forKey: "date") as! Date) + ")").uppercased()
        cell.taskNote.text = task?.value(forKey: "note") as? String
        
        let startDate = task?.value(forKey: "startDate")
        let dueDate = task?.value(forKey: "date")
        
        let daysRemaining = self.dateUtils.getRemainingTimePercentage(startDate! as! Date, end: dueDate! as! Date)
       
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(daysRemaining, negative: true)
            cell.circleProgress?.customTitle = "\(daysRemaining)%"
            cell.circleProgress?.customSubtitle = ""
            cell.circleProgress?.startGradientColor = colours[0]
            cell.circleProgress?.endGradientColor = colours[1]
            cell.circleProgress?.progress = CGFloat(daysRemaining) / 100
            cell.progressBar?.isHidden = false
        }
        
        cell.progressBar.progress = Float(CGFloat(daysRemaining) / 100)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 230/255, alpha: 1.00)
        cell.selectedBackgroundView = bgColorView

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddTaskPop" {
            let controller = (segue.destination as! UINavigationController).topViewController as! AddTaskTableViewController
            controller.projectNum = self.project?.value(forKey: "projectNum") as? Int
            controller.delegate = self
            controller.maxDate = project?.value(forKey: "date") as? Date
        }
        
        if segue.identifier == "EditTaskPop" {
            if let indexPath = taskTable.indexPathForSelectedRow {
                let task = tasks[taskTable.indexPathForSelectedRow!.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! AddTaskTableViewController
                controller.projectNum = self.project?.value(forKey: "projectNum") as? Int
                controller.delegate = self
                controller.maxDate = project?.value(forKey: "date") as? Date
                controller.task = task as! NSManagedObject
                controller.editingMode = true
            }
        }
    }
    
}
