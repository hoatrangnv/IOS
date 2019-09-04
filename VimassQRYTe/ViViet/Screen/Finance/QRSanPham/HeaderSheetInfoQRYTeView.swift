//
//  HeaderSheetInfoQRYTeView.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class HeaderSheetInfoQRYTeView: UIView {

    class func instanceFromNib() -> HeaderSheetInfoQRYTeView {
        return UINib(nibName: "HeaderSheetInfoQRYTeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! HeaderSheetInfoQRYTeView
    }

}
