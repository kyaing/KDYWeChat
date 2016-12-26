//
//  KDConfigs.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/12/23.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation

typealias KDRequestClosure  = (_ request: KDRequest) -> Void

typealias KDSuccessClosure  = (_ responseObject: AnyObject?) -> Void
typealias KDErrorsClosure   = (_ error: NSError?) -> Void

typealias KDFinishedClosure = (_ responseObject: AnyObject?, _ error: NSError?) -> Void
typealias KDCancelClosure   = (_ cancelRequest: KDRequest) -> Void

/// HTTP的请求方法
enum HTTPMethodType {
    case Post
    case Get
    case Put
    case Delete
}

/// 网络请求的方法
enum RequestType {
    case Normal  // HTTPMethodType
    case Upload
    case Download
}

/// 请求方法(Post)的编码方式
enum RequestSerializerType {
    case Normal // Content-Type = "application/x-www-form-urlencoded"
    case JSON   // Content-Type = "application/json"
    case Plist  // Content-Type = "application/x-plist"
}

/// 响应数据的编码方式
enum ResponseSerializerType {
    case Normal
    case Data
    case String
    case JSON
    case Plist
}

