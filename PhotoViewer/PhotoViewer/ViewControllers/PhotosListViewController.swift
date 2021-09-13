//
//  PhotosListViewController.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import UIKit
import ProgressHUD

var imageCache = NSCache<NSString, UIImage>()

class PhotosListViewController: UIViewController {
    @IBOutlet weak var photosTableView: UITableView!
    
    var photosViewModel = PhotosViewModel()
    var photosData: [PhotosModel] = [PhotosModel]()
    var photosDataWithAds: [PhotosModel] = [PhotosModel]()
    var pageNumber = 1
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }

    func initialSetup() {
        ProgressHUD.show("Loading...")
        self.title = "Photo Viewer"
        photosTableView.delegate = self
        photosTableView.dataSource = self
        registerCells()
        
        if Utility.checkConnection() {
            photosViewModel.dataDelegate = self
            photosViewModel.getPhotosList(page: pageNumber)
            
        } else {
            self.title = "Photo Viewer (Offline Mode)"
            getSavedData()
        }
    }
    
    func registerCells() {
        self.photosTableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
    }
    
    func getSavedData() {
        let savedImages = Utility.getSavedUserDefaults()
        
        if savedImages.isEmpty {
            self.showAlert(title: "No Saved Data", message: "Please check your internet connection.")
        } else {
            self.photosData.append(contentsOf: savedImages)
            self.addDownloadedImageToModel()
            self.addAdvertisementItems()
            self.photosTableView.reloadData()
        }
        
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
    
    func addDownloadedImageToModel() {
        var newItems = [PhotosModel]()
        var index = 0
        
        for item in self.photosData {
            if let url = item.download_url, item.downloadedImage == nil {
                if let image = imageCache.object(forKey: url as NSString) {
                    item.downloadedImage = image.pngData()
                } else {
                    downloadImage(urlString: url, model: item, index: index) { image in
                        item.downloadedImage = image
                    }
                }
            }
            newItems.append(item)
            index += 1
        }
        
        self.photosData = newItems
    }
    
    func addAdvertisementItems() {
        photosDataWithAds = [PhotosModel]()
        
        for item in photosData.splitInto(size: 5) {
            photosDataWithAds.append(contentsOf: item)
            let adItem = PhotosModel()
            adItem.isAdvertisementItem = true
            photosDataWithAds.append(adItem)
        }
    }
    
    func downloadImage(urlString: String, model: PhotosModel, index: Int, completion: @escaping (_ response: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, _) -> Void in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Image downloaded successfully. url = \(urlString)")
                        } else {
                            print("Failed to download image. url = \(urlString)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if let data = data {
                            completion(data)
                            imageCache.setObject(UIImage(data: data) ?? UIImage(), forKey: (model.download_url ?? "") as NSString)
                            self.userdefaultsCaching(model: model, imageData: data)
                            self.photosTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
                        }
                    }
                    
                }.resume()
            }
        }
    }
    
    func userdefaultsCaching(model: PhotosModel,imageData: Data) {
        var isItemFound = false
        var allItems = Utility.getSavedUserDefaults()
        
        if allItems.count < 20 { // cache only 20 items
            for item in allItems where item.id == model.id {
                isItemFound = true
            }
            
            if !isItemFound {
                allItems.append(model)
                Utility.saveToUserDefaults(data: allItems)
            }
        }
    }
}

extension PhotosListViewController: PhotosViewModelDelegate {
    func getPhotoListResponse(model: [PhotosModel]) {
        self.photosData.append(contentsOf: model)
        self.addDownloadedImageToModel()
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
        return self.photosDataWithAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as? PhotoTableViewCell {
            cell.dataDelegate = self
            cell.setData(model: photosDataWithAds[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }    
}

extension PhotosListViewController: PhotoTableViewCellDelegate {
    func imageDidTappedAction(model: PhotosModel?) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedPhotoViewController") as? SelectedPhotoViewController {
            
            vc.photosData = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PhotosListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && !photosData.isEmpty {
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
