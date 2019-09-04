//
//  GiaoDienTraCuQRViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class GiaoDienTraCuQRViewController: GiaoDichViewController {
    private let arrOptions = ["Tìm QR Y tế theo tên" , "Tìm điểm có QR y tế" , "Tìm điểm có VNPAY QR", "Hướng dẫn tra cứu"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitleView("Tra cứu QR")
        self.tableView.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
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

extension GiaoDienTraCuQRViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(arrOptions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.text = arrOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TimQRYTeViewController(nibName: "TimQRYTeViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = GiaoDienDiemThanhToanVNPAY(nibName: "GiaoDienDiemThanhToanVNPAY", bundle: nil)
            vc.nType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = GiaoDienDiemThanhToanVNPAY(nibName: "GiaoDienDiemThanhToanVNPAY", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            self.hienThiHopThoaiMotNutBamKieu(0, cauThongBao: "Chức năng đang được phát triển")
        }
    }
}
