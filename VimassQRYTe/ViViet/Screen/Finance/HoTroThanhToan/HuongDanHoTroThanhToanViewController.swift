//
//  HuongDanHoTroThanhToanViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 9/27/19.
//

import UIKit

class HuongDanHoTroThanhToanViewController: GiaoDichViewController {
    private let TAG = "HuongDanHoTroThanhToanViewController"
    @IBOutlet var webHuongDan: UIWebView!
    
    var idOption = ""
    var nType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nType == 1 {
            self.addTitleView("Hướng dẫn")
            let html = "- Bước 1: Đến quầy thu ngân mượn thẻ y tế, đặt cược thẻ 45.000 đ, đổi tiền mặt lấy tiền trong thẻ.<br/><br/>- Bước 2: Khai báo (i) Họ tên, số thẻ căn cước, ngày cấp, nơi cấp; hoặc (ii) Tài khoản/ thẻ của người thân nhận tiền chưa sử dụng.<br/><br/>- Bước 3: Tại điểm thanh toán của cơ sở y tế: (i) Nhận hoá đơn thanh toán và chạm thẻ vào đầu đọc khi được thông báo số tiền và nội dung thanh toán, hoặc (ii) kiểm tra thông tin và số dư trong thẻ.<br/><br/>- Bước 4: Kết thúc đợt khám, điều trị bệnh người dân trả lại ther tại quầy đăng ký hoặc quầy thu ngân, yêu cầu cán bộ thu thẻ thông báo số tiền còn trên thẻ.<br/><br/>- Bước 5: Sau 1 phiên làm việc của ngân hàng, người dân đến các điểm giao dịch ngân hàng được cơ sở y tế chỉ định, trình thẻ căn cước công dân để nhận tiền. Trường hợp sử dụng tài khoản/thẻ của người thân, chỉ cần đợi vài phút để biết tài khoản đã nhận tiền. Số tiền được hoàn bao gồm tiền chưa sử dụng và tiền cược thẻ.<br/><br/>Lưu ý: Tại quầy thu ngân, hiệu thuốc hoặc nơi bác sỹ chỉ định khám chữa bệnh có thu tiền. Người dân có thể tra cưú việc hoàn tiền trong thời hạn 30 ngày."
            self.webHuongDan.loadHTMLString(html, baseURL: nil)
        } else {
            let index = UserDefaults.standard.integer(forKey: "INDEX_INTRO")
            if index == 10 {
                self.addTitleView("Hướng dẫn tra cứu")
            } else {
                self.addTitleView("Hướng dẫn")
            }
            switch index {
            case 0:
                idOption = "1568460803819xcdv7"
            case 1:
                idOption = "156887194605305vmv"
            case 2:
                idOption = "1570009805747hng4m"
            case 3:
                idOption = "15684608908788ut4d"
            case 4:
                idOption = "15684609282009d5l7"
            case 5:
                idOption = "15684609282009d5l7"
            case 10:
                idOption = "156836195514595rn5"
            default:
                idOption = ""
            }
            connectGetIntro()
        }
    }
    
    func connectGetIntro() {
        if !idOption.isEmpty {
            var dict = [String:Any]()
            dict["id"] = idOption
            dict["langId"] = 1
            
            if let jsonDict = dict.jsonStringRepresentation {
                DispatchQueue.main.async {
                    self.hienThiLoading()
                }
                debugPrint("\(TAG) - \(#function) - line : \(#line) - jsonDict : \(jsonDict)")
                let sURL = "\(ROOT_URL)boYTe_TinTuc_BaiViet/getDetail"
                debugPrint("\(TAG) - \(#function) - line : \(#line) - sURL : \(sURL)")
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
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                                let msgCode = json["msgCode"] as? Int
                                if msgCode == 1 {
                                    if let result = json["result"] as? [String : Any], let sContent = result["content_vi"] as? String {
                                        let decodedData = Data(base64Encoded: sContent)!
                                        let decodedString = String(data: decodedData, encoding: .utf8)!
                                        DispatchQueue.main.async {
                                            self.webHuongDan.loadHTMLString(decodedString, baseURL: nil)
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
            }
        }
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
