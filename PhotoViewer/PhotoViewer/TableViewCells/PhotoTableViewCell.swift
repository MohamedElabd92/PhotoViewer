//
//  PhotoTableViewCell.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit

protocol PhotoTableViewCellDelegate: AnyObject {
    func imageDidTappedAction(model: PhotosModel?)
}

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var downloadedImageView: UIImageView!
    
    var model: PhotosModel?
    var dataDelegate: PhotoTableViewCellDelegate?
    let defaultPlacholderImage = UIImage(named: "ImagePlaceHolder")
    let adPlaeholderImage = UIImage(named: "AdPlaceHolder")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        autherLabel.text = ""
        downloadedImageView.image = defaultPlacholderImage
        downloadedImageView.contentMode = .center
    }
    
    func initialSetup() {
        containerView.dropShadow()
        containerView.setCornerRadius(value: 5)
        downloadedImageView.image = defaultPlacholderImage
        
    }
    
    func setData(model: PhotosModel) {
        self.model = model
        downloadedImageView.isUserInteractionEnabled = true
        downloadedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageDidTapped)))
        
        if model.isAdvertisementItem ?? false {
            autherLabel.text = ""
            downloadedImageView.image = adPlaeholderImage
        } else {
            autherLabel.text = model.author
            
            if let image = imageCache.object(forKey: (model.download_url ?? "") as NSString) {
                self.downloadedImageView.image = image
            } else {
                if let image = model.downloadedImage {
                    self.downloadedImageView.image = UIImage(data: image)
                }
            }
        }
        
        downloadedImageView.contentMode = .scaleAspectFit
    }
    
    @objc func imageDidTapped() {
        dataDelegate?.imageDidTappedAction(model: self.model)
    }
}
