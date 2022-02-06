//
//  ViewController.swift
//  WeatherAPI
//
//  Created by 신상우 on 2022/02/05.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"
        
        let serviceKey = "gg0tDMzz84/nTyjdkyZdTQRu2QiQ/3PVTT/4/+T6QYCak7+fbxl2PhXiCneZf8yRBUMDtabOJNsOzV6nXCP1iA=="
        
        let param: Parameters = [
            "serviceKey" : serviceKey,
            "dataType" : "JSON",
            "numOfRows" : 10,
            "pageNo" : 1,
            "base_date" : "20220206",
            "base_time" : "1700",
            "nx" : 60,
            "ny" : 127
        ]
        
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
        
        let call = AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default)
        
//        call.responseJSON(){ res in
//            print(res.value)
//        }
        
        call.responseDecodable(of: DecodableType.self){ response in
            switch response.result {
            case .success(let value):
                if let items = value.response?.body?.items {
                    print(items)
                }
            case .failure(let error):
                print("ERROR : \(error.localizedDescription)")
            }
        }
    }


}

