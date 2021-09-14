# PhotoViewer
After cloning the repository run **pod install** command then open PhotoViewer.xcworkspace  
App developed using XCode 12.5.1 and Swift 5

### Features
- Checking for internet connection.  
- Integration with [Photos API](https://picsum.photos/v2/list).  
- Caching data after calling api: using UserDefualts for offline mode, and using NSCache for runtime cache.  
- Offline mode if the data was cached.  
- Main screen displays list of images, auther names and ads placeholder every 5 images.  
- Details screen displays the selected image and the dominant background color.  
- Unit testing for adding ads items.  

### CocoaPods Used
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ProgressHUD](https://github.com/relatedcode/ProgressHUD)
