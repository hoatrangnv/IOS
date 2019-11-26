//
//  GiaoDienDangKyDoanhNghiep.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/21/19.
//

import UIKit

class GiaoDienDangKyDoanhNghiep: GiaoDichViewController, UINavigationControllerDelegate {
    private let TAG = "TaoQRSanPhamVer2Controller"
    @IBOutlet var imgvMatTruoc: UIImageView!
    @IBOutlet var imgvMatSau: UIImageView!
    @IBOutlet var edMaDoanhNghiep: ExTextField!
    @IBOutlet var edTenDoanhNghiep: ExTextField!
    @IBOutlet var edTenChu: ExTextField!
    @IBOutlet var edPhone: ExTextField!
    @IBOutlet var edEmail: ExTextField!
    @IBOutlet var lblDieuKhoan: UILabel!
    
    var imageTruoc:UIImage?
    var imageSau:UIImage?
    
    var sImageTruocName = ""
    var sImageSauName = ""
    
    var nOptionLayAnh = 0
    var indexPostImage = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleView(NSLocalizedString("TAO_TAI_KHOAN_DOANH_NGHIEP", comment: ""))
    }

    @IBAction func suKienLayAnhMatTruoc(_ sender: Any) {
        nOptionLayAnh = 0
        layAnhSanPham()
    }
    
    @IBAction func suKienChupAnhMatTruoc(_ sender: Any) {
        nOptionLayAnh = 0
        chupAnhSanPham()
    }

    @IBAction func suKienLayAnhMatSau(_ sender: Any) {
        nOptionLayAnh = 1
        layAnhSanPham()
    }
    
    @IBAction func suKienChupAnhMatSau(_ sender: Any) {
        nOptionLayAnh = 1
        chupAnhSanPham()
    }
    
    func layAnhSanPham() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func chupAnhSanPham() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func convertImageToBase64(_ img:UIImage) -> String?{
        if let imgData = img.jpegData(compressionQuality: 0.6) {
            return Base64.encode(imgData)
        }
        return nil
    }
    
    func checkValue() -> Bool{
        let arrTF = [edPhone, edTenChu, edTenDoanhNghiep, edMaDoanhNghiep]
        let result = arrTF.filter { (ed) -> Bool in
            return ed?.text?.isEmpty ?? true
        }
        if result.count > 0 {
            return false
        }
        if imageTruoc == nil || imageSau == nil {
            return false
        }
        return true
    }
    
    @IBAction func suKienChonDangKy(_ sender: Any) {
        if checkValue() {
            if let img = self.imageTruoc, let sBase64 = self.convertImageToBase64(img) {
                indexPostImage = 0
                DispatchQueue.main.async {
                    self.hienThiLoadingChuyenTien()
                    self.uploadAnh(sBase64)
                }
            }
        } else {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Vui lòng kiểm tra lại các trường dữ liệu")
        }
    }
    
    func uploadAnh(_ sImage:String) {
        guard let maDN = self.edMaDoanhNghiep.text else { return }
        var name = "imageCompany1"
        if indexPostImage == 1 {
            name = "imageCompany2"
        }
        let dict:[String:Any] = ["name":name, "value":sImage, "maDoanhNghiep":maDN, "VMApp":2]
        if let json = dict.jsonStringRepresentation {
            let sURL = "https://vimass.vn/vmbank/services/media/uploadVer2/\(maDN)"
            let urlRequest = NSMutableURLRequest(url: URL(string: sURL)!)
            urlRequest.timeoutInterval = 90.0
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = json.data(using: .utf8)
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
                            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - responseData : \(String(describing: String(data: responseData, encoding: .utf8)))")
                            let msgCode = json["msgCode"] as! NSNumber
                            if msgCode.intValue == 1 {
                                if let result = json["result"] as? String {
                                    debugPrint("\(self.TAG) - \(#function) - line : \(#line) - result : \(result)")
                                    if self.indexPostImage == 0 {
                                        self.sImageTruocName = result
                                        if let img = self.imageSau, let sBase64 = self.convertImageToBase64(img) {
                                            DispatchQueue.main.async {
                                                self.indexPostImage = 1
                                                self.uploadAnh(sBase64)
                                            }
                                        } else {
                                            self.showError()
                                        }
                                    } else {
                                        self.sImageSauName = result
                                        self.createNewAccount()
                                    }
                                } else {
                                    self.showError()
                                }
                            } else {
                                self.showError()
                            }
                        }
                    } catch{}
                }
            }
            task.resume()
            session.finishTasksAndInvalidate()
        }
    }
    
    func createNewAccount() {
        DispatchQueue.main.async {
            let dicPost:[String:Any] = ["companyCode" : self.edMaDoanhNghiep.text ?? "",
                                        "companyName" : self.edTenDoanhNghiep.text ?? "",
                                        "nameRepresent" : self.edTenChu.text ?? "",
                                        "walletId" : self.edPhone.text ?? "",
                                        "email" : self.edEmail.text ?? "",
                                        "imageCompany1" : self.sImageTruocName,
                                        "imageCompany2" : self.sImageSauName,
                                        "VMApp" : 2]
            if let json = dicPost.jsonStringRepresentation {
                MyConnection.connectPost(url: URL(string: "\(ROOT_URL)account/createNewCompanyAcc")!, jsonString: json) { (error, data) in
                    DispatchQueue.main.async {
                        self.anLoading()
                    }
                    if let responseData = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                                debugPrint("\(self.TAG) - \(#function) - line : \(#line) - responseData : \(String(describing: String(data: responseData, encoding: .utf8)))")
                                let msgCode = json["msgCode"] as! NSNumber
                                let msgContent = (json["msgContent"] as? String) ?? ""
                                if msgCode.intValue == 1 || msgCode.intValue == 3{
                                    DispatchQueue.main.async {
                                        self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: msgContent)
                                    }
                                } else {
                                    self.showError()
                                }
                            }
                        } catch{}
                    }
                }
            }
        }
        
    }
    
    func showError() {
        DispatchQueue.main.async {
            self.hienThiHopThoaiMotNutBamKieu(-1, cauThongBao: "Có lỗi xảy ra, vui lòng thử lại sau")
        }
    }
}

extension GiaoDienDangKyDoanhNghiep : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            debugPrint("\(TAG) - \(#function) - line : \(#line) - pickerImage.size : \(pickerImage.size)")
            if nOptionLayAnh == 0 {
                imageTruoc = pickerImage
            } else {
                imageSau = pickerImage
            }
            picker.dismiss(animated: true) {
                if self.nOptionLayAnh == 0 {
                    self.imgvMatTruoc.image = self.imageTruoc
                } else {
                    self.imgvMatSau.image = self.imageSau
                }
            }
        }
        
    }
}
