//
//  NhapInfoHoTroThanhToanViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 9/23/19.
//

import UIKit

class NhapInfoHoTroThanhToanViewController: GiaoDichViewController {
    let DA_HUY = -1;
    let CHUA_THANH_TOAN = 0;
    let DA_THANH_TOAN = 1;
    let DA_HOAN_TIEN = 2;
    let CHUA_HOAN_TIEN = 3;
    private let TAG = "NhapInfoHoTroThanhToanViewController"
    private let arrBenhVien = ["Bệnh viện Trung ương Thái Nguyên", "Bệnh viện Sản Nhi Quảng Ninh", "Bệnh viện Việt Đức", "Bệnh viện Nhi Trung ương", "Bệnh viện Đa khoa Hà Đông", "Bệnh viện Phụ sản Trung ương", "Bệnh viện Phụ sản Hà  "]

    @IBOutlet var tfBenhVien: ExTextField!
    @IBOutlet var tfMaBenhNhan: ExTextField!
    @IBOutlet var tfHoTen: ExTextField!
    @IBOutlet var tableViewOptions: UITableView!
    @IBOutlet var tableViewBenhVien: UITableView!
    @IBOutlet var stackTop: UIStackView!
    
    var indexOptions = 0
    var arrList = [[String : Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("Hỗ trợ thanh toán")
        
        for item in stackTop.arrangedSubviews {
            if let btn = item as? UIButton, let lblTitle = btn.titleLabel {
                lblTitle.textAlignment = .center
                lblTitle.numberOfLines = 2
            }
        }
        
        self.updateBackgroundButton(indexOptions)
        
        self.tableViewOptions.tableFooterView = UIView(frame: .zero)
        self.tableViewOptions.register(UINib(nibName: "ItemThanhToanCell", bundle: nil), forCellReuseIdentifier: "ItemThanhToanCell")
        self.tableViewOptions.delegate = self
        self.tableViewOptions.dataSource = self
        
        self.tableViewBenhVien.tableFooterView = UIView(frame: .zero)
        self.tableViewBenhVien.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
        self.tableViewBenhVien.isHidden = true
        DispatchQueue.main.async {
            self.tableViewBenhVien.layer.borderColor = UIColor.darkGray.cgColor
            self.tableViewBenhVien.layer.borderWidth = 1
        }
        
        let imgvLeft = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        imgvLeft.image = UIImage(named: "muiten35x21")
        tfBenhVien.rightView = imgvLeft
        tfBenhVien.rightViewMode = .always
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(suKienChonBenhVien(_:)))
        tfBenhVien.addGestureRecognizer(tap)
        tfBenhVien.isUserInteractionEnabled = true
        
        tfBenhVien.text = arrBenhVien.first
    }
    
    func updateBackgroundButton(_ index:Int) {
        var i = 0
        for item in stackTop.arrangedSubviews {
            item.backgroundColor = UIColor(red: 0, green: 114.0/255.0, blue: 187.0/255.0, alpha: 1)
            if let btn = item as? UIButton {
                var fColor:CGFloat = 51.0/255.0
                if index == i {
                    fColor = 51.0/255.0
                    item.backgroundColor = UIColor.white
                } else {
                    fColor = 255.0
                }
                btn.setTitleColor(UIColor(red: fColor, green: fColor, blue: fColor, alpha: 1), for: .normal)
            }
            i += 1
        }
    }

    @objc func suKienChonBenhVien(_ gesture:UITapGestureRecognizer) {
        self.tableViewBenhVien.isHidden = !self.tableViewBenhVien.isHidden
    }
    
    func checkData() -> Bool {
        if (tfMaBenhNhan.text?.isEmpty ?? true) && (tfHoTen.text?.isEmpty ?? true){
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Nhập thông tin bệnh nhân")
            return false
        }
        return true
    }

    @IBAction func suKienChonTraCuu(_ sender: Any) {
        self.view.endEditing(true)
        connectGetData(indexOptions)
    }
    
    func connectGetData(_ index:Int) {
        if !checkData() {
            return
        }
        self.arrList.removeAll()
        var dict = [String:Any]()
        dict["maBenhNhan"] = tfMaBenhNhan.text ?? ""
        dict["soKhamBenh"] = ""
        dict["maDaiLy"] = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_MA_DAI_LY)
        dict["maDiemThu"] = ""
        dict["hoTenNguoiMua"] = tfHoTen.text ?? ""
        dict["maSoThue"] = ""
        dict["soCMND"] = ""
        dict["maQR"] = ""
        dict["timeFrom"] = 0
        dict["timeTo"] = 0
        dict["offset"] = 0
        dict["limit"] = 100
        dict["trangThai"] = index
        
