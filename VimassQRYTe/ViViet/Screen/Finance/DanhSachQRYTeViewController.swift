//
//  DanhSachQRYTeViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/28/19.
//

import UIKit

class DanhSachQRYTeViewController: GiaoDichViewController {
    private let TAG = "DanhSachQRYTeViewController"
    @IBOutlet var tableView: UITableView!
    var arrQRSanPham = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "QR Y tế"
        
        let btnRight = UIBarButtonItem(image: UIImage(named: "icon_add-64"), style: .done, target: self, action: #selector(suKienChonAddNew(_:)))
        self.navigationItem.rightBarButtonItem = btnRight
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "QRDonViTableViewCell", bundle: nil), forCellReuseIdentifier: "CellQRDonVi")
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ketNoiLayDanhSachQRYTe()
    }
    
    @objc func suKienChonAddNew(_ sender:Any) {
        let vc = TaoQRYTeViewController(nibName: "TaoQRYTeViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func ketNoiLayDanhSachQRYTe() {
        DispatchQueue.main.async {
            self.hienThiLoading()
        }
        let sUrl = "https://vimass.vn/vmbank/services/paymentGateway/layThongTinDaiLy?maDaiLy=\(DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP) ?? "")"
        debugPrint("\(TAG) - \(#function) - line : \(#line) - sUrl : \(sUrl)")
        self.arrQRSanPham.removeAll()
        guard let url = URL(string: sUrl) else {
            DispatchQueue.main.async {
                self.anLoading()
            }
            return
        }
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.timeoutInterval = 60.0
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard error == nil else {
                debugPrint("\(#function) - \(url.absoluteString) - error : \(error.debugDescription)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.anLoading()
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
                return
            }
            guard let responseData = data else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.anLoading()
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
                        var key = "msgContent"
                        if Localization.getCurrentLang() == ENGLISH {
                            key = "msgContent_en"
                        }
                        let msgCode = json["msgCode"] as? Int ?? 1
                        if msgCode == 1 {
                            if let reuslt = json["result"] as? [String : Any], let dsSanPham = reuslt["dsSanPham"] as? [[String:Any]] {
                                for item in dsSanPham {
                                    let qrYTe = item["qrYTe"] as? Int ?? 0
                                    if qrYTe == 1 {
                                        self.arrQRSanPham.append(item)
                                    }
                                }
                            }
                        } else {
                            if let sThongBao = json[key] as? String {
                                DispatchQueue.main.async {
                                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: sThongBao)
                                }
                            }
                        }
                    }
                } catch{
                    
                }
                DispatchQueue.main.async {
                    debugPrint("\(self.TAG) - \(#function) - line : \(#line) - self.arrQRSanPham.count : \(self.arrQRSanPham.count)")
                    self.anLoading()
                    self.tableView.reloadData()
                }
            }
            else {
                debugPrint("\(#function) - \(url.absoluteString) - error : \(error.debugDescription)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.anLoading()
                    self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi khi kết nối, vui lòng thử lại sau.")
                }
            }
        }
        task.resume()
    }

    @objc func suKienChonIconQR(_ sender:UIButton) {
        if let cell = sender.superview?.superview as? QRDonViTableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let item = arrQRSanPham[indexPath.row]
            if let linkQR = item["linkQR"] as? String {
                let showQR = ShowQRSanPhamView.instanceFromNib()
                showQR.frame = self.view.bounds
                showQR.imgvPreview.sd_setImage(with: URL(string: linkQR))
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
}

extension DanhSachQRYTeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQRSanPham.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellQRDonVi", for: indexPath) as! QRDonViTableViewCell
        let item = arrQRSanPham[indexPath.row]
        if let linkQR = item["linkQR"] as? String {
            cell.imgvQR.sd_setImage(with: URL(string: linkQR))
        }
        
        cell.btnPhongToQR.addTarget(self, action: #selector(suKienChonIconQR(_:)), for: .touchUpInside)
        if let sImage = item["image"] as? String {
            var sImageRe = sImage.replacingOccurrences(of: "[", with: "")
            sImageRe = sImageRe.replacingOccurrences(of: "]", with: "")
            let arrTemp = sImageRe.components(separatedBy: ";")
            if let sLink = arrTemp.first {
                cell.imgvAvatar.sd_setImage(with: URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(sLink)"))
            }
        }
        
        if let nGia = item["gia"] as? NSNumber {
            let dGia = nGia.doubleValue
            if dGia > 0 {
                cell.lblGia.text = Common.hienThiTienTe_1(dGia)
            } else {
                cell.lblGia.text = ""
            }
        }
        cell.lblDC1.text = item["diaChi1"] as? String
        cell.lblDC2.text = item["diaChi2"] as? String
        
        cell.lblTenHienThi.text = item["ten"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = arrQRSanPham[indexPath.row]
        if let maGiaoDich = item["maGiaoDich"] as? String {
            let vc = TaoQRYTeViewController(nibName: "TaoQRYTeViewController", bundle: nil)
            vc.maGiaoDich = maGiaoDich
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
