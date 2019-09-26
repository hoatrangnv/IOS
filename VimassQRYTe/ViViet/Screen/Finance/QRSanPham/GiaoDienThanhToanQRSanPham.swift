//
//  GiaoDienThanhToanQRSanPham.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/17/19.
//

import UIKit

extension UINavigationItem {
    @objc func setTwoLineTitle(lineOne: String, lineTwo: String) {
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)] as [NSAttributedString.Key : Any]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)] as [NSAttributedString.Key : Any]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: lineOne, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: lineTwo, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        let height = CGFloat(44)
        
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleView = titleLabel
    }
}

class GiaoDienThanhToanQRSanPham: GiaoDichViewController {
    private let TAG = "GiaoDienThanhToanQRSanPham"
    @IBOutlet var tableView: UITableView!
    
    var maQRSanPham = ""
    var dictSanPham:[String:Any]?
    var isExistsDC = false
    var isExistsImage = false
    var isShowTokenView = false
    var sOTP = ""
    var sToken = ""
    var sNoiDung = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nAmount = self.mThongTinTaiKhoanVi.nAmount.doubleValue
        self.navigationItem.setTwoLineTitle(lineOne: "Thanh toán QR code", lineTwo: "Số dư: \(Common.hienThiTienTe(nAmount) ?? "0")")
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "QRSanPhamInfoCell", bundle: nil), forCellReuseIdentifier: "QRSanPhamInfoCell")
        self.tableView.register(UINib(nibName: "QRSanPhamTenSPDVCell", bundle: nil), forCellReuseIdentifier: "QRSanPhamTenSPDVCell")
        self.tableView.register(UINib(nibName: "QRSanPhamDiaChiCell", bundle: nil), forCellReuseIdentifier: "QRSanPhamDiaChiCell")
        self.tableView.register(UINib(nibName: "TaoQRNameCell", bundle: nil), forCellReuseIdentifier: "TaoQRNameCell")
        self.tableView.register(UINib(nibName: "AuthenQRCell", bundle: nil), forCellReuseIdentifier: "AuthenQRCell")
        self.tableView.register(UINib(nibName: "ShowImageSanPhamCell", bundle: nil), forCellReuseIdentifier: "ShowImageSanPhamCell")
        self.tableView.register(UINib(nibName: "DonGiaQRCell", bundle: nil), forCellReuseIdentifier: "DonGiaQRCell")
        self.tableView.register(UINib(nibName: "QRSanPhamDanhSachThanhToanCell", bundle: nil), forCellReuseIdentifier: "QRSanPhamDanhSachThanhToanCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        ketNoiLayThongTinSanPham()
        khoiTaoDuLieu()
    }
    
    func khoiTaoDuLieu() {
        let sData = DucNT_LuuRMS.layThongTinTrongRMSTheoKey("KEY_QR_SAN_PHAM_VER_2") as! String
        guard let data = sData.data(using: .utf8) else {
            return
        }
        do {
            if let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                debugPrint("\(TAG) - \(#function) - line : \(#line) - tao json thanh cong")
                self.dictSanPham = json
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } catch {
            
        }
    }

    func ketNoiLayThongTinSanPham() {
        if !maQRSanPham.isEmpty {
            DispatchQueue.main.async {
                self.hienThiLoading()
            }
            guard let url = URL(string: "https://vimass.vn/vmbank/services/boYTe_SanPhamYTe/layChiTietThongTinSanPhamDaiLy?maSo=\(maQRSanPham)") else {
                DispatchQueue.main.async {
                    self.anLoading()
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Sản phẩm không tồn tại!")
                }
                return
            }
            debugPrint("\(TAG) - \(#function) - line : \(#line) - url : \(url.absoluteString)")
            let urlRequest = NSMutableURLRequest(url: url)
            urlRequest.timeoutInterval = 60.0
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
                debugPrint("\(#function) - \(url.absoluteString) - statusCode : \(statusCode)")
                
                if statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                            self.dictSanPham = json["result"] as? [String : Any]
                            let msgCode = json["msgCode"] as! NSNumber
                            if msgCode.intValue == 1 {
                                if let diaChi1 = self.dictSanPham?["diaChi1"] as? String, let diaChi2 = self.dictSanPham?["diaChi2"] as? String {
                                    if !diaChi1.isEmpty || !diaChi2.isEmpty {
                                        self.isExistsDC = true
                                    }
                                }
                                if let image = self.dictSanPham?["image"] as? String, !image.isEmpty {
                                    self.isExistsImage = true
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            } else {
                                var key = "msgContent"
                                if Localization.getCurrentLang() == ENGLISH {
                                    key = "msgContent_en"
                                }
                                if let sThongBao = json[key] as? String {
                                    DispatchQueue.main.async {
                                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: sThongBao)
                                    }
                                }
                            }
                            
                        }
                    } catch{}
                }
                else {
                    DispatchQueue.main.async {
                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                    }
                }
            }
            task.resume()
        }
    }
    
    override func validateVanTay() -> Bool {
        return true
    }
    
    override func xuLyThucHienKhiKiemTraThanhCongTraVeToken(_ sToken: String!, otp sOtp: String!) {
        DispatchQueue.main.async {
            self.hienThiLoadingChuyenTien()
        }
        self.sToken = sToken
        self.sOTP = sOtp
        thanhToanQRSanPham()
    }
    
    func thanhToanQRSanPham() {
        if let dict = dictSanPham {
            var sMaDoanhNghiep = ""
            if let sKieuDangNhap = DucNT_LuuRMS.layThongTinDangNhap(KEY_HIEN_THI_VI) {
                let nKieuDangNhap = Int(sKieuDangNhap)
                if nKieuDangNhap == Int(KIEU_DOANH_NGHIEP) {
                    sMaDoanhNghiep = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_COMPANY_ID)
                }
            }
            let maDonVi = "\(dict["maDaiLy"] as! String)\(dict["tkNhanTien"] as! String)"
            
            var dictThanhToan = [String : Any]()
            dictThanhToan["companyCode"] = sMaDoanhNghiep
            dictThanhToan["loaiHinhThanhToan"] = 0
            dictThanhToan["maDonViThanhToan"] = maDonVi
            dictThanhToan["soTien"] = dict["gia"]
            dictThanhToan["tenSP"] = dict["ten"]
            dictThanhToan["maDonHang"] = dict["maGiaoDich"]
            dictThanhToan["noiDung"] = sNoiDung
            dictThanhToan["idViThanhToan"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP) ?? ""
            dictThanhToan["appId"] = 5
            dictThanhToan["token"] = sToken
            dictThanhToan["otpConfirm"] = sOTP
            dictThanhToan["typeAuthenticate"] = self.mTypeAuthenticate
            dictThanhToan["VMApp"] = 2
            dictThanhToan["tenNguoiNhanHang"] = ""
            dictThanhToan["soDienThoaiNguoiNhan"] = ""
            dictThanhToan["emailNguoiNhan"] = ""
            dictThanhToan["diaChiNguoiNhan"] = ""
            dictThanhToan["cmndNguoiNhan"] = ""
            dictThanhToan["soNgayTamGiu"] = 0
            dictThanhToan["keySave"] = "soza9whg35srotufvzm8nxi0ib5tltmi90h"
            dictThanhToan["tenNguoiGui"] = ""
            dictThanhToan["diaChiNguoiGui"] = ""
            dictThanhToan["cmndNguoiGui"] = ""
            dictThanhToan["emailNguoiGui"] = ""
            dictThanhToan["sdtNguoiGui"] = ""
            dictThanhToan["maKhachHang"] = ""
            dictThanhToan["giauViChuyen"] = 0
            
            if let json = dictThanhToan.jsonStringRepresentation {
                debugPrint("\(TAG) - \(#function) - line : \(#line) - json : \(json)")
                let sURL = "\(ROOT_URL)paymentGateway/paymentVimassPort"
                let urlRequest = NSMutableURLRequest(url: URL(string: sURL)!)
                urlRequest.timeoutInterval = 90.0
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = json.data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
                    DispatchQueue.main.async {
                        self.anLoading()
                    }
                    guard error == nil else {
                        debugPrint("\(self.TAG) - \(#function) - line : \(#line) - error : \(error.debugDescription)")
                        DispatchQueue.main.async {
                            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                        }
                        return
                    }
                    guard let responseData = data else {
                        debugPrint("\(self.TAG) - \(#function) - line : \(#line) - data == nil")
                        DispatchQueue.main.async {
                            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                        }
                        return
                    }
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    debugPrint("\(self.TAG) - \(#function) - line : \(#line) - statusCode : \(statusCode)")
                    if statusCode == 200 {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - json : \(json)")
                                var key = "msgContent"
                                if Localization.getCurrentLang() == ENGLISH {
                                    key = "msgContent_en"
                                }
                                if let sThongBao = json[key] as? String {
                                    DispatchQueue.main.async {
                                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: sThongBao)
                                    }
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
        }
    }
    
    @objc func suKienThayDoiGia(_ tfGia:ExTextField) {
        if let sSoTien = tfGia.text {
            let sSoTienTemp = sSoTien.replacingOccurrences(of: ".", with: "")
            if dictSanPham == nil {
                dictSanPham = [String : Any]()
            }
            let dSoTien = Double(sSoTienTemp) ?? 0
            dictSanPham?["soTienGiaoDich"] = NSNumber(value: dSoTien)
            tfGia.text = Common.hienThiTienTe(dSoTien)
        }
    }
    
    @objc func suKienThayDoiNoiDung(_ tfNoiDung:ExTextField) {
        sNoiDung = tfNoiDung.text ?? ""
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

extension GiaoDienThanhToanQRSanPham : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3 + (isExistsImage ? 1 : 0)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictSanPham != nil ? 8 : 0
//        if section == 0 {
//            if dictSanPham != nil {
//                if isExistsDC {
//                    return 7
//                }
//                return 6
//            }
//        } else if section == 1 {
//            return 1
//        } else if section == 2 {
//            return 0
//        }
//        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            return isShowTokenView ? 120 : 100
        }
        return 50
//        if indexPath.section == 0 {
//            if (!isExistsDC && indexPath.row == 4) || indexPath.row == 5 {
//                return 60
//            }
//            return UITableView.automaticDimension
//        } else if indexPath.section == 1 {
//            return isShowTokenView ? 120 : 100
//        } else if indexPath.section == 2 {
//            return UITableView.automaticDimension
//        }
//        return 450
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? QRSanPhamDiaChiCell {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Đơn vị:"
                cell.lblDiaChi.text = dictSanPham?["tenDVCNTT"] as? String
            case 1:
                cell.lblTitle.text = "ĐC:"
                cell.lblDiaChi.text = dictSanPham?["thanhPho"] as? String
            case 2:
                if let dictChiTiet = dictSanPham?["chiTiet"] as? [String : Any] {
                    cell.lblDiaChi.text = dictChiTiet["tenDiemThu"] as? String
                }
                cell.lblTitle.text = "Điểm thu:"
            case 3:
                if let dictChiTiet = dictSanPham?["chiTiet"] as? [String : Any] {
                    cell.lblDiaChi.text = dictChiTiet["soHoaDon"] as? String
                }
                cell.lblTitle.text = "Số HĐ:"
            case 4:
                if let dictChiTiet = dictSanPham?["chiTiet"] as? [String : Any] {
                    cell.lblDiaChi.text = dictChiTiet["maDiemThu"] as? String
                }
                cell.lblTitle.text = "NDTT:"
            default:
                cell.lblTitle.text = ""
            }
            
        } else if let cell = cell as? DonGiaQRCell {
            if let dict = dictSanPham, let numberGia = dict["soTienGiaoDich"] as? NSNumber {
                let dGia = numberGia.doubleValue
                if dGia > 0 {
                    cell.lblTitle.text = ""
                    cell.tfGia.text = Common.hienThiTienTe(dGia) ?? ""
                } else {
                    cell.lblTitle.text = ""
                    cell.tfGia.text = "0"
                }
            }
            cell.tfGia.addTarget(self, action: #selector(suKienThayDoiGia(_:)), for: .editingChanged)
            cell.lblPhi.text = ""
        } else if let cell = cell as? TaoQRNameCell {
            cell.tfName.placeholder = "Nội dung (Có thể bỏ qua)"
            cell.tfName.addTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
            cell.delegate = self
            cell.viewToken.isHidden = !isShowTokenView
            if self.enableFaceID {
                cell.btnAuthen.setImage(UIImage(named: "face-id"), for: .normal)
            } else {
                cell.btnAuthen.setImage(UIImage(named: "finger"), for: .normal)
            }
            cell.btnToken.addTarget(self, action: #selector(suKienChonTokenView), for: .touchUpInside)
            cell.btnAuthen.addTarget(self, action: #selector(suKienBamNutMatKhauVanTay(_:)), for: .touchUpInside)
            cell.btnPKI.addTarget(self, action: #selector(suKienBamNutPKI(_:)), for: .touchUpInside)
            cell.btnPKI.isHidden = true
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonGiaQRCell", for: indexPath) as! DonGiaQRCell
            return cell
        } else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamDiaChiCell", for: indexPath) as! QRSanPhamDiaChiCell
            return cell
        }
//        if indexPath.section == 0 {
//            if indexPath.row == 3 {
//                if isExistsDC {
//                    let diaChi1 = (dictSanPham?["diaChi1"] as? String) ?? ""
//                    let diaChi2 = (dictSanPham?["diaChi2"] as? String) ?? ""
//                    if !diaChi1.isEmpty || !diaChi2.isEmpty {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamDiaChiCell", for: indexPath) as! QRSanPhamDiaChiCell
//                        cell.lblTitle.text = "ĐC:"
//                        cell.lblDiaChi.text = diaChi1
//                        if let text = cell.lblDiaChi.text, !text.isEmpty {
//                            cell.lblDiaChi.text = "\(text), \(diaChi2)"
//                        } else {
//                            cell.lblDiaChi.text = diaChi2
//                        }
//                        return cell
//                    }
//                }
//                let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamTenSPDVCell", for: indexPath) as! QRSanPhamTenSPDVCell
//                cell.lblContent.text = dictSanPham?["maSoThanhToan"] as? String
//                return cell
//            } else {
//                if indexPath.row == 2 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamDiaChiCell", for: indexPath) as! QRSanPhamDiaChiCell
//                    cell.lblTitle.text = "SP/DV:"
//                    cell.lblDiaChi.text = dictSanPham?["ten"] as? String
//                    return cell
//                }
//                else if indexPath.row == 4 {
//                    if isExistsDC {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamTenSPDVCell", for: indexPath) as! QRSanPhamTenSPDVCell
//                        cell.lblContent.text = dictSanPham?["maSoThanhToan"] as? String
//                        return cell
//                    } else {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamInfoCell", for: indexPath) as! QRSanPhamInfoCell
//                        if let dict = dictSanPham, let numberGia = dict["gia"] as? NSNumber {
//                            let dGia = numberGia.doubleValue
//                            cell.lblTitle.text = Common.hienThiTienTe(dGia)
//                        }
//                        cell.lblInfo.text = "Phí: 3.300 đ"
//                        return cell
//                    }
//                }
//                else if indexPath.row == 5 {
//                    if isExistsDC {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "DonGiaQRCell", for: indexPath) as! DonGiaQRCell
//                        if let dict = dictSanPham, let numberGia = dict["gia"] as? NSNumber {
//                            let dGia = numberGia.doubleValue
//                            if dGia > 0 {
////                                cell.lblTitle.text = "Đơn giá"
//                                cell.lblTitle.text = ""
//                                cell.tfGia.text = Common.hienThiTienTe(dGia) ?? ""
//                                cell.lblPhi.text = "Phí: 3.300 đ"
//                            } else {
//                                cell.lblTitle.text = ""
//                                cell.tfGia.text = ""
//                                cell.lblPhi.text = "Phí: 3.300 đ"
//                            }
//                        }
//                        cell.tfGia.addTarget(self, action: #selector(suKienThayDoiGia(_:)), for: .editingChanged)
//                        return cell
//                    } else {
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
//                        cell.tfName.placeholder = "Nội dung (Có thể bỏ qua)"
//                        if let dict = dictSanPham {
//                            cell.tfName.text = dict["noiDung"] as? String
//                        }
//                        cell.tfName.addTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
//                        return cell
//                    }
//                }
//                else if indexPath.row == 6 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
//                    cell.tfName.placeholder = "Nội dung (Có thể bỏ qua)"
//                    if let dict = dictSanPham {
//                        cell.tfName.text = dict["noiDung"] as? String
//                    }
//                    cell.tfName.addTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
//                    return cell
//                }
//                else {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamInfoCell", for: indexPath) as! QRSanPhamInfoCell
//                    cell.lblInfo.text = ""
//                    cell.lblTitle.text = ""
//                    if indexPath.row == 0 {
//                        cell.lblTitle.text = "Trả cho:"
//                        if let dict = dictSanPham {
////                            let dictThongTin = dict["objectThongTinDonViThanhToan"] as! [String:Any]
//                            cell.lblInfo.text = dict["tenChuTaiKhoan"] as? String
//                        }
//
//                    } else if indexPath.row == 1 {
//                        cell.lblTitle.text = "TK:"
//                        if let dict = dictSanPham {
//                            var sTK = (dict["maNganHang"] as? String) ?? ""
//                            if let soTaiKhoan = dict["soTaiKhoan"] as? String {
//                                if soTaiKhoan.count > 5 {
//                                    let index1 = soTaiKhoan.index(soTaiKhoan.startIndex, offsetBy: 3)
//                                    let index2 = soTaiKhoan.index(soTaiKhoan.endIndex, offsetBy: -2)
//                                    var temp = ""
//                                    for _ in 3..<(soTaiKhoan.count - 2) {
//                                        temp.append(contentsOf: "*")
//                                    }
//                                    temp = "\(soTaiKhoan[..<index1])\(temp)\(soTaiKhoan[index2...])"
//                                    sTK = "\(sTK) - \(temp)"
//                                } else {
//                                    sTK = "\(sTK) - \(soTaiKhoan)"
//                                }
//                            }
//                            cell.lblInfo.text = sTK
//                        }
//                    }
//                    return cell
//                }
//            }
//        }
//        else if indexPath.section == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
//            cell.delegate = self
//            cell.viewToken.isHidden = !isShowTokenView
//            if self.enableFaceID {
//                cell.btnAuthen.setImage(UIImage(named: "face-id"), for: .normal)
//            } else {
//                cell.btnAuthen.setImage(UIImage(named: "finger"), for: .normal)
//            }
//            cell.btnToken.addTarget(self, action: #selector(suKienChonTokenView), for: .touchUpInside)
//            cell.btnAuthen.addTarget(self, action: #selector(suKienBamNutMatKhauVanTay(_:)), for: .touchUpInside)
//            cell.btnPKI.addTarget(self, action: #selector(suKienBamNutPKI(_:)), for: .touchUpInside)
//            cell.btnPKI.isHidden = true
//            return cell
//        } else if indexPath.section == 2{
//            if let qrYTe = dictSanPham?["qrYTe"] as? Int, qrYTe == 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamDanhSachThanhToanCell", for: indexPath) as! QRSanPhamDanhSachThanhToanCell
//                var sTemp = ""
//                if let dsThongTinNguoiDatHang = dictSanPham?["dsThongTinNguoiDatHang"] as? String {
//                    NSLog("\(TAG) - \(#function) - line : \(#line) - dsThongTinNguoiDatHang : \(dsThongTinNguoiDatHang)")
//                    let arrTemp = dsThongTinNguoiDatHang.components(separatedBy: ",")
//                    NSLog("\(TAG) - \(#function) - line : \(#line) - arrTemp : \(arrTemp.count)")
//                    for item in arrTemp {
//                        NSLog("\(TAG) - \(#function) - line : \(#line) - item : \(item)")
//                        let arrSDT = item.components(separatedBy: "#")
//                        if arrSDT.count >= 2 {
//                            var sSDT = arrSDT.first ?? ""
//                            if !sSDT.isEmpty && sSDT.count > 5 {
//                                let index1 = sSDT.index(sSDT.startIndex, offsetBy: 3)
//                                let index2 = sSDT.index(sSDT.endIndex, offsetBy: -2)
//                                var temp = ""
//                                for _ in 3..<(sSDT.count - 2) {
//                                    temp.append(contentsOf: "*")
//                                }
//                                sSDT = "\(sSDT[..<index1])\(temp)\(sSDT[index2...])"
//                            }
//                            if sTemp.isEmpty {
//                                sTemp = sSDT
//                            } else {
//                                sTemp.append(contentsOf: "\n\(sSDT)")
//                            }
//                        }
//                    }
//                }
//                NSLog("\(TAG) - \(#function) - line : \(#line) - sTemp : \(sTemp)")
//                cell.lblSDT.text = sTemp
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamDiaChiCell", for: indexPath) as! QRSanPhamDiaChiCell
//                cell.lblTitle.text = "Mô tả sản phẩm"
//                cell.lblDiaChi.text = dictSanPham?["noiDung"] as? String
//                return cell
//            }
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowImageSanPhamCell", for: indexPath) as! ShowImageSanPhamCell
//            cell.selectionStyle = .none
//            if var image = dictSanPham?["image"] as? String {
//                image = image.replacingOccurrences(of: "[", with: "")
//                image = image.replacingOccurrences(of: "]", with: "")
//                let arrImage = image.components(separatedBy: ";")
//                cell.arrImage.removeAll()
//                cell.arrImage.append(contentsOf: arrImage)
//                cell.showImage()
//            }
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let _ = tableView.cellForRow(at: indexPath) as? QRSanPhamTenSPDVCell, let linkQR = dictSanPham?["linkQR"] as? String {
//            let showQR = ShowQRSanPhamView.instanceFromNib()
//            showQR.frame = self.view.bounds
//            showQR.imgvPreview.sd_setImage(with: URL(string: linkQR))
//            self.view.addSubview(showQR)
//        }
    }
    
    @objc func suKienChonTokenView() {
        isShowTokenView = !isShowTokenView
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 7, section: 0)], with: .automatic)
        }
    }
}

extension GiaoDienThanhToanQRSanPham : AuthenQRCellDelegate {
    func suKienChonThucHienAuth(_ sToken: String) {
        if sToken.count == 6 && validateVanTay() {
            self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN
            self.sToken = self.xuLyKhiBamThucHienToken(sToken)
            self.sOTP = ""
            DispatchQueue.main.async {
                self.hienThiLoadingChuyenTien()
            }
            thanhToanQRSanPham()
        }
    }
}
