//
//  GiaoDienTheATMViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/18/19.
//

import UIKit

class GiaoDienTheATMViewController: GiaoDichViewController {
    private let TAG = "GiaoDienTheATMViewController"
//    @IBOutlet var scrMain: UIScrollView!
    @IBOutlet var btnHuyTiepTuc: UIButton!
    @IBOutlet var btnTiepTuc: UIButton!
    @IBOutlet var btnHuyThanhToan: UIButton!
    @IBOutlet var btnThanhToan: UIButton!
    
    @IBOutlet var tfTenChuThe: UITextField!
    @IBOutlet var tfSoThe: UITextField!
    @IBOutlet var tfNgayMoThe: UITextField!
    @IBOutlet var tfMaThanhToan: UITextField!
    @IBOutlet var tfSoTien: UITextField!
    @IBOutlet var tfMaOTP: UITextField!
    @IBOutlet var viewTiepTuc: UIView!
    @IBOutlet var viewThanhToan: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("Thẻ ATM")
        createButton(btnHuyTiepTuc)
        createButton(btnTiepTuc)
        createButton(btnHuyThanhToan)
        createButton(btnThanhToan)
        
        tfMaOTP.isHidden = true
        viewThanhToan.isHidden = true
    }
    
    func createButton(_ btn:UIButton) {
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
    }

    @IBAction func suKienChonHuyTiepTuc(_ sender: Any) {
        tfMaOTP.isHidden = true
        viewThanhToan.isHidden = true
    }
    
    @IBAction func suKienChonTiepTuc(_ sender: Any) {
        tfMaOTP.isHidden = false
        viewThanhToan.isHidden = false
        self.view.endEditing(true)
    }
    
    @IBAction func suKienChonHuyThanhToan(_ sender: Any) {
    }
    
    @IBAction func suKienChonThanhToan(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
