//
//  PhotosModel.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import Foundation

class PhotosModel: Codable {
    // API response variables
    var id: String?
    var author: String?
    var width: Double?
    var height: Double?
    var url: String?
    var download_url: String?
    
    // Custom variables
    var isAdvertisementItem: Bool?
    var downloadedImage: Data?
}
