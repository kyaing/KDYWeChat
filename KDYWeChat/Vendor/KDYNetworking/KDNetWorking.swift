//
//  KDNetWorking.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation
import Alamofire

class KDNetWorking: NSObject {
    
    var request: KDRequest?
    static let share = KDNetWorking()
    
    fileprivate override init() {
        super.init()
        request = KDRequest()
    }
    
    // MARK: - Public Methods

    // 网络是否连通
    func isNetworkReachable() -> Bool {
        return true
    }
    
    func sendRequest(_ request: KDRequestClosure) -> Void {
        sendRequest(request, success: nil, error: nil, finished: nil)
    }
    
    func sendRequest(_ request: KDRequestClosure,
                     success: KDSuccessClosure?) -> Void {
        sendRequest(request, success: success, error: nil, finished: nil)
    }
    
    func sendRequest(_ request: KDRequestClosure,
                     success: KDSuccessClosure?,
                     error: KDErrorsClosure?) -> Void {
        sendRequest(request, success: success, error: error, finished: nil)
    }
    
    func sendRequest(_ request: KDRequestClosure,
                     success: KDSuccessClosure?,
                     error: KDErrorsClosure?,
                     finished: KDFinishedClosure?) -> Void {
        sendRequest(request, success: success, error: error, finished: finished)
    }
    
    // MARK: - Private Methods
    
    fileprivate func _sendRequest(request: KDRequest) {
        
    }
}

