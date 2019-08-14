//
//  AddNgayGioCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/9/19.
//

import UIKit

class AddNgayGioCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tfGio: ExTextField!
    @IBOutlet var tfNgay: ExTextField!
    @IBOutlet var btnGio: UIButton!
    @IBOutlet var btnNgay: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfGio.textAlignment = .center
        tfNgay.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
