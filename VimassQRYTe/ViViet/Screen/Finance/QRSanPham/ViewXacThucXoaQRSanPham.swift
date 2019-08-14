//
//  ViewXacThucXoaQRSanPham.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 7/12/19.
//

import UIKit

protocol ViewXacThucXoaQRSanPhamDelegate {
    func suKienChonThucHienToken(_ sToken:String)
    func suKienChonVanTay(_ sender:Any)
    func suKienChonPKI()
    func cancelDeleteQRSanPham()
}

class ViewXacThucXoaQRSanPham: UIView {

    @IBOutlet var viewToken: UIView!
    @IBOutlet var btnToken: UIButton!
    @IBOutlet var btnVanTay: UIButton!
    @IBOutlet var btnPKI: UIButton!
    @IBOutlet var btnThucHien: UIButton!
    @IBOutlet var tfToken: ExTextField!
    var delegate:ViewXacThucXoaQRSanPhamDelegate?
    
    var isFace = false {
        didSet {
            if self.isFace {
                self.btnVanTay.setImage(UIImage(named: "face-id"), for: .normal)
            } else {
                self.btnVanTay.setImage(UIImage(named: "finger"), for: .normal)
            }
        }
    }

    class func instanceFromNib() -> ViewXacThucXoaQRSanPham {
        return UINib(nibName: "ViewXacThucXoaQRSanPham", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ViewXacThucXoaQRSanPham
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewToken.isHidden = true
        tfToken.max_length = 6
        tfToken.placeholder = Localization.languageSelectedString(forKey: "register_token_hint_token")
//            "register_token_hint_token".localizableString
    }
    
    @IBAction func suKienChonVanTay(_ sender: Any) {
        if let delegate = delegate {
            delegate.suKienChonVanTay(sender)
        }
    }
    
    @IBAction func suKienChonPKI(_ sender: Any) {
        if let delegate = delegate {
            delegate.suKienChonPKI()
        }
    }
    
    @IBAction func suKienChonToken(_ sender: Any) {
        viewToken.isHidden = false
    }
    
    @IBAction func suKienChonThucHien(_ sender: Any) {
        tfToken.resignFirstResponder()
        if let delegate = delegate {
            delegate.suKienChonThucHienToken(tfToken.text!)
        }
    }
    
    @IBAction func suKienChonCancel(_ sender: Any) {
        if let delegate = delegate {
            delegate.cancelDeleteQRSanPham()
        }
        self.removeFromSuperview()
    }
}
