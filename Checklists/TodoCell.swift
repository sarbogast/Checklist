//
//  TodoCell.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 30/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var doneLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
