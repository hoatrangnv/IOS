//
//  GiaoDienViVimass.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 8/21/19.
//

import UIKit

class GiaoDienViVimass: GiaoDichViewController {
//    private let arrOption = ["Chuyển tiền đến Ví Vimass", "Chuyển tiền đến tài khoản", "Chuyển tiền đến thẻ", "Sao kê", "6 số Token", "Đổi thông tin"]
    private let arrOption = ["Sao kê", "Chuyển tiền đến Ví Vimass", "Chuyển tiền đến tài khoản", "Chuyển tiền đến thẻ", "Chuyển tiền đến CMND", "Liên kết thẻ y tế", "Huỷ liên kết thẻ y tế", "Nạp tiền thẻ y tế", "Rút tiền thẻ y tế về ví", "Thông tin cá nhân", "Token"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("Ví Vimass")
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
        if indexPath.row == 0 {
            let vc = SaoKeViVimassViewController(nibName: "SaoKeViVimassViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            let vc = DucNT_ChuyenTienViDenViViewController(nibName: "DucNT_ChuyenTienViDenViViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = DucNT_ChuyenTienDenTaiKhoanViewController(nibName: "DucNT_ChuyenTienDenTaiKhoanViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = DucNT_ChuyenTienDenTheViewController(nibName: "DucNT_ChuyenTienDenTheViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = GiaoDienChuyenTienDenCMND(nibName: "GiaoDienChuyenTienDenCMND", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc = DucNT_HienThiTokenViewController(nibName: "DucNT_HienThiTokenViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = DucNT_ChangPrivateInformationViewController(nibName: "DucNT_ChangPrivateInformationViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Chức năng đang được phát triển.")
        }
    }
}
