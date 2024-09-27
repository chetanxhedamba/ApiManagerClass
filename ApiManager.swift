
import Foundation
import Alamofire
import SVProgressHUD
final class ApiManager{
    
    func callAPIWithMultipart<T : Decodable>(apiUrl : String,parameter : [String : Any],image: UIImage,resultType: T.Type,completionHandler:@escaping(T?)-> Void)-> Void {
        // Create a multipart form data upload request
        AF.upload(multipartFormData: { multipartFormData in
            
            
            for i in parameter{
                multipartFormData.append("\(i.value)".data(using: .utf8)!, withName: i.key)
            }
            
            // Append the image data
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "profile_photo", fileName: "profile_photo.jpg", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).responseJSON { response in
            switch response.result {
            case .success(let responseData):
                print("Success with value: \(responseData)")
                if let responseDict = responseData as? [String: Any] {
                    
                    print(responseDict)
                    //                        setUserPreference(responseDict, forKey: "UserData")
                    do {
                        // Convert dictionary to Data
                        let data = try JSONSerialization.data(withJSONObject: responseDict, options: [])
                        
                        // Decode Data into UserModel
                        let jsonModel = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(jsonModel)
                        
                    } catch {
                        print("Error parsing response: \(error)")
                        completionHandler(nil)
                    }
                    
                }
            case .failure(let error):
                print("Error: \(error)")
                completionHandler(nil)
            }
        }
    }
    
    
    
    func callApi<T: Codable>(apiUrl: String, method: HTTPMethod, parameters: [String: Any]?,resultType : T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        
        AF.request(apiUrl, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .responseJSON(completionHandler: { response in
                
                switch response.result {
                    
                    
                case let .success(responseData):
                    
                    if let responseDict = responseData as? [String: Any] {
                        
                        print(responseDict)
                        //                        setUserPreference(responseDict, forKey: "UserData")
                        do {
                            // Convert dictionary to Data
                            let data = try JSONSerialization.data(withJSONObject: responseDict, options: [])
                            
                            // Decode Data into UserModel
                            let jsonModel = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(jsonModel))
                            
                        } catch {
                            print("Error parsing response: \(error)")
                            completion(.failure(error))
                        }
                        
                    }
                case let .failure(error):
                    let nsError = error as NSError
                    let errorMsg = nsError.localizedDescription
                    let errorCode = nsError.code
                    
                    print("\n============ Response ============")
                    print("ErrorCode  :- \(errorCode)")
                    print("ErrorMsg   :- \(errorMsg)")
                    print("====================================\n")
                    completion(.failure(error))
                }
            })
        
        
    }
}


struct Endpoint
{
    static let registerUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser"
    static let getUser = "https://api-dev-scus-demo.azurewebsites.net/api/User/GetUser"
    
    static let itunesApi = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topMovies/json"
    
    static let getVideos = "https://drive.google.com/uc"
    static let imageBasePath = "http://commondatastorage.googleapis.com/gtv-videos-bucket/"
}

//Usw of callApi Func
//func getVideoList()  {
//    ApiManager().callApi(apiUrl: Endpoint.getVideos, method: .get, parameters: ["id" : "1FEOTw_ioZ4SR4Iq5UxqsqcEgKAg3bNtX"], resultType: VideoListResponseModel.self) { result in
//        switch result {
//        case .success(let obj):
//            self.arrVideos = obj.categories.first?.videos ?? []
//            DispatchQueue.main.async {
//                self.tblview.reloadData()
//            }
//            break
//        case .failure(let error):
//            print(error)
//            break
//        default:
//            break
//        }
//    }
//}
