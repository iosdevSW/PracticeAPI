//
//  ViewController.swift
//  WeatherAPI
//
//  Created by 신상우 on 2022/02/05.
//

import UIKit
import Alamofire



class ViewController: UIViewController {
    var time: BaseTime = .five
    
    var date: String = {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        
        return formatter.string(from: date)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weather = WeatherModule()
        weather.callAPI(date: self.date, baseTime: self.time.rawValue)
    }
    
    enum BaseTime: String{
        case two = "0200"
        case five = "0500"
        case eight = "0800"
        case eleven = "1100"
        case fourteen = "1400"
        case seventeen = "1700"
        case twenty = "2000"
        case twentyThree = "2300"
    }
}