        if let jsonDict = dict.jsonStringRepresentation {
            DispatchQueue.main.async {
                self.hienThiLoading()
            }
            debugPrint("\(TAG) - \(#function) - line : \(#line) - jsonDict : \(jsonDict)")
            let sURL = "\(ROOT_URL)boYTe_hoaDonDatCoc/searchAll"
            let urlRequest = NSMutableURLRequest(url: URL(string: sURL)!)
            urlRequest.timeoutInterval = 90.0
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonDict.data(using: .utf8)
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
//                        debugPrint("\(self.TAG) - \(#function) - line : \(#line) - json : \(String(data: responseData, encoding: .utf8) ?? "")")
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                            let msgCode = json["msgCode"] as? Int
                            if msgCode == 1 {
                                if let result = json["result"] as? [[String:Any]] {
                                    self.arrList.append(contentsOf: result)
                                }
                            }
                        }
                    } catch{}
                    DispatchQueue.main.async {
                        self.tableViewOptions.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                    }
                    
                }
            }
            task.resume()
        }
    }

    func updateTableView() {
        self.tableViewOptions.reloadData()
        if arrList.count > 0 {
            self.tableViewOptions.tableFooterView = UIView(frame: .zero)
        } else {
            let lblFooter = UILabel(frame: CGRect(x: 0, y: 0, width: tableViewOptions.frame.width, height: tableViewOptions.frame.height))
            lblFooter.textAlignment = .center
            lblFooter.textColor = .darkGray
            lblFooter.text = "Chưa có dữ liệu"
            self.tableViewOptions.tableFooterView = lblFooter
        }
    }
    
    @IBAction func suKienChonChuThanhToan(_ sender: Any) {
        if indexOptions != 0 {
            indexOptions = 0
            self.updateBackgroundButton(indexOptions)
            connectGetData(CHUA_THANH_TOAN)
        }
    }
    
    @IBAction func suKienChonDaThanhToan(_ sender: Any) {
        if indexOptions != 1 {
            indexOptions = 1
            self.updateBackgroundButton(indexOptions)
            connectGetData(DA_THANH_TOAN)
        }
    }
    
    @IBAction func suKienChonChuaHoanTien(_ sender: Any) {
        if indexOptions != 2 {
            indexOptions = 2
            self.updateBackgroundButton(indexOptions)
            connectGetData(CHUA_HOAN_TIEN)
        }
    }
    
    @IBAction func suKienChonDaHoanTien(_ sender: Any) {
        if indexOptions != 3 {
            indexOptions = 3
            self.updateBackgroundButton(indexOptions)
            connectGetData(DA_HOAN_TIEN)
        }
    }
}

extension NhapInfoHoTroThanhToanViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewOptions {
            return arrList.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewOptions {
            let item = arrList[section]
            if let list = item["items"] as? [[String : Any]] {
                return list.count
            }
            return 0
        }
        return arrBenhVien.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewOptions {
            return UITableView.automaticDimension
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != tableViewOptions {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView != tableViewOptions {
            return nil
        }
        let header = HeaderHoTroThanhToanView.instanceFromNib()
        header.tag = section
        header.sizeToFit()
        let itemHoSo = arrList[section]
        header.lblHoTen.text = itemHoSo["hoTenNguoiMua"] as? String
        header.lblCMND.text = itemHoSo["soCMND"] as? String
        if let dSoTien = itemHoSo["tongTienThanhToan"] as? Double {
            header.lblSoTien.text = "Số tiền: " + Common.hienThiTienTe_1(dSoTien)
        }
        if let dVAT = itemHoSo["thueSuat"] as? Int {
            header.lblVAT.text = "VAT: \(dVAT)"
        }
        header.btnDel.addTarget(self, action: #selector(suKienChonDelete(_:)), for: .touchUpInside)
        header.btnQR.addTarget(self, action: #selector(suKienChonPreviewQR(_:)), for: .touchUpInside)
        return header
    }
    
    @objc func suKienChonDelete(_ sender:UIButton) {
        let authenView = ViewXacThucXoaQRSanPham.instanceFromNib()
        authenView.isFace = self.enableFaceID
        authenView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(authenView)
//        authenView.delegate = self
    }
    
    @objc func suKienChonPreviewQR(_ sender:UIButton) {
        if let view = sender.superview?.superview as? HeaderHoTroThanhToanView {
            let itemHoSo = arrList[view.tag]
            if let sLinkQR = itemHoSo["linkQRChuan"] as? String {
                let showQR = ShowQRSanPhamView.instanceFromNib()
                showQR.frame = self.view.bounds
                showQR.imgvPreview.sd_setImage(with: URL(string: sLinkQR))
                self.view.addSubview(showQR)
                
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(suKienLongPressImage(_:)))
                longGesture.minimumPressDuration = 1
                showQR.imgvPreview.addGestureRecognizer(longGesture)
                showQR.imgvPreview.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func suKienLongPressImage(_ gesture:UILongPressGestureRecognizer) {
        guard let imgPreview = gesture.view as? UIImageView else { return }
        let alert = UIAlertController(title: "Thông báo", message: "Lưu ảnh vào thư viện ảnh của điện thoại?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Đóng", style: .cancel, handler: nil)
        let done = UIAlertAction(title: "Lưu", style: .default) { (action) in
            if let img = imgPreview.image {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        }
        alert.addAction(cancel)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewOptions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemThanhToanCell", for: indexPath) as! ItemThanhToanCell
            let itemHoSo = arrList[indexPath.section]
            if let list = itemHoSo["items"] as? [[String : Any]], let item = list[indexPath.row] as? [String : Any]{
                cell.lblTitle.text = "\(indexPath.row + 1). \(item["tenHangHoaDichVu"] as? String ?? "")"
                if let sSoTien = item["thanhTienCuoiCung"] as? Double {
                    cell.lblSubTitle.text = "Số tiền: " + Common.hienThiTienTe_1(sSoTien)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
            cell.lblTitle.textColor = UIColor.black
            cell.lblTitle.text = arrBenhVien[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewBenhVien {
            tableView.isHidden = true
            tfBenhVien.text = arrBenhVien[indexPath.row]
        }
    }
}
