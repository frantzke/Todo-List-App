//
//  TaskTableViewCell.swift
//  Todo List
//
//  Created by Lukas on 2019-09-11.
//  Copyright © 2019 Lukas. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
