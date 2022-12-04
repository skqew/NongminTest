//
//  ViewController.swift
//  NongminTest
//
//  Created by 박은지 on 2022/11/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
//        let url = "http://20.200.184.193/api/HourlyWeather.do?lon=\(locationManager.location?.coordinate.longitude ?? 0)&lat=\(locationManager.location?.coordinate.latitude ?? 0)"
//
//        self.apiRequest(apiUrl: url, completion: {jsonDic in
//            print(jsonDic)
//
//
//        })
                
    }

    
    //MARK: API 통신
    func apiRequest(apiUrl:String, completion: @escaping (Any) -> Void){
        
        if let url = URL(string: apiUrl){
            var request : URLRequest = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.httpShouldHandleCookies = false
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        print("HTTP Error1: \(error! as NSError)" )
                        let errorCode = (error! as NSError).code
                        let errorMSG = ["code:\(errorCode)":error?.localizedDescription]
                        completion(errorMSG)
                        return
                    }
                    do {
                        print("res : \(String(describing: response))")
                        let jsonDic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                        print("Response : \(jsonDic.debugDescription)")
                        completion(jsonDic ?? [:])
                    } catch {
                        print("HTTP Error2: \(error as NSError)" )
                        let backToString = (String(data: data, encoding: String.Encoding.utf8) ?? "")
                        print("data : " + backToString)
                        let errorCode = (error as NSError).code
                        let errorMSG = ["code:\(errorCode)":error.localizedDescription]
                        completion(errorMSG)
                    }
                }
            }
            task.resume()
            
        }else{
            completion("urlError")
        }
        
    }
    
    
}

