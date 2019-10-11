//
//  ChuyenTienNewViewController.swift
//  ViViMASS
//
//  Created by Tâm Nguyễn on 10/2/19.
//

import UIKit

class ChuyenTienNewViewController: GiaoDichViewController {

    @IBOutlet var stackTop: UIStackView!
    @IBOutlet var viewMain: UIView!
    var viewCTVi:DucNT_ChuyenTienViDenViViewController!
    var viewCTTK:DucNT_ChuyenTienDenTaiKhoanViewController!
    var viewCTThe:DucNT_ChuyenTienDenTheViewController!
    var viewCTCMND:GiaoDienChuyenTienDenCMND!
    var indexOptions = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for item in stackTop.arrangedSubviews {
            if let btn = item as? UIButton, let lblTitle = btn.titleLabel {
                lblTitle.textAlignment = .center
                lblTitle.numberOfLines = 2
            }
        }
        self.updateBackgroundButton(indexOptions)
        self.khoiTaoChuyenTienDenVi()
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
    
    func khoiTaoChuyenTienDenVi() {
        if viewCTTK != nil {
            viewCTTK.view.isHidden = true
        }
        if viewCTThe != nil {
            viewCTThe.view.isHidden = true
        }
        if viewCTCMND != nil {
            viewCTCMND.view.isHidden = true
        }
        if viewCTVi == nil {
            viewCTVi = DucNT_ChuyenTienViDenViViewController(nibName: "DucNT_ChuyenTienViDenViViewController", bundle: nil)
            viewCTVi.view.frame = CGRect(x: 0, y: 0, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            self.viewMain.addSubview(viewCTVi.view)
        }
        viewCTVi.view.isHidden = false
    }
    
    func khoiTaoChuyenTienDenTaiKhoan() {
        if viewCTVi != nil {
            viewCTVi.view.isHidden = true
        }
        if viewCTThe != nil {
            viewCTThe.view.isHidden = true
        }
        if viewCTCMND != nil {
            viewCTCMND.view.isHidden = true
        }
        if viewCTTK == nil {
            viewCTTK = DucNT_ChuyenTienDenTaiKhoanViewController(nibName: "DucNT_ChuyenTienDenTaiKhoanViewController", bundle: nil)
            viewCTTK.view.frame = CGRect(x: 0, y: 0, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            self.viewMain.addSubview(viewCTTK.view)
        }
        viewCTTK.view.isHidden = false
    }
    
    func khoiTaoChuyenTienDenThe() {
        if viewCTTK != nil {
            viewCTTK.view.isHidden = true
        }
        if viewCTVi != nil {
            viewCTVi.view.isHidden = true
        }
        if viewCTCMND != nil {
            viewCTCMND.view.isHidden = true
        }
        if viewCTThe == nil {
            viewCTThe = DucNT_ChuyenTienDenTheViewController(nibName: "DucNT_ChuyenTienDenTheViewController", bundle: nil)
            viewCTThe.view.frame = CGRect(x: 0, y: 0, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            self.viewMain.addSubview(viewCTThe.view)
        }
        viewCTThe.view.isHidden = false
    }
    
    func khoiTaoChuyenTienDenCMND() {
        if viewCTTK != nil {
            viewCTTK.view.isHidden = true
        }
        if viewCTVi != nil {
            viewCTVi.view.isHidden = true
        }
        if viewCTThe != nil {
            viewCTThe.view.isHidden = true
        }
        if viewCTCMND == nil {
            viewCTCMND = GiaoDienChuyenTienDenCMND(nibName: "GiaoDienChuyenTienDenCMND", bundle: nil)
            viewCTCMND.view.frame = CGRect(x: 0, y: 0, width: self.viewMain.frame.width, height: self.viewMain.frame.height)
            self.viewMain.addSubview(viewCTCMND.view)
        }
        viewCTCMND.view.isHidden = false
    }

    @IBAction func suKienChonBack(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func suKienChonDenVi(_ sender: Any) {
        if indexOptions != 0 {
            indexOptions = 0
            updateBackgroundButton(indexOptions)
            khoiTaoChuyenTienDenVi()
        }
    }

    @IBAction func suKienChonDenTaiKhoan(_ sender: Any) {
        if indexOptions != 1 {
            indexOptions = 1
            updateBackgroundButton(indexOptions)
            khoiTaoChuyenTienDenTaiKhoan()
        }
    }
    
    @IBAction func suKienChonDenThe(_ sender: Any) {
        if indexOptions != 2 {
            indexOptions = 2
            updateBackgroundButton(indexOptions)
            khoiTaoChuyenTienDenThe()
        }
    }
    
    @IBAction func suKienChonDenCMND(_ sender: Any) {
        if indexOptions != 3 {
            indexOptions = 3
            updateBackgroundButton(indexOptions)
            khoiTaoChuyenTienDenCMND()
        }
    }
}
