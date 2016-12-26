//
//  KDNetworkingRequest.swift
//  KDYWeChat
//
//  Created by kaideyi on 2016/12/23.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation

class KDRequest: NSObject {
    
    // MARK: - Parameters

    // 服务器基地址；如 https://www.server.com/
    let server: String? = nil

    // api，拼接上server地址
    let api: String? = nil
    
    // 完整的url地址
    let url: String? = nil
    
    // 请求参数
    let parameters: [String: AnyObject] = [:]
    
    // 请求头；比如用于注入cookie等
    let headers: [String: AnyObject] = [:]
    
    // HTTP请求方法；默认为 Post
    let httpMethodType: HTTPMethodType = .Post
    
    // 网络请求类型；默认为 httpMethodType
    let requestType: RequestType = .Normal
    
    // 请求参数序列化
    let requestSerializerType: RequestSerializerType = .Normal
    
    // 响应结果序列化
    let responseSerializerType: ResponseSerializerType = .Normal
    
    // 超时时间，默认为45秒；可单独设置某接口
    let timeoutInterval: TimeInterval = 45
    
    // 网络成功回调
    let successClosure: KDSuccessClosure? = nil
    
    // 网络失败回调
    let errorClosure: KDErrorsClosure? = nil
    
    // 请求完成回调
    let finishedClosure: KDFinishedClosure? = nil
    
    // 请求取消回调
    let cancelClosure: KDCancelClosure? = nil
}

