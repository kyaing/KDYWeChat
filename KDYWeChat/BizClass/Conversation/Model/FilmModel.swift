//
//  FilmModel.swift
//  KDYWeChat
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation
import ObjectMapper

class FilmModel: Mappable {
    
    var name: String?
    var wk:String?
    var wboxoffice: String?
    var tboxoffice: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        name       <- map["name"]
        wk         <- map["wk"]
        wboxoffice <- map["wboxoffice"]
        tboxoffice <- map["tboxoffice"]
    }
}

