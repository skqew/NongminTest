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
        
        let locationManager = CLLocationManager()

        // 위경도값 가져오기
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization() // 사용자에게 허용 여부 Alert
        
        DispatchQueue.main.async {
            // 아이폰 설정에서 위치 서비스가 켜진 상태라면
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                print(locationManager.location?.coordinate ?? "")
                locationManager.startUpdatingLocation() // 위치 정보 받아오기 시작
            } else {
                print("위치 서비스 Off 상태")
            }
        }
        
        let url = "http://20.200.184.193/api/HourlyWeather.do?lon=\(locationManager.location?.coordinate.longitude ?? 0)&lat=\(locationManager.location?.coordinate.latitude ?? 0)"
        
        self.apiRequest(apiUrl: url, completion: {jsonDic in
            print(jsonDic)

            
        })
                
    }

    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations")
        if let location = locations.first {
//            lati = Int(location.coordinate.latitude)
//            longi = Int(location.coordinate.longitude)

            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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

