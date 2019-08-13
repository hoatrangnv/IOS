//
//  AuthenQRCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/11/19.
//

import UIKit

protocol AuthenQRCellDelegate {
    func suKienChonThucHienAuth(_ sToken:String)
}

class AuthenQRCell: UITableViewCell {

    @IBOutlet var btnToken: UIButton!
    @IBOutlet var btnAuthen: UIButton!
    @IBOutlet var btnPKI: UIButton!
    @IBOutlet var tfToken: ExTextField!
    @IBOutlet var viewToken: UIView!
    var delegate:AuthenQRCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfToken.max_length = 6
        tfToken.placeholder = Localization.languageSelectedString(forKey: "register_token_hint_token")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func suKienChonThucHien(_ sender: Any) {
        if let delegate = delegate {
            delegate.suKienChonThucHienAuth(tfToken.text ?? "")
        }
    }
}
