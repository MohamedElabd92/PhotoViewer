//
//  PhotosListViewController.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit

class PhotosListViewController: UIViewController {
    
    var photosViewModel = PhotosViewModel()
    var photosData: [PhotosModel]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }

    func initialSetup() {
        
        photosViewModel.dataDelegate = self
        photosViewModel.getPhotosList()
        
    }

}

extension PhotosListViewController: PhotosViewModelDelegate {
    func getPhotoListResponse(model: [PhotosModel]) {
        print(model)
        self.photosData = model
    }
    
    func showErrorMessage(message: String) {
        print(message)
    }
}
