//
//  TaoQRYTeViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/28/19.
//

import UIKit

class TaoQRYTeViewController: GiaoDichViewController {
    private let TAG = "TaoQRYTeViewController"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var heightTopMenu: NSLayoutConstraint!
    
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
    var isDelete = false
    var isShowTokenView = false
    var isNgayGio = false
    var sGio = ""
    var sNgay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.title = "Thêm QR Y tế"
        self.addTitleView("Thêm QR Y tế")
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.register(UINib(nibName: "TaoQRNameCell", bundle: nil), forCellReuseIdentifier: "TaoQRNameCell")
        self.tableView.register(UINib(nibName: "DonGiaQRCell", bundle: nil), forCellReuseIdentifier: "DonGiaQRCell")
        self.tableView.register(UINib(nibName: "TaoQROptionCell", bundle: nil), forCellReuseIdentifier: "TaoQROptionCell")
        self.tableView.register(UINib(nibName: "ThemAnhSanPhamQRCell", bundle: nil), forCellReuseIdentifier: "ThemAnhSanPhamQRCell")
        self.tableView.register(UINib(nibName: "AuthenQRCell", bundle: nil), forCellReuseIdentifier: "AuthenQRCell")
        self.tableView.register(UINib(nibName: "QRSanPhamPhoneCell", bundle: nil), forCellReuseIdentifier: "QRSanPhamPhoneCell")
        self.tableView.register(UINib(nibName: "AddNgayGioCell", bundle: nil), forCellReuseIdentifier: "AddNgayGioCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dictGiaoDich = [String : Any]()
        if maGiaoDich.isEmpty {
            heightTopMenu.constant = 0
        } else {
            heightTopMenu.constant = 44
            layThongTinSanPham()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        //        DispatchQueue.main.async {
        //            UIView.setAnimationsEnabled(false)
        //            self.tableView.beginUpdates()
        //            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        //            self.tableView.endUpdates()
        //        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    func layThongTinSanPham() {
//        let sURL = "https://vimass.vn/vmbank/services/paymentGateway/layChiTietThongTinSanPhamDaiLy?maSo=\(maGiaoDich)"
        DispatchQueue.main.async {
            self.hienThiLoading()
        }
        self.mDinhDanhKetNoi = "KET_NOI_LAY_SAN_PHAM_QR"
        GiaoDichMang.layThongTinSanPhamQRCode(maGiaoDich, noiNhanKetQua: self)
    }
    
    override func xuLyKetNoiThanhCong(_ sDinhDanhKetNoi: String!, thongBao sThongBao: String!, ketQua: Any!) {
        if sDinhDanhKetNoi == "KET_NOI_LAY_SAN_PHAM_QR" {
            if let dict = ketQua as? [String:Any] {
                dictGiaoDich = dict
                debugPrint("\(TAG) - \(#function) - line : \(#line) - ketQua : \(dictGiaoDich.description)")
                if var sImage = dictGiaoDich["image"] as? String {
                    sImage = sImage.replacingOccurrences(of: "[", with: "")
                    sImage = sImage.replacingOccurrences(of: "]", with: "")
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
                
                if let exDate = dictGiaoDich["exDate"] as? NSNumber {
                    let dExDate = exDate.doubleValue
                    if dExDate > 0 {
                        let dateEx = Date(timeIntervalSince1970: dExDate)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        sGio = formatter.string(from: dateEx)
                        formatter.dateFormat = "dd/MM/yyyy"
                        sNgay = formatter.string(from: dateEx)
                    }
                    
                }
                
                if let maNganHang = dictGiaoDich["maNganHang"] as? String {
                    if let path = Bundle.main.path(forResource: "getBanks", ofType: "txt") {
                        do {
                            let sContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                            if let jsonData = sContent.data(using: .utf8) {
                                if let arrJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String:Any]] {
                                    for item in arrJson {
                                        let sms = (item["SMS"] as? String) ?? ""
                                        if sms == maNganHang {
                                            dictGiaoDich["tenNganHang"] = item["NAME_VI"] as? String
                                            break
                                        }
                                    }
                                }
                            }
                        } catch {}
                    }
                }
                
                DispatchQueue.main.async {
                    self.anLoading()
                    self.tableView.reloadData()
                }
            }
        } else if sDinhDanhKetNoi == "UP_ANH_QR_SAN_PHAM" {
            self.anLoading()
            //            uploadQRSanPham()
        } else if sDinhDanhKetNoi == "XOA_SAN_PHAM" {
            self.anLoading()
            self.navigationController?.dismiss(animated: true, completion: nil)
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
            if let img = UIImage(data: data) {
                self.arrImage.append(img)
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
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
                self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
        }
    }
    
    func hienThiLayDanhBa() {
        let vc = ContactScreen(nibName: "ContactScreen", bundle: nil)
        vc.mKieuHienThiLienHe = Int(KIEU_HIEN_THI_LIEN_HE_THUONG)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.selectContact { (sdt, contact) in
            if !sdt.isEmpty {
                if Common.kiemTraLaMail(sdt) {
                    
                } else {
                    if !self.arrPhone.contains(where: { (phone2, contact2) -> Bool in
                        return sdt == phone2
                    }) {
                        self.arrPhone.append((sdt, contact.fullName ?? ""))
                    }
                }
            }
            
            vc.navigationController?.popViewController(animated: true)
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
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
                        let msgCode = json["msgCode"] as! NSNumber
                        if msgCode.intValue == 1 {
                            if let imgLink = json["result"] as? String {
                                var sImageDict = (self.dictGiaoDich["image"] as? String) ?? ""
                                sImageDict = sImageDict.replacingOccurrences(of: "[", with: "")
                                sImageDict = sImageDict.replacingOccurrences(of: "]", with: "")
                                sImageDict.append(contentsOf: ";\(imgLink)")
                                if sImageDict.hasPrefix(";") {
                                    sImageDict.removeFirst()
                                }
                                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - sImageDict : \(sImageDict)")
                                self.dictGiaoDich["image"] = "[\(sImageDict)]"
                                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - self.dictGiaoDich : \(self.dictGiaoDich["image"])")
                            }
                            self.uploadQRSanPham()
                        }
                    }
                } catch{}
            }
        }
        task.resume()
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
        dictGiaoDich["user"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)
        dictGiaoDich["maDaiLy"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_MA_DAI_LY)
        dictGiaoDich["video"] = ""
        dictGiaoDich["hienThiLoiNhan"] = NSNumber(value: 1)
        dictGiaoDich["hienThiSoLuong"] = NSNumber(value: nSoLuong)
        dictGiaoDich["tkNhanTien"] = "V"
        dictGiaoDich["kieuNhanThanhToan"] = "V"
        dictGiaoDich["hienThiThongTinNguoiNhan"] = NSNumber(value: nLoiNhan)
        dictGiaoDich["otpCheck"] = self.sOTP
        dictGiaoDich["token"] = self.sToken
        dictGiaoDich["hienThiChiTietThongTinNguoiNhan"] = "name;cmnd;sdt;email;makh;diachi"
        dictGiaoDich["dsThongTinNguoiDatHang"] = "namend;cmndnd;sdtnd;emailnd;diachind"
        dictGiaoDich["VMApp"] = NSNumber(value: 2)
        dictGiaoDich["qrYTe"] = 1
        dictGiaoDich["chiNhanh"] = ""
        dictGiaoDich["soTheNhanThanhToan"] = ""
        dictGiaoDich["idViVimassNhanThanhToan"] = ""
        
        var sThongTin = dictGiaoDich["thongBaoSauKhiNhanTien"] as? String
        if sThongTin == nil {
            sThongTin = ""
        }
        dictGiaoDich["thongBaoSauKhiNhanTien"] = sThongTin
        var sPhone = ""
        for item in arrPhone {
            sPhone.append("\(item.0)#\(item.1),")
        }
        if sPhone.hasSuffix(",") {
            sPhone.removeLast()
        }
        dictGiaoDich["dsTKNhanThongBaoBienDongSoDu"] = sPhone
        let sTime = "\(sGio) \(sNgay)"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        if let dateEx = formatter.date(from: sTime) {
            let time = dateEx.timeIntervalSince1970
            dictGiaoDich["exDate"] = time
        }
        if let json = dictGiaoDich.jsonStringRepresentation {
            debugPrint("\(TAG) - \(#function) - line : \(#line) - json : \(json)")
        }
        
