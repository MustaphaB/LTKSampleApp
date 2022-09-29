//
//  NetworkManager.swift
//  LTKProject
//
//  Created by Mustapha Barrie on 9/28/22.
//

import Foundation
import Alamofire

///TODO: Update for pagnation calls

class NetworkManager{
    
    private static let endpoint = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=20"
    
    
    static func getLTKData(completion: @escaping (LTKDataResponse)->Void){
        AF.request(endpoint, method: HTTPMethod.get).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let ltkResponse = try? jsonDecoder.decode(LTKDataResponse.self, from: data){
                    completion(ltkResponse)
                }else{
                    print("Invalid response data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchImage(imageURL: String, completion: @escaping(UIImage) -> Void){
        AF.request(imageURL, method: HTTPMethod.get).validate().responseData { response in
            switch response.result{
            case .success(let data):
                if let heroImage = UIImage(data: data){
                    completion(heroImage)
                }else{
                    print("Unable to retrieve image")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
