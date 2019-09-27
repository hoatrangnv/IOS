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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitleView("Hướng dẫn")
        let index = UserDefaults.standard.integer(forKey: "INDEX_INTRO")
        switch index {
        case 0:
            idOption = "1568460803819xcdv7"
        case 1:
            idOption = "1568460849522sojgb"
        case 2:
            idOption = "15684608908788ut4d"
        case 3:
            idOption = "15684609282009d5l7"
        default:
            idOption = ""
        }
        connectGetIntro()
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
