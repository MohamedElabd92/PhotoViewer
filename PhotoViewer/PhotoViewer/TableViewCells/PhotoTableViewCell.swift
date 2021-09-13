//
//  PhotoTableViewCell.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit
import SDWebImage
import AMShimmer

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
            downloadImage()
        }
        
        downloadedImageView.contentMode = .scaleAspectFit
    }
    
    @objc func imageDidTapped() {
        dataDelegate?.imageDidTappedAction(model: self.model)
    }
    
    func downloadImage() {
        if let url = URL(string: self.model?.download_url ?? "") {
            AMShimmer.start(for: downloadedImageView)
            
            self.downloadedImageView.sd_setImage(with: url, completed: {[weak self] (image, error, _, _) in
                guard let self = self else { return }
                if error != nil {
                    self.downloadedImageView.image = self.defaultPlacholderImage
                }
                
                if let image = image {
                    self.userdefaultsCaching(image: image)
                }
                
                AMShimmer.stop(for: self.downloadedImageView)
            })
        } else {
            downloadedImageView.image = defaultPlacholderImage
        }
    }
        
    func userdefaultsCaching(image: UIImage) {
        var isItemFound = false
        var allItems = Utility.getSavedUserDefaults()
        
        if allItems.count < 20 { // cache only 20 items
            for item in allItems where item.id == self.model?.id {
                isItemFound = true
            }
            
            if !isItemFound {
                if let newItem = self.model {
                    newItem.downloadedImage = image.pngData()
                    allItems.append(newItem)
                }
                Utility.saveToUserDefaults(data: allItems)
            }
        }
    }
}
