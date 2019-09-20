//
//  HoTroThanhToanViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/8/19.
//

import UIKit

class HoTroThanhToanViewController: GiaoDichViewController {
    private let TAG = "HoTroThanhToanViewController"
    private let arrOptions = ["Tìm QR theo tên", "Tìm điểm có QR", "Quét QR"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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


extension HoTroThanhToanViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.text = arrOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = TimQRYTeViewController(nibName: "TimQRYTeViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = GiaoDienDiemThanhToanVNPAY(nibName: "GiaoDienDiemThanhToanVNPAY", bundle: nil)
            vc.nType = 1
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if QRCodeReader.supportsMetadataObjectTypes([AVMetadataObject.ObjectType.qr]) {
                let reader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr])
                let vc = QRSearchViewController(nibName: "QRSearchViewController", bundle: nil)
                vc.codeReader = reader
                vc.delegate = self
                vc.nType = 1
                self.present(vc, animated: true, completion: nil)
            }
//            if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
//                QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
//                QRSearchViewController *vcQRCodeTemp = [[QRSearchViewController alloc]initWithNibName:@"QRSearchViewController" bundle:nil];
//                vcQRCodeTemp.codeReader = reader;
//                vcQRCodeTemp.modalPresentationStyle = UIModalPresentationFormSheet;
//                vcQRCodeTemp.delegate = self;
//                vcQRCodeTemp.nType = 1;
//                [self presentViewController:vcQRCodeTemp animated:YES completion:NULL];
//            }
        }
    }
}

extension HoTroThanhToanViewController : QRCodeReaderDelegate {
    func readerDidCancel(reader : QRSearchViewController ) {
        debugPrint("\(TAG) - \(#function) - line : \(#line) - can can")
    }
}
