//
//  NhapDonHangYTeDongView.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/11/19.
//

import UIKit

class NhapDonHangYTeDongView: UIView {
    private let TAG = "NhapDonHangYTeDongView"
    @IBOutlet var tfTen: ExTextField!
    @IBOutlet var tfDonVI: ExTextField!
    @IBOutlet var tfSoLuong: ExTextField!
    @IBOutlet var tfDonGia: ExTextField!
    
    override var isHidden: Bool {
        didSet {
            if !self.isHidden {
                DispatchQueue.main.async {
                    self.tfTen.text = ""
                    self.tfDonVI.text = ""
                    self.tfSoLuong.text = ""
                    self.tfDonGia.text = ""
                }
            }
        }
    }
    class func instanceFromNib() -> NhapDonHangYTeDongView {
        return UINib(nibName: "NhapDonHangYTeDongView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! NhapDonHangYTeDongView
    }

    @IBAction func suKienChonHuy(_ sender: Any) {
        self.endEditing(true)
        self.isHidden = true
    }
    
    func checkValue() -> Bool {
        let arrCheck = [tfTen, tfDonVI, tfDonGia, tfSoLuong]
        let results = arrCheck.filter { (tf) -> Bool in
            return tf?.text?.isEmpty ?? true
        }
//        print("\(TAG) - \(#function) - \(#line) - results : \(results.count)")
        for item in results {
            if let tf = item {
                shakeTextField(tf)
                break
            }
        }
        return results.count > 0 ? false : true
    }
    
    @IBAction func suKienChonDongY(_ sender: Any) {
        self.endEditing(true)
        if checkValue() {
            self.isHidden = true
        } else {
            
        }
    }
    
    func shakeTextField(_ tf:UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: tf.center.x - 10, y: tf.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: tf.center.x + 10, y: tf.center.y))
        tf.layer.add(animation, forKey: "position")
    }
    
}
