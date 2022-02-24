//
//  WeatherModule.swift
//  WeatherAPI
//
//  Created by 신상우 on 2022/02/24.
//

import UIKit
import Alamofire

class WeatherModule {
    
    // API 요청 주소
    private let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
    
    // 인증키
    private let serviceKey = "gg0tDMzz84/nTyjdkyZdTQRu2QiQ/3PVTT/4/+T6QYCak7+fbxl2PhXiCneZf8yRBUMDtabOJNsOzV6nXCP1iA=="
    
    // Decodable 응답받을 형식
    struct DecodableType: Decodable {
        var response: Response?
        
        struct Response: Decodable {
            var header: Header
            var body: Body?
            struct Header: Decodable {
                var resultCode: String
                var resultMsg: String
            }
            
            struct Body: Decodable {
                var items: Items
                var numOfRows: Int
                var pageNo: Int
                var totalCount: Int
                var dataType: String
                
                struct Items: Decodable {
                    var item: [Item]
                    
                    struct Item: Decodable {
                        var baseDate: String
                        var baseTime: String
                        var nx: Int
                        var ny: Int
                        var category: String
                        var fcstDate: String
                        var fcstTime: String
                        var fcstValue: String
                    }
                }
            }
        }
    }
    
    func callAPI(date: String, baseTime: String) {
        // 요청 파라미터
        let param: Parameters = [
            "serviceKey" : self.serviceKey,
            "dataType" : "JSON",
            "numOfRows" : 24,
            "pageNo" : 1,
            "base_date" : date,
            "base_time" : baseTime,
            "nx" : 60,
            "ny" : 127
        ]
        
        // API 요청
        let call = AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default)
        
        // API 응답
        call.responseDecodable(of: DecodableType.self){ response in
            switch response.result { // 호출 성공
            case .success(let value):
                if let items = value.response?.body?.items {
                    let item = items.item
                    for element in item {
                        self.divideCategory(category: element.category, value: element.fcstValue, fcstTime: element.fcstTime)
                    }
                } else {
                    guard let resultMsg = value.response?.header.resultMsg else { return }
                    print(resultMsg)
                }
            case .failure(let error): // 호출 실패
                print("ERROR : \(error.localizedDescription)")
            }
        }
    }
    
    private func divideCategory(category: String, value: String, fcstTime: String) {
        switch(category){
        case "POP" : print("\(fcstTime)시에 비올 확률은 \(value)% 입니다.")
        case "TMP" : print("\(fcstTime)시 기온은 \(value) 도 입니다.")
        case "SKY" :
            switch Int(value)! {
            case 0...5 : print("오늘은 맑음입니다.")
            case 6...8 : print("오늘은 구름많음입니다.")
            default: print("오늘은 흐림입니다.")
            }
        default:
            break
        }
    }
}
