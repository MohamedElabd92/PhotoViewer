//
//  Extensions.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func setCornerRadius(value: CGFloat) {
        layer.cornerRadius = value
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func download(urlString: String) {
        if let url = URL(string: urlString) {
            
            if let image = imageCache.object(forKey: urlString as NSString) {
                self.image = image
                self.contentMode = .scaleAspectFit
                return
            }
            
            URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, _) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Image downloaded successfully.")
                    } else {
                        print("Failed to download image.")
                    }
                }
                
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                        self.contentMode = .scaleAspectFit
                        
                        if let image = self.image {
                            imageCache.setObject(image, forKey: urlString as NSString)
                        }
                    }
                }
            }.resume()
        }
    }
}
