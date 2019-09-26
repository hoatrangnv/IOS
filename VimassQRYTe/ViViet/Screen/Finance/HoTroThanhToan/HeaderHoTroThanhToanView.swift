//
//  HeaderHoTroThanhToanView.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 9/23/19.
//

import UIKit

class HeaderHoTroThanhToanView: UIView {
    @IBOutlet var lblHoTen: UILabel!
    @IBOutlet var lblCMND: UILabel!
    @IBOutlet var lblSoTien: UILabel!
    @IBOutlet var lblVAT: UILabel!
    @IBOutlet var btnDel: UIButton!
    @IBOutlet var btnQR: UIButton!
    
    class func instanceFromNib() -> HeaderHoTroThanhToanView {
        return UINib(nibName: "HeaderHoTroThanhToanView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! HeaderHoTroThanhToanView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblHoTen.text = ""
        lblCMND.text = ""
        lblSoTien.text = ""
        lblVAT.text = ""
    }
}
