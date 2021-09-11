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
        } else if let url = model.download_url {
            autherLabel.text = model.author
            downloadedImageView.download(urlString: url)
        }
    }
}
