//
//  SelectedPhotoViewController.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 11/09/2021.
//

import UIKit

class SelectedPhotoViewController: UIViewController {
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var photosData: PhotosModel?
    let defaultPlacholderImage = UIImage(named: "ImagePlaceHolder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = self.photosData, let url = model.download_url {
            if let image = imageCache.object(forKey: url as NSString) {
                self.selectedImageView.image = image
            } else {
                if let image = photosData?.downloadedImage {
                    self.selectedImageView.image = UIImage(data: image)
                    
                } else {
                    selectedImageView.image = defaultPlacholderImage
                    self.view.backgroundColor = self.getDominantColor()
                    
                    downloadImage(urlString: url, model: model) { imageData in
                        if let imageData = imageData {
                            self.selectedImageView.image = UIImage(data: imageData)
                            self.view.backgroundColor = self.getDominantColor()
                        }
                    }
                }
            }
            
            self.view.backgroundColor = self.getDominantColor()
            
        } else if photosData?.isAdvertisementItem ?? false {
            selectedImageView.image = UIImage(named: "AdPlaceHolder")
            self.view.backgroundColor = self.getDominantColor()
        } else {
            selectedImageView.image = defaultPlacholderImage
            self.view.backgroundColor = self.getDominantColor()
        }
    }
  
    func getDominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self.selectedImageView.image ?? UIImage()) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func downloadImage(urlString: String, model: PhotosModel, completion: @escaping (_ response: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, _) -> Void in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Image downloaded successfully. url = \(urlString)")
                        } else {
                            print("Failed to download image. url = \(urlString)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if let data = data {
                            completion(data)
                        }
                    }
                    
                }.resume()
            }
        }
    }
    
}
