//
//  TaoQRYTeDongViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class TaoQRYTeDongViewController: GiaoDichViewController {

    @IBOutlet var tableView: UITableView!
    var nhapDonHangView:NhapDonHangYTeDongView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitleView("Thêm QR y tế")
        self.tableView.register(UINib(nibName: "TaoQRNameCell", bundle: nil), forCellReuseIdentifier: "TaoQRNameCell")
        self.tableView.register(UINib(nibName: "ThongTinCtyYTeCell", bundle: nil), forCellReuseIdentifier: "ThongTinCtyYTeCell")
        self.tableView.register(UINib(nibName: "InfoNhanHoaDonCell", bundle: nil), forCellReuseIdentifier: "InfoNhanHoaDonCell")
        self.tableView.register(UINib(nibName: "SheetInfoQRYTeCell", bundle: nil), forCellReuseIdentifier: "SheetInfoQRYTeCell")
        self.tableView.register(UINib(nibName: "TongTienQRCell", bundle: nil), forCellReuseIdentifier: "TongTienQRCell")
        self.tableView.register(UINib(nibName: "AddNgayGioCell", bundle: nil), forCellReuseIdentifier: "AddNgayGioCell")
        self.tableView.register(UINib(nibName: "AuthenQRCell", bundle: nil), forCellReuseIdentifier: "AuthenQRCell")
        
    }

    func hienThiNhapDonHang() {
        if nhapDonHangView == nil {
            nhapDonHangView = NhapDonHangYTeDongView.instanceFromNib()
            nhapDonHangView.frame = self.view.bounds
            self.view.addSubview(nhapDonHangView)
        }
        nhapDonHangView.isHidden = false
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

extension TaoQRYTeDongViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 2 {
            return 2
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                return 60
            } else if indexPath.row == 2 {
                return 100
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = HeaderSheetInfoQRYTeView.instanceFromNib()
            header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThongTinCtyYTeCell", for: indexPath) as! ThongTinCtyYTeCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SheetInfoQRYTeCell", for: indexPath) as! SheetInfoQRYTeCell
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TongTienQRCell", for: indexPath) as! TongTienQRCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            hienThiNhapDonHang()
        }
    }
}
