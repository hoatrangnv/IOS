//
//  ThanhToanVienPhiViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/2/19.
//

import UIKit

class ThanhToanVienPhiViewController: GiaoDichViewController {
    private let TAG = "ThanhToanVienPhiViewController"
    @IBOutlet var tfSoTien: ExTextField!
    @IBOutlet var tfMaThanhToan: ExTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.mThongTinTaiKhoanVi != nil {
            let nAmount = self.mThongTinTaiKhoanVi.nAmount.doubleValue
            self.navigationItem.setTwoLineTitle(lineOne: "Thanh toán viện phí", lineTwo: "Số dư: \(Common.hienThiTienTe(nAmount) ?? "0")")
            if let titleView = self.navigationItem.titleView {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapToTitleView(_:)))
                titleView.addGestureRecognizer(tap)
                titleView.isUserInteractionEnabled = true
            }
        } else {
            self.addTitleView("Thanh toán viện phí")
        }
        
        tfSoTien.addTarget(self, action: #selector(suKienNhapSoTien(_:)), for: .editingChanged)
    }
    
    @objc func suKienNhapSoTien(_ sender:ExTextField) {
        if let sSoTien = sender.text {
            let sSoTienTemp = sSoTien.replacingOccurrences(of: ".", with: "")
            let dSoTien = Double(sSoTienTemp) ?? 0
            sender.text = Common.hienThiTienTe(dSoTien)
        }
    }

    @objc func tapToTitleView(_ gesture:UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

    override func validateVanTay() -> Bool {
        let arrText = [tfSoTien, tfMaThanhToan]
        let arrCheck = arrText.filter { (tf) -> Bool in
            return tf?.text?.isEmpty ?? false
        }
        if arrCheck.count > 0 {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Vui lòng nhập đầy đủ dữ liệu")
            return false
        }
        return true
    }
    
    func connectGetInfoMaKhachHang() {
        guard let sMaKhachHang = tfMaThanhToan.text else {
            self.anLoading()
            return
        }
        let sURL = "\(ROOT_URL)boYTe_hoaDonDatCoc/getQRYTeDetail?maQR=\(sMaKhachHang)"
        debugPrint("\(self.TAG) - \(#function) - line : \(#line) - sURL : \(sURL)")
        let urlRequest = NSURLRequest(url: URL(string: sURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                self.anLoading()
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
                return
            }
            guard let responseData = data else {
                DispatchQueue.main.async {
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
                return
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - statusCode : \(String(data: responseData, encoding: .utf8))")
            if statusCode == 200 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                        let msgCode = json["msgCode"] as? Int
                        if msgCode == 1 {
                            
                        }
                    }
                } catch{}
            } else {
                DispatchQueue.main.async {
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
                
            }
        }
        task.resume()
    }
    
    override func xuLyThucHienKhiKiemTraThanhCongTraVeToken(_ sToken: String!, otp sOtp: String!) {
        self.hienThiLoadingChuyenTien()
        self.connectGetInfoMaKhachHang()
    }
}
