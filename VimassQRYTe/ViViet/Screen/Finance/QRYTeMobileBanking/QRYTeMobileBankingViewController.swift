//
//  QRYTeMobileBankingViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/9/19.
//

import UIKit

class QRYTeMobileBankingViewController: GiaoDichViewController {
    private let arrHuongDan = ["Vietcombank", "Vietinbank", "Agribank", "VPBank", "NCB"]
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("QR Y tế cho Mobile Banking")
        tableView.tableFooterView = UIView(frame: .zero)
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

extension QRYTeMobileBankingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHuongDan.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.textColor = UIColor.black
        cell.lblTitle.text = arrHuongDan[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
