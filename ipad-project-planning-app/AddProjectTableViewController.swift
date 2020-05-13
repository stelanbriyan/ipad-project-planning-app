//
//  AddProjectTableViewController.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit

class AddProjectTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDate: UIDatePicker!
    @IBOutlet weak var projectDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        
        
        
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
