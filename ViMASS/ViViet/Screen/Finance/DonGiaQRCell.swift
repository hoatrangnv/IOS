//
//  DonGiaQRCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/8/19.
//

import UIKit

class DonGiaQRCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tfGia: ExTextField!
    @IBOutlet var lblPhi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
