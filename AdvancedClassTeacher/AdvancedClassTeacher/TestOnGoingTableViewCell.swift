//
//  TestTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TestOnGoingTableViewCell: UITableViewCell {
    
    @IBOutlet var createdOnLabel: UILabel!
    var progressView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
