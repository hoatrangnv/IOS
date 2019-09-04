//
//  DanhSachViVimassCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

import UIKit

class DanhSachViVimassCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
