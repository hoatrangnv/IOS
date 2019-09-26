//
//  ItemThanhToanCell.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 9/23/19.
//

import UIKit

class ItemThanhToanCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = ""
        lblSubTitle.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