//        let sURL = "\(ROOT_URL)paymentGateway/themSanPham"
        let sURL = "\(ROOT_URL)boYTe_SanPhamYTe/themSanPham"
        connectUpQR(sURL, dict: dictGiaoDich)
    }
    
    func editQR() {
        var dict = [String:Any]()
        dict["user"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)
        dict["maGiaoDich"] = maGiaoDich
        dict["maDaiLy"] = dictGiaoDich["maDaiLy"]
        dict["video"] = ""
        dict["hienThiLoiNhan"] = NSNumber(value: 1)
        dict["hienThiSoLuong"] = NSNumber(value: nSoLuong)
        dict["tkNhanTien"] = "V"
        dict["kieuNhanThanhToan"] = "V"
        dict["hienThiThongTinNguoiNhan"] = NSNumber(value: nLoiNhan)
        dict["otpCheck"] = self.sOTP
        dict["token"] = self.sToken
        dict["hienThiChiTietThongTinNguoiNhan"] = "name;cmnd;sdt;email;makh;diachi"
        dict["dsThongTinNguoiDatHang"] = "namend;cmndnd;sdtnd;emailnd;diachind"
        dict["VMApp"] = NSNumber(value: 2)
        dict["diaChi1"] = dictGiaoDich["diaChi1"]
        dict["diaChi2"] = dictGiaoDich["diaChi2"]
        dict["image"] = dictGiaoDich["image"]
        dict["ten"] = dictGiaoDich["ten"]
        dict["gia"] = dictGiaoDich["gia"]
        dict["noiDung"] = dictGiaoDich["noiDung"]
        dict["thongBaoSauKhiNhanTien"] = dictGiaoDich["thongBaoSauKhiNhanTien"]
        dict["maNganHang"] = dictGiaoDich["maNganHang"]
        dict["tenChuTaiKhoan"] = dictGiaoDich["tenChuTaiKhoan"]
        dict["chiNhanh"] = dictGiaoDich["chiNhanh"]
        dict["soTaiKhoan"] = dictGiaoDich["soTaiKhoan"]
        dict["qrYTe"] = 1
        var sPhone = ""
        for item in arrPhone {
            sPhone.append("\(item.0)#\(item.1),")
        }
        if sPhone.hasSuffix(",") {
            sPhone.removeLast()
        }
        dict["dsTKNhanThongBaoBienDongSoDu"] = sPhone
        
//        let sURL = "\(ROOT_URL)paymentGateway/editSanPham"
        let sURL = "\(ROOT_URL)boYTe_SanPhamYTe/editSanPham"
        connectUpQR(sURL, dict: dict)
        //        testEdit(sToken)
    }
    
    func xoaSanPham() {
        var dict = [String:Any]()
        dict["otpCheck"] = sOTP
        dict["token"] = sToken
        dict["maDaiLy"] = dictGiaoDich["maDaiLy"]
        dict["VMApp"] = 2
        dict["dsMaGiaoDich"] = [maGiaoDich]
        let sTime = "\(sGio) \(sNgay)"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        if let dateEx = formatter.date(from: sTime) {
            let time = dateEx.timeIntervalSince1970
            dict["exDate"] = time
        }

        if let dictDel = dict as? NSDictionary, let json = dictDel.jsonString() {
            debugPrint("\(TAG) - \(#function) - line : \(#line) - json : \(json)")
//            let sURL = "\(ROOT_URL)paymentGateway/xoaSanPham"
            let sURL = "\(ROOT_URL)boYTe_SanPhamYTe/xoaSanPham"
            let urlRequest = NSMutableURLRequest(url: URL(string: sURL)!)
            urlRequest.timeoutInterval = 90.0
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = json.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    self.anLoading()
                    self.authenView?.isHidden = true
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
                            let msgCode = json["msgCode"] as! NSNumber
                            if msgCode.intValue == 1 {
                                self.navigationController?.popViewController(animated: true)
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
                } else {
                    DispatchQueue.main.async {
                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                    }
                    
                }
            }
            task.resume()
            
        } else {
            DispatchQueue.main.async {
                self.anLoading()
                self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi xảy ra, vui lòng thử lại sau.")
            }
        }
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
    
    override func xuLyThucHienKhiKiemTraThanhCongTraVeToken(_ sToken: String!, otp sOtp: String!) {
        DispatchQueue.main.async {
            self.hienThiLoadingChuyenTien()
        }
        self.sToken = sToken
        self.sOTP = sOtp
        if isDelete {
            xoaSanPham()
        } else {
            dictGiaoDich["image"] = ""
            uploadQRSanPham()
        }
    }
    
    override func validateVanTay() -> Bool {
        if dictGiaoDich == nil {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Vui lòng kiểm tra lại các trường dữ liệu")
            return false
        }
        return true
    }
    
    @objc func suKienThayDoiNoiDung(_ sender:ExTextField) {
        if let cell = sender.superview?.superview as? TaoQRNameCell, let indexPath = tableView.indexPath(for: cell) {
            if dictGiaoDich == nil {
                dictGiaoDich = [String:Any]()
            }
            if indexPath.section == 0 {
                if indexPath.row == 1 {
                    dictGiaoDich["tenChuTaiKhoan"] = sender.text ?? ""
                } else if indexPath.row == 2 {
                    dictGiaoDich["soTaiKhoan"] = sender.text ?? ""
                } else if indexPath.row == 3 {
                    dictGiaoDich["ten"] = sender.text ?? ""
                } else if indexPath.row == 4 {
                    dictGiaoDich["diaChi1"] = sender.text ?? ""
                } else if indexPath.row == 5 {
                    dictGiaoDich["diaChi2"] = sender.text ?? ""
                }
            }
        }
    }
    
    @objc func suKienChangeSoTien(_ tfGia:ExTextField) {
        if let sSoTien = tfGia.text {
            let sSoTienTemp = sSoTien.replacingOccurrences(of: ".", with: "")
            if dictGiaoDich == nil {
                dictGiaoDich = [String : Any]()
            }
            let dSoTien = Double(sSoTienTemp) ?? 0
            dictGiaoDich["gia"] = NSNumber(value: dSoTien)
            tfGia.text = Common.hienThiTienTe(dSoTien)
        }
    }
    
    @objc func suKienChonDelPhone(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? QRSanPhamPhoneCell, let indexPath = tableView.indexPath(for: cell) {
            arrPhone.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
    @objc func suKienChonTokenView() {
        isShowTokenView = !isShowTokenView
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
    
    var authenView:ViewXacThucXoaQRSanPham?
    @IBAction func suKienChonXoaSanPham(_ sender: Any) {
        if maGiaoDich.isEmpty {
            return
        }
        isDelete = true
        if authenView == nil {
            authenView = ViewXacThucXoaQRSanPham.instanceFromNib()
            authenView?.isFace = self.enableFaceID
            authenView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(authenView!)
            authenView?.delegate = self
        }
        authenView?.isHidden = false
    }
    
    @objc func tapGio(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? AddNgayGioCell {
            isNgayGio = false
            showDatePicker(cell.tfGio, mode: .time)
        }
    }
    
    @objc func tapNgay(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? AddNgayGioCell {
            isNgayGio = true
            showDatePicker(cell.tfNgay, mode: .date)
        }
    }
    
    let datePicker = UIDatePicker()
    func showDatePicker(_ tfInput:ExTextField, mode:UIDatePicker.Mode){
        datePicker.datePickerMode = mode
        if datePicker.datePickerMode == .date {
            datePicker.minimumDate = Date()
            datePicker.setDate(Date(), animated: true)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            let min = dateFormatter.date(from: "00:00")      //createing min time
            datePicker.minimumDate = min
            datePicker.setDate(Date(), animated: true)
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Chọn", style: .done, target: self, action: #selector(suKienChonDoneNgay(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Thoát", style: .done, target: self, action: #selector(suKienChonCancelNgay(_:)))
        toolbar.setItems([cancel, space, done], animated: true)
        tfInput.inputAccessoryView = toolbar
        tfInput.inputView = datePicker
        tfInput.becomeFirstResponder()
    }
    
    @objc func suKienChonDoneNgay(_ sender:Any) {
        self.view.endEditing(true)
        let formatter = DateFormatter()
        if isNgayGio {
            formatter.dateFormat = "dd/MM/yyyy"
            sNgay = formatter.string(from: datePicker.date)
        } else {
            formatter.dateFormat = "HH:mm"
            sGio = formatter.string(from: datePicker.date)
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        }
    }
    
    @objc func suKienChonCancelNgay(_ sender:Any) {
        self.view.endEditing(true)
    }
    
    @objc func suKienChonXoaNgayGio(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? AddNgayGioCell, let indexPath = self.tableView.indexPath(for: cell) {
            debugPrint("\(TAG) - \(#function) - line : \(#line) - click indexPath : \(indexPath)")
            sNgay = ""
            sGio = ""
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    @IBAction func suKienChonDanhSachQRYTe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension TaoQRYTeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else if section == 1 {
            return arrPhone.count
        } else if section == 2 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 65
            }
        } else if indexPath.section == 3 {
            return 100
        } else if indexPath.section == 1 {
            return 60
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
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
            if section == 3 {
                lblTitle.text = "Thêm ảnh sản phẩm"
            } else {
                lblTitle.text = "Điện thoại nhận tin báo có"
            }
            lblTitle.translatesAutoresizingMaskIntoConstraints = false
            headerMain.addSubview(lblTitle)
            lblTitle.centerXAnchor.constraint(equalTo: headerMain.centerXAnchor, constant: 0).isActive = true
            lblTitle.centerYAnchor.constraint(equalTo: headerMain.centerYAnchor, constant: 0).isActive = true
            
            let imgvIcon = UIImageView(image: UIImage(named: "icon_add-64"))
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
                if tag == 3 && !self.showThemAnh{
                    self.layAnhSanPham()
                } else if tag == 1 {
                    self.hienThiLayDanhBa()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DonGiaQRCell", for: indexPath) as! DonGiaQRCell
                cell.tfGia.addTarget(self, action: #selector(suKienChangeSoTien(_:)), for: .editingChanged)
                if dictGiaoDich != nil {
                    if let numberGia = dictGiaoDich["gia"] as? NSNumber {
                        let dGia = numberGia.doubleValue
                        cell.tfGia.text = Common.hienThiTienTe(dGia)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
                if indexPath.row == 0 {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 12))
                    imageView.image = UIImage(named: "muiten35x21")
                    cell.tfName.rightView = imageView
                    cell.tfName.rightViewMode = .always
                    cell.tfName.isEnabled = false
                    if dictGiaoDich != nil {
                        if let tenNganHang = dictGiaoDich["tenNganHang"] as? String {
                            cell.tfName.text = tenNganHang
                        } else {
                            cell.tfName.text = "Ngân hàng nhận thanh toán"
                        }
                    } else {
                        cell.tfName.text = "Ngân hàng nhận thanh toán"
                    }
                    
                } else {
                    cell.tfName.addTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
                    cell.tfName.isEnabled = true
                    if indexPath.row == 1 {
                        cell.tfName.placeholder = "Chủ tài khoản"
                        cell.tfName.text = dictGiaoDich["tenChuTaiKhoan"] as? String
                    } else if indexPath.row == 2 {
                        cell.tfName.placeholder = "Số tài khoản"
                        cell.tfName.text = dictGiaoDich["soTaiKhoan"] as? String
                    } else if indexPath.row == 3 {
                        cell.tfName.placeholder = "Sản phẩm dịch vụ (tối đa 25 ký tự)"
                        cell.tfName.text = dictGiaoDich["ten"] as? String
                    } else if indexPath.row == 4 {
                        cell.tfName.placeholder = "Địa chỉ 1"
                        cell.tfName.text = dictGiaoDich["diaChi1"] as? String
                    } else if indexPath.row == 5 {
                        cell.tfName.placeholder = "Địa chỉ 2"
                        cell.tfName.text = dictGiaoDich["diaChi2"] as? String
                    }
                }
                return cell
            }
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRSanPhamPhoneCell", for: indexPath) as! QRSanPhamPhoneCell
            cell.selectionStyle = .none
            cell.btnDel.isHidden = false
            cell.btnDel.addTarget(self, action: #selector(suKienChonDelPhone(_:)), for: .touchUpInside)
            
            let phone = arrPhone[indexPath.row]
            cell.lblName.text = phone.1
            cell.lblPhone.text = phone.0
            return cell
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNgayGioCell", for: indexPath) as! AddNgayGioCell
                cell.selectionStyle = .none
                cell.tfGio.text = sGio
                cell.tfNgay.text = sNgay
                cell.btnGio.addTarget(self, action: #selector(tapGio(_:)), for: .touchUpInside)
                cell.btnNgay.addTarget(self, action: #selector(tapNgay(_:)), for: .touchUpInside)
                cell.btnDelete.addTarget(self, action: #selector(suKienChonXoaNgayGio(_:)), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
                cell.tfName.removeTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
                cell.tfName.placeholder = "Mô tả (tối đa 200 ký tự)"
                return cell
            }
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenQRCell", for: indexPath) as! AuthenQRCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.viewToken.isHidden = !isShowTokenView
            if self.enableFaceID {
                cell.btnAuthen.setImage(UIImage(named: "face-id"), for: .normal)
            } else {
                cell.btnAuthen.setImage(UIImage(named: "finger"), for: .normal)
            }
            cell.btnPKI.isHidden = true
            cell.btnToken.addTarget(self, action: #selector(suKienChonTokenView), for: .touchUpInside)
            cell.btnAuthen.addTarget(self, action: #selector(suKienBamNutMatKhauVanTay(_:)), for: .touchUpInside)
            cell.btnPKI.addTarget(self, action: #selector(suKienBamNutPKI(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaoQRNameCell", for: indexPath) as! TaoQRNameCell
            cell.tfName.removeTarget(self, action: #selector(suKienThayDoiNoiDung(_:)), for: .editingChanged)
            return cell
        }
//        else if indexPath.section == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemAnhSanPhamQRCell", for: indexPath) as! ThemAnhSanPhamQRCell
//            cell.selectionStyle = .none
//            cell.arrImage.removeAll()
//            cell.arrImage.append(contentsOf: arrImage)
//            cell.showAnhPreview()
//            cell.delegate = self
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = ChonBankQRYTeViewController(nibName: "ChonBankQRYTeViewController", bundle: nil)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TaoQRYTeViewController : ChonBankQRYTeViewControllerDelegate {
    func suKienChonBank(_ sName: String, sCode: String) {
        if dictGiaoDich == nil {
            dictGiaoDich = [String:Any]()
        }
        debugPrint("\(TAG) - \(#function) - line : \(#line) - sCode : \(sCode) - sName : \(sName)")
        dictGiaoDich["maNganHang"] = sCode
        dictGiaoDich["tenNganHang"] = sName
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}

extension TaoQRYTeViewController : ThemAnhSanPhamQRCellDelegate {
    func suKienDeleteImage(_ index: Int) {
        if index < arrImage.count {
            arrImage.remove(at: index)
            self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
}

extension TaoQRYTeViewController : ViewXacThucXoaQRSanPhamDelegate {
    func suKienChonThucHienToken(_ sToken: String) {
        if sToken.count == 6 {
            self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN
            self.sToken = self.xuLyKhiBamThucHienToken(sToken)
            self.sOTP = ""
            DispatchQueue.main.async {
                self.hienThiLoadingChuyenTien()
            }
            xoaSanPham()
        }
        
    }
    
    func suKienChonVanTay(_ sender:Any) {
        self.suKienBamNutMatKhauVanTay(sender)
    }
    
    func suKienChonPKI() {
        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Thiết bị chưa hỗ trợ ký số")
    }
    
    func cancelDeleteQRSanPham() {
        isDelete = false
    }
}

extension TaoQRYTeViewController : AuthenQRCellDelegate {
    func suKienChonThucHienAuth(_ sToken: String) {
        if sToken.count == 6 && validateVanTay() {
            self.mTypeAuthenticate = TYPE_AUTHENTICATE_TOKEN
            self.sToken = self.xuLyKhiBamThucHienToken(sToken)
            self.sOTP = ""
            DispatchQueue.main.async {
                self.hienThiLoadingChuyenTien()
            }
            uploadQRSanPham()
        }
    }
}
