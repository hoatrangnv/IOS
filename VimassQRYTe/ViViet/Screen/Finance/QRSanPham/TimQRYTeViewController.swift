//
//  TimQRYTeViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class TimQRYTeViewController: GiaoDichViewController {
    private let TAG = "TimQRYTeViewController"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var edTenCoSo: ExTextField!
    @IBOutlet var edTenKH: ExTextField!
    var limit = 20
    var offset = 0
    var arrCoSo = [[String : Any]]()
    @IBOutlet var heightOptions: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitleView("Tìm QR y tế theo tên")
        
        let imgv = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 14))
        imgv.image = UIImage(named: "muiten35x21")
        edTenCoSo.rightView = imgv
        edTenCoSo.rightViewMode = .always
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(suKienChonTenCoSo(_:)))
        edTenCoSo.addGestureRecognizer(tap)
        
        tableView.layer.borderColor = UIColor.darkGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.tableFooterView = UIView(frame: .zero)
        
        heightOptions.constant = 0
        self.tableView.isHidden = true
        
        ketNoiLayDanhSach()
    }
    
    @objc func suKienChonTenCoSo(_ gesture:UITapGestureRecognizer) {
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            if self.arrCoSo.count * 50 > 200 {
                self.heightOptions.constant = 200
            } else {
                self.heightOptions.constant = CGFloat(self.arrCoSo.count) * 50
            }
        }
    }

    func hideTableViewOptions() {
        UIView.animate(withDuration: 0.2, animations: {
            self.heightOptions.constant = 0
        }) { (success) in
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func suKienChonTraCuu(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func ketNoiLayDanhSach() {
        let sURL = "https://vimass.vn/vmbank/services/boYTe/layDanhSachCoSoYte"
        var sUser = DucNT_LuuRMS.layThongTinDangNhap(KEY_LOGIN_ID_TEMP)!
        sUser = "0913201990"
        let dict = ["user":sUser, "limit":limit, "offset":offset] as [String : Any]
        if let json = dict.jsonStringRepresentation {
            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - json : \(json)")
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
                if statusCode == 200 {
                    do {
                        if var sData = String(data: responseData, encoding: .utf8) {
                            sData = sData.replacingOccurrences(of: "\\", with: "")
                            debugPrint("\(self.TAG) - \(#function) - line : \(#line) - sData : \(sData)")
                        }
                        if let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] {
                            let msgCode = jsonResult["msgCode"] as! NSNumber
                            if msgCode.intValue == 1 {
                                if let results = jsonResult["result"] as? [[String:Any]]{
                                    debugPrint("\(self.TAG) - \(#function) - line : \(#line) - results.count : \(results.count)")
                                    self.arrCoSo.append(contentsOf: results)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TimQRYTeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCoSo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        let item = arrCoSo[indexPath.row]
        cell!.textLabel?.text = item["merchantName"] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideTableViewOptions()
    }
}
