//
//  PhotoTableViewCell.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var downloadedImageView: UIImageView!
    
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
        downloadedImageView.image = UIImage(named: "ImagePlaceHolder")
        downloadedImageView.contentMode = .center
    }
    
    func initialSetup() {
        containerView.dropShadow()
        containerView.setCornerRadius(value: 5)
        downloadedImageView.image = UIImage(named: "ImagePlaceHolder")
        
    }
    
    func setData(model: PhotosModel) {
        if model.isAdvertisementItem ?? false {
            autherLabel.text = ""
            downloadedImageView.image = UIImage(named: "AdPlaceHolder")
            downloadedImageView.contentMode = .scaleAspectFit
            
            return
        }
        
        for item in Utility.getSavedUserDefaults() where item.id == model.id {
            autherLabel.text = item.author
            
            if let data = item.downloadedImage {
                downloadedImageView.image = UIImage(data: data)
                downloadedImageView.contentMode = .scaleAspectFit
            }
            
            return
        }
        
        
        autherLabel.text = model.author
        downloadedImageView.download(model: model)
    }
}
