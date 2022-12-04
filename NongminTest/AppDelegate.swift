//
//  AppDelegate.swift
//  NongminTest
//
//  Created by 박은지 on 2022/11/24.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var location:CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let locationManager = CLLocationManager()

        // 위경도값 가져오기
//        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization() // 사용자에게 허용 여부 Alert
        
        DispatchQueue.main.async {
            // 아이폰 설정에서 위치 서비스가 켜진 상태라면
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                print(locationManager.location?.coordinate ?? "")
                locationManager.startUpdatingLocation() // 위치 정보 받아오기 시작
                self.location = locationManager.location
            } else {
                print("위치 서비스 Off 상태")
            }
        }
        
        return true
    }


}



//MARK: - CLLocationManagerDelegate
//extension AppDelegate: CLLocationManagerDelegate {
//
//    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        print("didUpdateLocations")
//        if let location = locations.first {
//
//            self.latitude = String(location.coordinate.latitude)
//            self.longitude = String(location.coordinate.longitude)
//
//            print("위도 : \(location.coordinate.latitude)")
//            print("경도 : \(location.coordinate.longitude)")
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//}
