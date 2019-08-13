//
//  ShowImageSanPhamCell.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 7/18/19.
//

import UIKit

class ShowImageSanPhamCell: UITableViewCell {

    @IBOutlet var imgvSanPham: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var arrImage = [String]()
    var indexImage = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ImagePreviewSanPhamCell", bundle: nil), forCellWithReuseIdentifier: "ImagePreviewSanPhamCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func showImage() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        if indexImage >= arrImage.count {
            return
        }
        let link = arrImage[indexImage]
        imgvSanPham.sd_setImage(with: URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(link)"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ShowImageSanPhamCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigt = collectionView.frame.size.height
        return CGSize(width: heigt, height: heigt)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePreviewSanPhamCell", for: indexPath) as! ImagePreviewSanPhamCell
        let link = arrImage[indexPath.row]
        cell.imgvPreview.sd_setImage(with: URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(link)"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = arrImage[indexPath.row]
        imgvSanPham.sd_setImage(with: URL(string: "https://vimass.vn/vmbank/services/media/getImage?id=\(link)"))
    }
}
