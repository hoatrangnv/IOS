//
//  MyConnection.swift
//  FoodCategories
//
//  Created by Tâm Nguyễn on 1/10/17.
//  Copyright © 2017 Tâm Nguyễn. All rights reserved.
//

import Foundation
import UIKit

public struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 26
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class MyConnection {
    typealias CompletionHandler = (_ error:Error?, _ duLieu:Data?) ->Void
    
    func convertToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (fahrenheit - 32.0))
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func connectGet(url:URL, completion:@escaping CompletionHandler) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.timeoutInterval = 60.0
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let responseData = data else {
                completion(error, nil)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            debugPrint("\(#function) - \(url.absoluteString) - statusCode : \(statusCode)")
            if statusCode == 200 {
                completion(error, responseData)
            }
            else {
                completion(error, nil)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    static func connectPost(url:URL, jsonString:String, completion:@escaping CompletionHandler) -> Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.timeoutInterval = 90.0
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let responseData = data else {
                completion(error, nil)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                completion(error, responseData)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    static func connectPostJSONWithTask(url:URL, jsonData:Data, completion:@escaping CompletionHandler) -> URLSessionDataTask {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.timeoutInterval = 90.0
        urlRequest.httpMethod = "POST"
        let session = URLSession.shared
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let responseData = data else {
                completion(error, nil)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print("statusCode : \(statusCode)")
            if statusCode == 200 {
                completion(error, responseData)
            }
            else {
                completion(error, nil)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
        return task
    }
    
    static func getStringFromUserDefault(key:String) -> String? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key) as? String
    }

    static func saveStringToUserDefault(key:String, value:String) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func getBooleanFromUserDefault(key:String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey:key)
    }
    
    static func saveBooleanToUserDefault(key:String, value:Bool) -> Void {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func saveObjectToUserDefault(key:String, value:Any?) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func getObjectFromUserDefault(key:String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey:key)
    }
}

extension String {
    func deleteHTMLTag(_ tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
