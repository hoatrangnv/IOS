//
//  ChonBankQRYTeViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/28/19.
//

import UIKit

protocol ChonBankQRYTeViewControllerDelegate {
    func suKienChonBank(_ sName:String, sCode:String)
}

class ChonBankQRYTeViewController: GiaoDichViewController {
    private let TAG = "ChonBankQRYTeViewController"
    
    @IBOutlet var tableView: UITableView!
    var delegate:ChonBankQRYTeViewControllerDelegate?
    var arrBanks = [(String, String)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh sách ngân hàng"
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        if let path = Bundle.main.path(forResource: "getBanks", ofType: "txt") {
            do {
                let sContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                if let jsonData = sContent.data(using: .utf8) {
                    if let arrJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String:Any]] {
                        for item in arrJson {
                            arrBanks.append(((item["NAME_VI"] as? String) ?? "", (item["SMS"] as? String) ?? ""))
                        }
                    } else {
                        debugPrint("\(TAG) - \(#function) - line : \(#line) - arrJson == nil")
                    }
                } else {
                    debugPrint("\(TAG) - \(#function) - line : \(#line) - jsonData == nil")
                }
            } catch {
                debugPrint("\(TAG) - \(#function) - line : \(#line) - error : \(error.localizedDescription)")
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

extension ChonBankQRYTeViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBanks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        let item = arrBanks[indexPath.row]
        cell.textLabel?.text = item.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _delegate = delegate {
            let item = arrBanks[indexPath.row]
            _delegate.suKienChonBank(item.0, sCode: item.1)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
