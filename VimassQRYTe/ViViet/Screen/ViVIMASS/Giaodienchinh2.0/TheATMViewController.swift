//
//  TheATMViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/13/19.
//

import UIKit

class TheATMViewController: GiaoDichViewController {

    @IBOutlet var tfMaThanhToan: ExTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitleView("Thẻ ATM")
        
        let btnRight = UIBarButtonItem(title: "Hướng dẫn", style: .plain, target: self, action: #selector(suKienChonHuongDan))
        self.navigationItem.rightBarButtonItem = btnRight
    }

    @IBAction func suKienChonThanhToan(_ sender: Any) {
        if tfMaThanhToan.text?.isEmpty ?? true {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Vui lòng nhập mã thanh toán")
            return
        }
        let vc = GiaoDienTheATMViewController(nibName: "GiaoDienTheATMViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func suKienChonHuongDan() {
        
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
