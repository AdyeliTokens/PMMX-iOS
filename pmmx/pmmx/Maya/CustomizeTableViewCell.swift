//
//  qsTableViewCell.swift
//  PMMX
//
//  Created by ISPMMX on 8/10/17.
//  Copyright © 2017 ISPMMX. All rights reserved.
//
import UIKit

class CustomizeTableViewCell: UITableViewCell
{
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
