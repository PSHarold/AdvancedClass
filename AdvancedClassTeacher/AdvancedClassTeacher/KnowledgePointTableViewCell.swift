//
//  KnowledgePointTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/4.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class KnowledgePointTableViewCell: UITableViewCell {

    @IBOutlet var pointContentLabel: UILabel!
    
    @IBOutlet var levelLabel: UILabel!
    
    @IBOutlet var chosenNumLabel: UILabel!
    var knowledgePointContent = ""{
        didSet{
            self.pointContentLabel?.text = self.knowledgePointContent
        }
    }
    
    
    var knowledgePointLevel  = 0{
        didSet{
            var s: String
            switch knowledgePointLevel{
            case 1:
                s = "一般"
            case 2:
                s = "较重点"
            case 3:
                s = "重点"
            default:
                s = "无"
            }
           // self.levelLabel.text = s
        }
    }
    
    var chosenNum = 0{
        didSet{
            if self.chosenNum == 0{
                self.chosenNumLabel.hidden = true
            }
            else{
                self.chosenNumLabel.hidden = false
                self.chosenNumLabel.text = "已选：\(self.chosenNum)"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.chosenNumLabel.hidden = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
