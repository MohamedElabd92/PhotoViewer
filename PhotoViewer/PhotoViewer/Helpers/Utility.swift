//
//  Utility.swift
//  PhotoViewer
//
//  Created by Mohamed Elabd on 11/09/2021.
//

import Foundation
import SystemConfiguration

class Utility {
    static func checkConnection() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func saveToUserDefaults(data: [PhotosModel]) {
         let encoder = JSONEncoder()
         if let encoded = try? encoder.encode(data){
            UserDefaults.standard.set(encoded, forKey: "CachedData")
            UserDefaults.standard.synchronize()
         }
    }
    
    static func getSavedUserDefaults() -> [PhotosModel] {
        let photosModel = PhotosModel()
        if let objects = UserDefaults.standard.value(forKey: "CachedData") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [PhotosModel] {
                return objectsDecoded
            } else {
                return [photosModel]
            }
        } else {
            return []
        }
    }
}
