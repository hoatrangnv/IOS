//
//  HoTroThanhToanViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 9/23/19.
//

import UIKit

class HoTroThanhToanViewController: GiaoDichViewController {

    private let arrHuongDan = ["Thanh toán viện phí bằng chuyển khoản thẻ ATM", "Thanh toán viện phí bằng QR y tế", "Thanh toán viện phí bằng", "Thanh toán viện phí bằng thẻ y tế"]
    private let TAG = "HoTroThanhToanViewController"
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}

extension HoTroThanhToanViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHuongDan.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.textColor = UIColor(red: 0, green: 114.0/255.0, blue: 187.0/255.0, alpha: 1)
        cell.lblTitle.text = arrHuongDan[indexPath.row]
        return cell
    }
}

//extension HoTroThanhToanViewController : ViewXacThucXoaQRSanPhamDelegate {
//    func suKienChonThucHienToken(_ sToken: String) {
//        if sToken.count == 6 {
//            self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN
//            self.sToken = self.xuLyKhiBamThucHienToken(sToken)
//            self.sOTP = ""
//            DispatchQueue.main.async {
//                self.hienThiLoadingChuyenTien()
//            }
//            xoaSanPham()
//        }
//    }
//
//    func suKienChonVanTay(_ sender: Any) {
//        self.suKienBamNutMatKhauVanTay(sender)
//    }
//
//    func suKienChonPKI() {
//        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Thiết bị chưa hỗ trợ ký số")
//    }
//
//    func cancelDeleteQRSanPham() {
//
//    }
//}
