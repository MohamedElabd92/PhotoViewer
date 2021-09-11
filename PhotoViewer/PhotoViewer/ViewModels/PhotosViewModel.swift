//
//  PhotosViewModel.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import Foundation
import Alamofire

protocol PhotosViewModelDelegate: AnyObject {
    func getPhotoListResponse(model: [PhotosModel])
    func showErrorMessage(message: String)
}

class PhotosViewModel {
    
    var dataDelegate: PhotosViewModelDelegate?
    
    func getPhotosList(page: Int) {
        var url = Constants.photosApiUrl
        url.append("?page=\(page)&limit=10")
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else {return}
            self.printResponse(res: response, url: url)
            
            do {
                switch response.result {
                case .success:
                    let model = try JSONDecoder().decode([PhotosModel].self, from: data)
                    self.dataDelegate?.getPhotoListResponse(model: model)
                    
                case let .failure(error):
                    print(error)
                    self.dataDelegate?.showErrorMessage(message: error.errorDescription ?? "")
                }
                
            } catch {
                print(error)
                self.dataDelegate?.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func printResponse(res: AFDataResponse<Any>, url: String) {
        if let value = res.value {
            print("------- \(url)")
            print("------- response")
            print(value)
        }
    }
    
}
