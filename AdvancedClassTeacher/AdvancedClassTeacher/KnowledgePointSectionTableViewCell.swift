//
//  KnowledgePointSectionTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/3.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class KnowledgePointSectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var expandImage: UIImageView!
    
    @IBOutlet var label: UILabel!
    
    var sectionNum = 0
    
    
    var expanded: Bool = false{
        didSet{
            if self.expandImage == nil{
                return
            }
            if expanded{
                self.expandImage.image = UIImage(named: "arrow_down.png")
            }
            else{
                self.expandImage.image = UIImage(named: "arrow_right.png")
            }
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
 
    
}
