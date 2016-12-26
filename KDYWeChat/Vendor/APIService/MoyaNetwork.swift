//
//  MoyaNetwork.swift
//  KDYWeChat
//
//  Created by mac on 16/12/26.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import Moya

public enum ApiService {
    case GetRank(area: String?)
}

public let provider   = MoyaProvider<ApiService>()
public let rxProvider = RxMoyaProvider<ApiService>()

public typealias sucessClosure  = (_ responseObject: AnyObject?) -> Void
public typealias failureClosure = (_ error: NSError?) -> Void

extension ApiService: TargetType {

    public var baseURL: URL { return URL(string: "http://v.juhe.cn")! }

    public var path: String {
        switch self {
        case .GetRank(_): return "/boxoffice/rank"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .GetRank(area: _):
            return .GET
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .GetRank(let area):
            return [
                "area": nil == area ? "" : area!,
                // 接口详情地址: https://www.juhe.cn/docs/api/id/44
                "key": "c4356125b8472bd265a0691789d114b3"
            ]
        }
    }

    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case .GetRank(area: _): return .request
        }
    }
}

class MoyaNetwork {
    enum OpData {
        case Normal
        case Reactive
    }

    let opData = OpData.Normal

    static let share = MoyaNetwork()
    private init() {}

    func reqeustWithTarget(target: ApiService,
                           success: @escaping sucessClosure,
                           failure: @escaping failureClosure) {

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    if let json = try? response.mapJSON(failsOnEmptyData: true) {
                        success(json as AnyObject?)
                    }
                }
        
            case let .failure(error): failure(error as NSError?)
            }
        }
    }
}

