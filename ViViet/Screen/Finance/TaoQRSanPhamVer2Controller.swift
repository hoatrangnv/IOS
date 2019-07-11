//
//  TaoQRSanPhamVer2Controller.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/8/19.
//

import UIKit

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}

@objc class TaoQRSanPhamVer2Controller: GiaoDichViewController, UINavigationControllerDelegate {
    private let TAG = "TaoQRSanPhamVer2Controller"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var heightViewTop: NSLayoutConstraint!
    var showThemAnh = false
    var arrImage = [UIImage]()
    var arrPhone = [(String, String)]()
    var arrImageLink = [String]()
    var maGiaoDich = ""
    var dictGiaoDich:[String:Any]!
    var nLoiNhan = 1
    var nSoLuong = 1
    var sOTP = ""
    var sToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "TaoQRNameCell", bundle: nil), forCellReuseIdentifier: "TaoQRNameCell")
        self.tableView.register(UINib(nibName: "DonGiaQRCell", bundle: nil), forCellReuseIdentifier: "DonGiaQRCell")
        self.tableView.register(UINib(nibName: "TaoQROptionCell", bundle: nil), forCellReuseIdentifier: "TaoQROptionCell")
        self.tableView.register(UINib(nibName: "ThemAnhSanPhamQRCell", bundle: nil), forCellReuseIdentifier: "ThemAnhSanPhamQRCell")
        self.tableView.register(UINib(nibName: "AuthenQRCell", bundle: nil), forCellReuseIdentifier: "AuthenQRCell")
        
        let sTemp = DucNT_LuuRMS.layThongTinTrongRMSTheoKey("VIMASS_MA_GIAO_DICH") as? String ?? ""
        debugPrint("\(TAG) - \(#function) - line : \(#line) - sTemp : \(sTemp)")
        maGiaoDich = sTemp
        if maGiaoDich.isEmpty {
            self.navigationItem.title = "Thêm sản phẩm QR"
            heightViewTop.constant = 0
        } else {
            self.navigationItem.title = "Sửa thông tin sản phẩm"
            heightViewTop.constant = 44
            ketNoiLayThongTinSanPham()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func ketNoiLayThongTinSanPham() {
        self.hienThiLoading()
        self.mDinhDanhKetNoi = "KET_NOI_LAY_SAN_PHAM_QR"
        GiaoDichMang.layThongTinSanPhamQRCode(maGiaoDich, noiNhanKetQua: self)
    }

    override func xuLyKetNoiThanhCong(_ sDinhDanhKetNoi: String!, thongBao sThongBao: String!, ketQua: Any!) {
        debugPrint("\(TAG) - \(#function) - line : \(#line) - sDinhDanhKetNoi : \(String(describing: sDinhDanhKetNoi))")
        if sDinhDanhKetNoi == "KET_NOI_LAY_SAN_PHAM_QR" {
            self.anLoading()
            if let dict = ketQua as? [String:Any] {
//                debugPrint("\(TAG) - \(#function) - line : \(#line) - dict : \(dict["image"])")
                dictGiaoDich = dict
                if let sImage = dictGiaoDich["image"] as? String {
                    let arrImageTemp = sImage.components(separatedBy: ";")
                    for imgURL in arrImageTemp {
                        if let url = URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(imgURL)") {
                            downloadImage(from: url)
                        }
                    }
                    self.arrImageLink.append(contentsOf: arrImageTemp)
                }
                if let sPhone = dictGiaoDich["dsTKNhanThongBaoBienDongSoDu"] as? String {
                    let arrPhoneTemp = sPhone.components(separatedBy: ",")
                    for item in arrPhoneTemp {
                        let arrItem = item.components(separatedBy: "#")
                        if arrItem.count == 2 {
                            arrPhone.append((arrItem.first ?? "", arrItem.last ?? ""))
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if sDinhDanhKetNoi == "UP_ANH_QR_SAN_PHAM" {
            self.anLoading()
//            uploadQRSanPham()
        }
    }
    
    override func xuLyKetNoiThatBai(_ sDinhDanhKetNoi: String!, thongBao sThongBao: String!, ketQua: Any!) {
        if sDinhDanhKetNoi == "UP_ANH_QR_SAN_PHAM" {
            DispatchQueue.main.async {
                self.anLoading()
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("\(self.TAG) - \(#function) - line : \(#line) - \(response?.suggestedFilename ?? url.lastPathComponent)")
//            print("Download Finished")
            if let img = UIImage(data: data) {
                self.arrImage.append(img)
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            }
        }
    }
    
    func layAnhSanPham() {
        CropImageHelper.crop_image_(from: .photoLibrary, ratio: 1, max_width: 320, maxsize: 320*600, viewcontroller: self) { (img, data) in
            if let _img = img {
                self.arrImage.append(_img)
            }
            self.dismiss(animated: true) {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
    func hienThiLayDanhBa() {
        let vc = ContactScreen(nibName: "ContactScreen", bundle: nil)
        vc.mKieuHienThiLienHe = Int(KIEU_HIEN_THI_LIEN_HE_THUONG)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.selectContact { (sdt, contact) in
            if let phone = sdt, !phone.isEmpty {
                if Common.kiemTraLaMail(phone) {
                    
                } else {
                    if !self.arrPhone.contains(where: { (phone2, contact2) -> Bool in
                        return phone == phone2
                    }) {
                        self.arrPhone.append((phone, contact?.fullName ?? ""))
                    }
                }
            }
            
            vc.navigationController?.popViewController(animated: true)
            self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
    
    override func validateVanTay() -> Bool {
        return true
    }
    
    @objc func suKienChangeTen(_ tfGia:ExTextField) {
        if dictGiaoDich == nil {
            dictGiaoDich = [String : Any]()
        }
        dictGiaoDich["ten"] = tfGia.text ?? ""
    }
    
    @objc func suKienChangeSoTien(_ tfGia:ExTextField) {
        if let sSoTien = tfGia.text {
            let sSoTienTemp = sSoTien.replacingOccurrences(of: ".", with: "")
            if dictGiaoDich == nil {
                dictGiaoDich = [String : Any]()
            }
            let dSoTien = Double(sSoTienTemp) ?? 0
            dictGiaoDich["gia"] = NSNumber(value: dSoTien)
        }
    }

    func uploadQRSanPham() {
        if arrImage.count > 0 {
            if let img = arrImage.last {
                if let sBase64 = self.convertImageToBase64(img) {
                    uploadAnh(sBase64)
                }
                arrImage.removeLast()
                debugPrint("\(TAG) - \(#function) - line : \(#line) - arrImage.count : \(arrImage.count)")
            }
        } else {
            if maGiaoDich.isEmpty {
                uploadNewQR()
            } else {
                editQR()
            }
        }
    }
    
    func uploadNewQR() {
        if dictGiaoDich == nil {
            dictGiaoDich = [String : Any]()
        }
        dictGiaoDich["maDaiLy"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)
        dictGiaoDich["video"] = ""
        dictGiaoDich["hienThiLoiNhan"] = NSNumber(value: 1)
        dictGiaoDich["hienThiSoLuong"] = NSNumber(value: nSoLuong)
        dictGiaoDich["tkNhanTien"] = "V"
        dictGiaoDich["kieuNhanThanhToan"] = "V"
        dictGiaoDich["hienThiThongTinNguoiNhan"] = NSNumber(value: nLoiNhan)
        dictGiaoDich["otpCheck"] = self.sOTP
        dictGiaoDich["token"] = self.sToken
        dictGiaoDich["hienThiChiTietThongTinNguoiNhan"] = ""
        dictGiaoDich["dsThongTinNguoiDatHang"] = ""
        dictGiaoDich["VMApp"] = NSNumber(value: 2)
        dictGiaoDich["diaChi1"] = ""
        dictGiaoDich["diaChi2"] = ""
        var sPhone = ""
        for item in arrPhone {
            sPhone.append("\(item.0)#\(item.1),")
        }
        if sPhone.hasSuffix(",") {
            sPhone.removeLast()
        }
        dictGiaoDich["dsTKNhanThongBaoBienDongSoDu"] = sPhone
        
        let sURL = "\(ROOT_URL)paymentGateway/themSanPham"
        connectUpQR(sURL, dict: dictGiaoDich)
    }
    
    func editQR() {
//        if dictGiaoDich == nil {
//            dictGiaoDich = [String : Any]()
//        }
//        dictGiaoDich["maGiaoDich"] = maGiaoDich
//        dictGiaoDich["maDaiLy"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)
//        dictGiaoDich["video"] = ""
//        dictGiaoDich["hienThiLoiNhan"] = NSNumber(value: 1)
//        dictGiaoDich["hienThiSoLuong"] = NSNumber(value: nSoLuong)
//        dictGiaoDich["tkNhanTien"] = "V"
//        dictGiaoDich["kieuNhanThanhToan"] = "V"
//        dictGiaoDich["hienThiThongTinNguoiNhan"] = NSNumber(value: nLoiNhan)
//        dictGiaoDich["otpCheck"] = self.sOTP
//        dictGiaoDich["token"] = self.sToken
//        dictGiaoDich["hienThiChiTietThongTinNguoiNhan"] = ""
//        dictGiaoDich["dsThongTinNguoiDatHang"] = ""
//        dictGiaoDich["VMApp"] = NSNumber(value: 2)
//        dictGiaoDich["diaChi1"] = ""
//        dictGiaoDich["diaChi2"] = ""
//        var sPhone = ""
//        for item in arrPhone {
//            sPhone.append("\(item.0)#\(item.1),")
//        }
//        if sPhone.hasSuffix(",") {
//            sPhone.removeLast()
//        }
//        dictGiaoDich["dsTKNhanThongBaoBienDongSoDu"] = sPhone
        
        var dict = [String:Any]()
        dict["maGiaoDich"] = maGiaoDich
        dict["maDaiLy"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)
        dict["video"] = ""
        dict["hienThiLoiNhan"] = NSNumber(value: 1)
        dict["hienThiSoLuong"] = NSNumber(value: nSoLuong)
        dict["tkNhanTien"] = "V"
        dict["kieuNhanThanhToan"] = "V"
        dict["hienThiThongTinNguoiNhan"] = NSNumber(value: nLoiNhan)
        dict["otpCheck"] = self.sOTP
        dict["token"] = self.sToken
        dict["hienThiChiTietThongTinNguoiNhan"] = ""
        dict["dsThongTinNguoiDatHang"] = ""
        dict["VMApp"] = NSNumber(value: 2)
        dict["diaChi1"] = ""
        dict["diaChi2"] = ""
        dict["image"] = dictGiaoDich["image"]
        dict["ten"] = dictGiaoDich["ten"]
        dict["gia"] = dictGiaoDich["gia"]
        dict["noiDung"] = dictGiaoDich["noiDung"]
        dict["thongBaoSauKhiNhanTien"] = dictGiaoDich["thongBaoSauKhiNhanTien"]
        var sPhone = ""
        for item in arrPhone {
            sPhone.append("\(item.0)#\(item.1),")
        }
        if sPhone.hasSuffix(",") {
            sPhone.removeLast()
        }
        dict["dsTKNhanThongBaoBienDongSoDu"] = sPhone
        
        let sURL = "\(ROOT_URL)paymentGateway/editSanPham"
        connectUpQR(sURL, dict: dict)
    }
    
    func connectUpQR(_ sURL:String, dict:[String:Any]) {
        debugPrint("\(TAG) - \(#function) - line : \(#line) - sURL : \(sURL)")
        if let json = dict.jsonStringRepresentation {
            debugPrint("\(TAG) - \(#function) - line : \(#line) - json : \(json)")
            
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
    
    func convertImageToBase64(_ img:UIImage) -> String?{
        if let imgData = img.jpegData(compressionQuality: 0.6) {
            return Base64.encode(imgData)
        }
        return nil
    }
    
    func uploadAnh(_ sImage:String) {
        let sURL = "https://vimass.vn/vmbank/services/media/upload/\(DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)!)"
        let urlRequest = NSMutableURLRequest(url: URL(string: sURL)!)
        urlRequest.timeoutInterval = 90.0
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = sImage.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard error == nil else {
                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - error : \(error.debugDescription)")
                DispatchQueue.main.async {
                    self.anLoading()
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
                return
            }
            guard let responseData = data else {
                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - data == nil")
                DispatchQueue.main.async {
                    self.anLoading()
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
                        if let imgLink = json["result"] as? String {
                            var sImageDict = (self.dictGiaoDich["image"] as? String) ?? ""
                            sImageDict.append(contentsOf: ";\(imgLink)")
                            if sImageDict.hasPrefix(";") {
                                sImageDict.removeFirst()
                            }
                            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - sImageDict : \(sImageDict)")
                            self.dictGiaoDich["image"] = sImageDict
                            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - self.dictGiaoDich : \(self.dictGiaoDich["image"])")
                        }
                        self.uploadQRSanPham()
                    }
                } catch{}
            }
        }
        task.resume()
    }
    
    override func xuLyThucHienKhiKiemTraThanhCongTraVeToken(_ sToken: String!, otp sOtp: String!) {
        DispatchQueue.main.async {
            self.hienThiLoadingChuyenTien()
        }
        self.sToken = sToken
        self.sOTP = sOtp
        dictGiaoDich["image"] = ""
        uploadQRSanPham()
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

extension TaoQRSanPhamVer2Controller : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return arrImage.count > 0 ? 1 : 0
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return arrPhone.count
        } else if section == 4 {
            return 2
        } else if section == 5 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 250
        } else if indexPath.section == 5 {
            return 100
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 3 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 3 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            header.backgroundColor = UIColor.white
            let headerMain = UIView()
            headerMain.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(headerMain)
            headerMain.backgroundColor = UIColor(red: 67.0/255.0, green: 156.0/255.0, blue: 61.0/255.0, alpha: 1)
            headerMain.topAnchor.constraint(equalTo: header.topAnchor, constant: 0).isActive = true
            headerMain.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
            headerMain.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8).isActive = true
            headerMain.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8).isActive = true
            
            let lblTitle = UILabel()
            lblTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            lblTitle.textColor = UIColor.white
            if section == 1 {
                lblTitle.text = "Thêm ảnh sản phẩm"
            } else {
                lblTitle.text = "Điện thoại nhận tin báo có"
            }
            lblTitle.translatesAutoresizingMaskIntoConstraints = false
            headerMain.addSubview(lblTitle)
            lblTitle.centerXAnchor.constraint(equalTo: headerMain.centerXAnchor, constant: 0).isActive = true
            lblTitle.centerYAnchor.constraint(equalTo: headerMain.centerYAnchor, constant: 0).isActive = true
            
            let imgvIcon = UIImageView(image: UIImage(named: "icon-themtk64x64.png"))
            imgvIcon.translatesAutoresizingMaskIntoConstraints = false
            headerMain.addSubview(imgvIcon)
            imgvIcon.leadingAnchor.constraint(equalTo: headerMain.leadingAnchor, constant: 8).isActive = true
            imgvIcon.centerYAnchor.constraint(equalTo: headerMain.centerYAnchor, constant: 0).isActive = true
            imgvIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
            imgvIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            header.tag = section
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(suKienChonHeaderSection(_:)))
            tap.numberOfTapsRequired = 1
            header.addGestureRecognizer(tap)
            
            return header
        }
        return nil
    }
    
    @objc func suKienChonHeaderSection(_ gesture:UITapGestureRecognizer) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let header = gesture.view {
                let tag = header.tag
                if tag == 1 && !self.showThemAnh{
                    self.layAnhSanPham()
                } else if tag == 3 {
                    self.hienThiLayDanhBa()
                }
            }

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
                cell.selectionStyle = .none
                cell.tfName.addTarget(self, action: #selector(suKienChangeTen(_:)), for: .editingChanged)
                if dictGiaoDich != nil {
                    cell.tfName.text = dictGiaoDich["ten"] as? String
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DonGiaQRCell", for: indexPath) as! DonGiaQRCell
                cell.selectionStyle = .none
                cell.tfGia.addTarget(self, action: #selector(suKienChangeSoTien(_:)), for: .editingChanged)
                if dictGiaoDich != nil {
                    if let numberGia = dictGiaoDich["gia"] as? NSNumber {
                        let dGia = numberGia.doubleValue
                        cell.tfGia.text = Common.hienThiTienTe(dGia)
                    }
                }
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemAnhSanPhamQRCell", for: indexPath) as! ThemAnhSanPhamQRCell
            cell.selectionStyle = .none
            cell.arrImage.removeAll()
            cell.arrImage.append(contentsOf: arrImage)
            cell.showAnhPreview()
            cell.delegate = self
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.tfName.placeholder = "Mô tả sản phẩm (không quá 2000 ký tự)"
                if dictGiaoDich != nil {
                    cell.tfName.text = dictGiaoDich["noiDung"] as? String
                }
            } else {
                cell.tfName.placeholder = "Thông tin nhận hàng"
                if dictGiaoDich != nil {
                    cell.tfName.text = dictGiaoDich["thongBaoSauKhiNhanTien"] as? String
                }
            }
            cell.tfName.addTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQROptionCell", for: indexPath) as! TaoQROptionCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.lblTitle.text = "Số lượng đặt mua"
                cell.switchOption.isOn = nSoLuong > 0 ? true : false
            } else {
                cell.lblTitle.text = "Hiện thông tin nhận hàng"
                cell.switchOption.isOn = nLoiNhan > 0 ? true : false
            }
            cell.switchOption.addTarget(self, action: #selector(suKienThayDoiSwitch(_:)), for: .valueChanged)
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
            cell.selectionStyle = .none
            if self.enableFaceID {
                cell.btnAuthen.setImage(UIImage(named: "face-id"), for: .normal)
            } else {
                cell.btnAuthen.setImage(UIImage(named: "finger"), for: .normal)
            }
            cell.btnAuthen.addTarget(self, action: #selector(suKienBamNutMatKhauVanTay(_:)), for: .touchUpInside)
            cell.btnPKI.addTarget(self, action: #selector(suKienBamNutPKI(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
            cell.selectionStyle = .none
            cell.btnDel.isHidden = false
            cell.btnDel.addTarget(self, action: #selector(suKienChonDelPhone(_:)), for: .touchUpInside)
            
            let phone = arrPhone[indexPath.row]
            cell.tfName.text = phone.0
            
            return cell
        }
    }
    
    @objc func suKienThayDoiNoiDung(_ sender:ExTextField) {
        if let cell = sender.superview?.superview as? TaoQRNameCell, let indexPath = tableView.indexPath(for: cell) {
            if dictGiaoDich == nil {
                dictGiaoDich = [String:Any]()
            }
            if indexPath.row == 0 {
                dictGiaoDich["noiDung"] = sender.text ?? ""
            } else {
                dictGiaoDich["thongBaoSauKhiNhanTien"] = sender.text ?? ""
            }
        }
    }
    
    @objc func suKienThayDoiSwitch(_ sender:UISwitch) {
        if let cell = sender.superview?.superview as? TaoQROptionCell, let indexPath = tableView.indexPath(for: cell) {
            if indexPath.row == 0 {
                nSoLuong = sender.isOn ? 1 : 0
            } else {
                nLoiNhan = sender.isOn ? 1 : 0
            }
        }
    }
    
    @objc func suKienChonDelPhone(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? TaoQRNameCell, let indexPath = tableView.indexPath(for: cell) {
            arrPhone.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
        }
    }
}

extension TaoQRSanPhamVer2Controller : ThemAnhSanPhamQRCellDelegate {
    func suKienDeleteImage(_ index: Int) {
        if index < arrImage.count {
            arrImage.remove(at: index)
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
}

extension TaoQRSanPhamVer2Controller : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CropImageHelper.crop_image_(from: .photoLibrary, ratio: 1, max_width: 320, maxsize: 320*600, viewcontroller: self) { (img, data) in
                if let _img = img {
                    self.arrImage.append(_img)
                }
                picker.dismiss(animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UIView.setAnimationsEnabled(false)
                        self.tableView.beginUpdates()
                        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                        self.tableView.endUpdates()
                    })
                }
            }
            
        }
        
    }
}

//extension TaoQRSanPhamVer2Controller : UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if dictGiaoDich == nil {
//            dictGiaoDich = [String:Any]()
//        }
//        if let cell = textField.superview?.superview as? TaoQRNameCell, let indexPath = tableView.indexPath(for: cell) {
//            if indexPath.section == 0 {
//                if indexPath.row == 0 {
//                    dictGiaoDich["ten"] = textField.text ?? ""
//                } else {
//                    dictGiaoDich["ten"] = textField.text ?? ""
//                }
//            }
//        }
//    }
//}
