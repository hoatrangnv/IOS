//
//  DanhSachQRYTeCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/11/19.
//

import UIKit

class DanhSachQRYTeCell: UITableViewCell {
    @IBOutlet var lblTenHienThi: UILabel!
    @IBOutlet var lblGia: UILabel!
    @IBOutlet var lblDC1: UILabel!
    @IBOutlet var lblDC2: UILabel!
    
    @IBOutlet var imgvAvatar: UIImageView!
    @IBOutlet var imgvQR: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
