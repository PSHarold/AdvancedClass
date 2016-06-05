//
//  CourseTableViewCell.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/5/27.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var coverImage: UIImage?{
        get{
            return self.coverImageView.image
        }
        set{
            if let image = newValue{
                self.coverImageView.image = image
            }
            else{
                self.coverImageView.image = UIImage(named: "no_cover")
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      //  self.detailLabel?.text = "123"
        // Configure the view for the selected state
    }
    
}
