//
//  TestTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet var createdOnLabel: UILabel!
    @IBOutlet var progressView: MyProgressBar!
    var finished: Bool = false{
        didSet{
            if finished{
                self.finishedLabel?.text = "已完成"
                self.finishedLabel?.textColor = UIColor.greenColor()
            }
            else{
                self.finishedLabel?.text = "正在进行"
                self.finishedLabel?.textColor = UIColor.redColor()
            }
        }
    }
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
