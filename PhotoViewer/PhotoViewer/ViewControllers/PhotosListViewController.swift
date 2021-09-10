//
//  PhotosListViewController.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit
import ProgressHUD

class PhotosListViewController: UIViewController {
    @IBOutlet weak var photosTableView: UITableView!
    
    var photosViewModel = PhotosViewModel()
    var photosData: [PhotosModel]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }

    func initialSetup() {
        ProgressHUD.show("Loading...")
        photosTableView.delegate = self
        photosTableView.dataSource = self
        registerCells()
        
        if Utility.checkConnection() {
            photosViewModel.dataDelegate = self
            photosViewModel.getPhotosList()
            
        } else {
            getCachedData()
        }
    }
    
    func registerCells() {
        self.photosTableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
    }
    
    func getCachedData() {
        
        ProgressHUD.dismiss()
    }
}

extension PhotosListViewController: PhotosViewModelDelegate {
    func getPhotoListResponse(model: [PhotosModel]) {
        self.photosData = model
        self.photosTableView.reloadData()
        
        ProgressHUD.dismiss()
    }
    
    func showErrorMessage(message: String) {
        self.showAlert(title: "", message: message)
        ProgressHUD.dismiss()
    }
}

extension PhotosListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = photosTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as? PhotoTableViewCell {

            if let data = photosData?[indexPath.row] {
                cell.setData(model: data)
            }
            return cell
         }
         return UITableViewCell()
    }
}
