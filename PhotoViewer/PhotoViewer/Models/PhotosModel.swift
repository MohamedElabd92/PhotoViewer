//
//  PhotosModel.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import Foundation

class PhotosModel: Codable {
    var id: String?
    var author: String?
    var width: Double?
    var height: Double?
    var url: String?
    var download_url: String?
    var isAdvertisementItem: Bool?
    var downloadedImage: Data?
}
