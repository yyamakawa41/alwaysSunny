//
//  forecastTableViewCell.swift
//  alwaysSunny
//
//  Created by Yohsuke Yamakawa on 12/9/15.
//  Copyright © 2015 DigitalCrafts. All rights reserved.
//

import UIKit

class forecastTableViewCell: UITableViewCell {

    @IBOutlet weak var cellIconImageView: UIImageView!
    
    @IBOutlet weak var cellDayLabel: UILabel!
    
    @IBOutlet weak var cellDescLabel: UILabel!
    
    @IBOutlet weak var cellHighTempLabel: UILabel!
    
    @IBOutlet weak var cellLowTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
