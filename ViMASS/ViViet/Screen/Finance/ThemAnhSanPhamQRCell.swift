//
//  ThemAnhSanPhamQRCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/8/19.
//

import UIKit

protocol ThemAnhSanPhamQRCellDelegate {
    func suKienDeleteImage(_ index:Int)
}

class ThemAnhSanPhamQRCell: UITableViewCell {
    private let TAG = "ThemAnhSanPhamQRCell"
    var arrImage = [UIImage]()
    @IBOutlet var imgvPreview: UIImageView!
//    @IBOutlet var tableView: UITableView!
    var delegate:ThemAnhSanPhamQRCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        tableView.register(UINib(nibName: "ListImageSanPhamQRCell", bundle: nil), forCellReuseIdentifier: "ListImageSanPhamQRCell")
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    func showAnhPreview() {
        if arrImage.count > 0 {
            imgvPreview.image = arrImage.last
        }
//        tableView.reloadData()
    }
    
    @objc func suKienChonDeleteImage(_ sender:UIButton) {
//        if let cell = sender.superview?.superview as? ListImageSanPhamQRCell, let delegate = self.delegate, let indexPath = tableView.indexPath(for: cell) {
//            delegate.suKienDeleteImage(indexPath.row)
//        }
    }
}

//extension ThemAnhSanPhamQRCell : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrImage.count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.size.width
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListImageSanPhamQRCell", for: indexPath) as! ListImageSanPhamQRCell
//        cell.imgvPreview.image = arrImage[indexPath.row]
//        cell.btnDelete.addTarget(self, action: #selector(suKienChonDeleteImage(_:)), for: .touchUpInside)
//        return cell
//    }
//}
