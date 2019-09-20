//
//  GiaoDienQRYTeViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class GiaoDienQRYTeViewController: GiaoDichViewController {
    private let TAG = "GiaoDienQRYTeViewController"
    private let arrOptions = ["Tạo, sửa, xoá QR y tế tĩnh" , "Tạo, sửa, xoá QR y tế động" , "Tra cứu giao dịch", "Đối soát", "Phát hành hoá đơn", "Thẩm quyền"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("QR Y tế")
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "ic_question_32"), style: .done, target: self, action: #selector(suKienChonQuestion(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        
        tableView.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
    }

    @objc func suKienChonQuestion(_ sender:UIBarButtonItem) {
        
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

extension GiaoDienQRYTeViewController : UITableViewDelegate, UITableViewDataSource {
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
            let vc = DanhSachQRYTeViewController(nibName: "DanhSachQRYTeViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = TaoQRYTeDongViewController(nibName: "TaoQRYTeDongViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = DucNT_SaoKeViewController(nibName: "DucNT_SaoKeViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            self.hienThiHopThoaiMotNutBamKieu(0, cauThongBao: "Chức năng đang được phát triển")
        }
    }
}
