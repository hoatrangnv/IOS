//
//  ShowQRSanPhamView.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/18/19.
//

import UIKit

class ShowQRSanPhamView: UIView {

    @IBOutlet var imgvPreview: UIImageView!

    class func instanceFromNib() -> ShowQRSanPhamView {
        return UINib(nibName: "ShowQRSanPhamView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ShowQRSanPhamView
    }
    
    @IBAction func suKienChonClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
