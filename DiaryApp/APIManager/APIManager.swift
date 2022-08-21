//
//  APIManager.swift
//  DiaryApp
//
//  Created by 윤여진 on 2022/08/21.
//

import UIKit

import Alamofire
import SwiftyJSON

class unsplashAPIManager {
    static let shared = unsplashAPIManager()
    
    private init() { }
    
    func requestUnsplashImage(_ page: Int, _ query: String, completionHandler: @escaping ([String], Int) -> ()) {
        
        let url = "https://api.unsplash.com/search/photos?page=\(page)&per_page=20&query=\(query)&client_id=\(APIKey.unsplash)"
        
        AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let imageList = json["results"].arrayValue.map { $0["urls"]["regular"].stringValue }
                
                let total = json["total_pages"].intValue
                
                
                completionHandler(imageList, total)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
