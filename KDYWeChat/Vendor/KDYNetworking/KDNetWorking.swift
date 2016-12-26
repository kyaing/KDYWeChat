//
//  KDNetWorking.swift
//  KDYWeChat
//
//  Created by mac on 16/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation
import Alamofire

enum RequestType {
    case Post
    case Get
    case Put
}

typealias ValuesClosure = (AnyObject?, NSError?) -> Void

class KDNetWorking: NSObject {

    static let share = KDNetWorking()

    fileprivate override init() {
        super.init()
    }

    func request(type: RequestType,
                 urlString: String,
                 parameter: [String: AnyObject]?,
                 block: @escaping ValuesClosure) {

        switch type {
        case .Post:
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    block(response.result.value as AnyObject?, nil)
                }

        case .Get:
            Alamofire.request(urlString, method: .get, parameters: parameter)
                .responseJSON { response in
                    block(response.result.value as AnyObject?, nil)
                }

        default:
            return
        }
    }
}

