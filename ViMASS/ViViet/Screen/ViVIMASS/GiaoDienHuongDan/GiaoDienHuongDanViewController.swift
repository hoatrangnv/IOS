//
//  GiaoDienHuongDanViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 11/20/19.
//

import UIKit

class GiaoDienHuongDanViewController: GiaoDichViewController {

    @IBOutlet var btnQR: UIButton!
    @IBOutlet var btnHuongDan: UIButton!
    @IBOutlet var viewQR: UIView!
    @IBOutlet var webHuongDan: UIWebView!
    @IBOutlet var imgvQR: UIImageView!
    @IBOutlet var imgvAvatar: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStateButton(btnHuongDan, btn2: btnQR)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        khoiTaoBanDau()
    }
    
    func khoiTaoBanDau() {
        if let linkQR = self.mThongTinTaiKhoanVi.linkQR {
            CommonUtils.displayImage(URL(string: linkQR), to: self.imgvQR, placeHolder: nil)
        }
        let sAvatar = self.mThongTinTaiKhoanVi.sLinkAnhDaiDien ?? ""
        self.imgvAvatar.sd_setImage(with: URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(sAvatar)"), placeholderImage: UIImage(named: "https://vimass.vn/vmbank/services/media/getImage?id=%@"))
        if let htmlFile = Bundle.main.path(forResource: "hd_quang_cao_vi", ofType: "html") {
            do {
                let htmlString = try String(contentsOfFile: htmlFile, encoding: .utf8)
                webHuongDan.loadHTMLString(htmlString, baseURL: nil)
            } catch  {
                
            }
        }
    }

    @IBAction func suKienChonBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func suKienChonQRChuVi(_ sender: Any) {
        updateStateButton(btnHuongDan, btn2: btnQR)
        webHuongDan.isHidden = true
        viewQR.isHidden = false
    }
    
    @IBAction func suKienChonHuongDan(_ sender: Any) {
        updateStateButton(btnQR, btn2: btnHuongDan)
        webHuongDan.isHidden = false
        viewQR.isHidden = true
    }
    
    func updateStateButton(_ btn1:UIButton, btn2:UIButton) {
        btn1.backgroundColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1)
        btn1.setTitleColor(UIColor.black, for: .normal)
        
        btn2.backgroundColor = UIColor.clear
        btn2.setTitleColor(UIColor.white, for: .normal)
    }
}
