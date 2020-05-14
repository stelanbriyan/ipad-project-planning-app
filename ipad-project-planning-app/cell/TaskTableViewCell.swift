//
//  TaskTableViewCell.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/13/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskNote: UILabel!
    @IBOutlet weak var taskNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
