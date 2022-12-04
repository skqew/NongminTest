//
//  CurrentWeatherViewController.swift
//  NongminTest
//
//  Created by 박은지 on 2022/11/29.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // XML parser
    var xmlDict = [String: Any]()
    var xmlDictArr:Array<[String:Any]> = []
    var currentElement = ""
    
    @IBOutlet weak var wn_T1: UILabel!  // 기온
    @IBOutlet weak var wn_T1D: UILabel!  // 기온차
    @IBOutlet weak var wn_Mn: UILabel!  // 일 최저기온
    @IBOutlet weak var wn_Mx: UILabel!  // 일 최고기온
    @IBOutlet weak var wn_Rh: UILabel!  // 습도
    @IBOutlet weak var wn_Wd: UILabel!  // 풍향
    @IBOutlet weak var wn_Ws: UILabel!  // 풍속
    @IBOutlet weak var wn_Pci1: UILabel!  // 강수량
    @IBOutlet weak var wn_icon: UIImageView!  // 날씨 아이콘
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(appDelegate.location ?? CLLocation(latitude: 0, longitude: 0), preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last?.subLocality
            else { return }
            DispatchQueue.main.async {
                print("")
            }
        }
        
        DispatchQueue.main.async {
            let xmlParser = XMLParser(contentsOf: URL(string: "http://20.200.184.193/api/CurrentWeather.do?lon=\(self.appDelegate.location?.coordinate.longitude)&lat=\(self.appDelegate.location?.coordinate.latitude)")!)
            xmlParser!.delegate = self
            xmlParser!.parse()
        }
        
        let item = self.xmlDictArr.first

        wn_T1.text = (item?["wn_T1"] as? String ?? "") + "℃"
        wn_T1D.text = "어제보다" + (item?["wn_T1D"] as? String ?? "") + " ℃↑"
        wn_Mn.text = "최저" + (item?["wn_Mn"] as? String ?? "") + "℃"
        wn_Mx.text = "최고" + (item?["wn_Mx"] as? String ?? "") + "℃"
        wn_Rh.text = (item?["wn_Rh"] as? String ?? "") + "%"
        wn_Wd.text = item?["wn_Wd"] as? String ?? ""
        wn_Ws.text = (item?["wn_Ws"] as? String ?? "") + "m/s"
        wn_Pci1.text = (item?["wn_Pci1"] as? String ?? "") + "mm"
        if let wn_icon = item?["wn_icon"] as? String{
            self.wn_icon.image = UIImage(named: "0\(wn_icon).png")
        }

    }
    

}


//MARK: - XMLParserDelegate
extension CurrentWeatherViewController: XMLParserDelegate {
    
    //MARK:- XML Parser
    
    // XML 파서가 시작 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
        
    }
    
    // XML 파서가 종료 테그를 만나면 호출됨
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            xmlDictArr.append(xmlDict)
        }
    }
    
    // 현재 테그에 담겨있는 문자열 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                xmlDict.updateValue(string, forKey: currentElement)
            }
        }
        
    }
    
    // 에러시, abortParsing()사용시
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error){
        print(parseError)
    }
    
    
}
