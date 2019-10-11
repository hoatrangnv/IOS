//
//  GiaoDienViVimass.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

import UIKit

class GiaoDienViVimass: GiaoDichViewController {
//    private let arrOption = ["Sao kê", "Chuyển tiền đến Ví Vimass", "Chuyển tiền đến tài khoản", "Chuyển tiền đến thẻ", "Chuyển tiền đến CMND", "Liên kết thẻ y tế", "Huỷ liên kết thẻ y tế", "Nạp tiền thẻ y tế", "Rút tiền thẻ y tế về ví", "Thông tin cá nhân", "Token"]
    private let arrOption = ["Thanh toán viện phí bằng ví", "Nạp tiền vào ví", "Sao kê ví", "Chuyển tiền", "Liên kết với thẻ y tế và huỷ bỏ", "Nạp tiền thẻ y tế và rút tiền về ví", "Thông tin cá nhân", "Token"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("Ví điện tử")
        tableView.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
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

extension GiaoDienViVimass : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOption.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(arrOption.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.text = arrOption[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.mThongTinTaiKhoanVi != nil) {
            if indexPath.row == 0 {
                let vc = ThanhToanVienPhiViewController(nibName: "ThanhToanVienPhiViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                let vc = SaoKeViVimassViewController(nibName: "SaoKeViVimassViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 3 {
                self.navigationController?.navigationBar.isHidden = true
                let vc = ChuyenTienNewViewController(nibName: "ChuyenTienNewViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 6 {
                let vc = DucNT_ChangPrivateInformationViewController(nibName: "DucNT_ChangPrivateInformationViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 7 {
                let vc = DucNT_HienThiTokenViewController(nibName: "DucNT_HienThiTokenViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 4 {
                let vc = ChuyenTienViewController(nibName: "ChuyenTienViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 5 {
                let vc = GiaoDienTaiKhoanLienKet(nibName: "GiaoDienTaiKhoanLienKet", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = DucNT_LoginSceen(nibName: "DucNT_LoginSceen", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
