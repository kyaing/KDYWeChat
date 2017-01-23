//
//  DiscoveryViewModel.swift
//  KDYWeChat
//
//  Created by mac on 17/1/23.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class DiscoveryViewModel: NSObject {

    func getDataSource() -> Observable<[SectionModel<String, DiscoveryModel>]> {
        return Observable.create({ (observer) -> Disposable in
            
            let dataSource = [
                DiscoveryModel(title: "朋友圈", titleImage: KDYAsset.Discover_Alubm.image, index: IndexPath(row: 0, section: 0)),
                DiscoveryModel(title: "扫一扫", titleImage: KDYAsset.Discover_QRCode.image, index: IndexPath(row: 0, section: 1)),
                DiscoveryModel(title: "我直播", titleImage: KDYAsset.Discover_Live.image, index: IndexPath(row: 0, section: 2))]
            
            let sections = [SectionModel(model: "", items: dataSource)]
            
            observer.onNext(sections)
            observer.onCompleted()
            
            return  Disposables.create{}
        })
    }
}

