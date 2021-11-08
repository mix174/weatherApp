//
//  JsonParamsEncoder.swift
//  weatherApp
//
//  Created by Mix174 on 05.08.2021.
//

import UIKit

struct ParamsEncodable: Encodable {
    var lon: Double?
    var lat: Double?
    var q: String?
    let units = "metric"
    let lang = "ru"
    let appid = "45edc494a20ba962104df229852f3058"
    
    init(longitude: Double, latitude: Double) {
        self.lon = longitude
        self.lat = latitude
    }
    init(city: String) {
        self.q = city
    }
}
