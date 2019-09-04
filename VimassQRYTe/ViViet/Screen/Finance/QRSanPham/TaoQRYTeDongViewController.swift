//
//  TaoQRYTeDongViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class TaoQRYTeDongViewController: GiaoDichViewController {

    @IBOutlet var tableView: UITableView!
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
            return 7
        } else if section == 2 {
            return 3
        }
        return 1
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThongTinCtyYTeCell", for: indexPath) as! ThongTinCtyYTeCell
                return cell
            } else if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoNhanHoaDonCell", for: indexPath) as! InfoNhanHoaDonCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
                switch indexPath.row {
                case 1:
                    cell.tfName.placeholder = "Họ & tên"
                case 2:
                    cell.tfName.placeholder = "Tên phí, lệ phí"
                case 3:
                    cell.tfName.placeholder = "Lý do thu"
                case 4:
                    cell.tfName.placeholder = "Địa chỉ 1"
                case 5:
                    cell.tfName.placeholder = "Địa chỉ 2"
                default:
                    cell.tfName.placeholder = ""
                }
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SheetInfoQRYTeCell", for: indexPath) as! SheetInfoQRYTeCell
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TongTienQRCell", for: indexPath) as! TongTienQRCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNgayGioCell", for: indexPath) as! AddNgayGioCell
                cell.lblTitle.text = "Hạn thanh toán"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
                return cell
            }
        }
    }
}
