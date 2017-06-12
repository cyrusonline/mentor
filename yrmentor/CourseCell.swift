//
//  CourseCell.swift
//  yrmentor
//
//  Created by Cyrus Chan on 3/6/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet weak var courseImage: UIImageView!

    
    @IBOutlet weak var courseTitle: UILabel!
    
    @IBOutlet weak var coursePrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
