//
//  SelectedPhotoViewController.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 11/09/2021.
//

import UIKit

class SelectedPhotoViewController: UIViewController {
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var photosData: PhotosModel? // = PhotosModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let download_url = photosData?.download_url, let image = imageCache.object(forKey: download_url as NSString) {
            self.selectedImageView.image = image
            self.selectedImageView.contentMode = .scaleAspectFit
            
            self.view.backgroundColor = getDominantColor()
            
        } else {
            
            if let model = photosData {
                
                if model.isAdvertisementItem ?? false {
                    self.selectedImageView.image = UIImage(named: "AdPlaceHolder")
                    self.selectedImageView.contentMode = .scaleAspectFit
                    self.view.backgroundColor = self.selectedImageView.image?.averageColor
                } else {
                    self.selectedImageView.download(model: model)
                }
            }
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
    
}
