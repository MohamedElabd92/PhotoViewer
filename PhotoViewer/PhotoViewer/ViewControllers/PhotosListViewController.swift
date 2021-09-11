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
    var photosData: [PhotosModel] = [PhotosModel]()
    var pageNumber = 1
    var isLoadingMore = false
    
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
            photosViewModel.getPhotosList(page: pageNumber)
            
        } else {
            getCachedData()
        }
    }
    
    func registerCells() {
        self.photosTableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
    }
    
    func getCachedData() {
        self.photosData.append(contentsOf: Utility.getSavedUserDefaults())
        self.addAdvertisementItems()
        self.photosTableView.reloadData()
        
        ProgressHUD.dismiss()
    }
    
    func showLoadMoreSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func addAdvertisementItems() {
        var newItems = [PhotosModel]()
        
        var index = 0
        for item in self.photosData {
            newItems.append(item)
            index += 1
            
            // Add Advertisement Item
            if index.isMultiple(of: 5) {
                let adItem = PhotosModel()
                adItem.isAdvertisementItem = true
                newItems.append(adItem)
            }
        }
        
        self.photosData = newItems
    }
    
}

extension PhotosListViewController: PhotosViewModelDelegate {
    func getPhotoListResponse(model: [PhotosModel]) {
        self.photosData.append(contentsOf: model)
        self.addAdvertisementItems()
        
        self.photosTableView.reloadData()
        self.photosTableView.tableFooterView = nil
        self.isLoadingMore = false
        
        ProgressHUD.dismiss()
    }
    
    func showErrorMessage(message: String) {
        self.showAlert(title: "", message: message)
        ProgressHUD.dismiss()
    }
}

extension PhotosListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as? PhotoTableViewCell {
            
            cell.setData(model: photosData[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }
}

extension PhotosListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore {
            let scrollViewOffset = scrollView.contentOffset.y
            let location = self.photosTableView.contentSize.height - scrollView.frame.size.height - 100

            if scrollViewOffset > location && Utility.checkConnection() {
                isLoadingMore = true
                photosTableView.tableFooterView = showLoadMoreSpinner()
                
                pageNumber += 1
                photosViewModel.getPhotosList(page: pageNumber)
            }
        }
    }
}
