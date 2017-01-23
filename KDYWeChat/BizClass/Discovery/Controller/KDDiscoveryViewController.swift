//
//  KDDiscoveryViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/9/10.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

/// 发现界面
final class KDDiscoveryViewController: UITableViewController {
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DiscoveryModel>>()
    
    let viewModel = DiscoveryViewModel()

    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = KDYColor.TableBackground.color
        tableView.separatorColor  = KDYColor.Separator.color
        tableView.tableFooterView = UIView()
        tableView.dataSource = nil
        
        dataSource.configureCell = { _, tableView, indexPath, model in
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: "discoveryCell")
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            
            cell.textLabel?.text = model.title
            cell.imageView?.image = model.titleImage
            
            return cell
        }
        
        tableView.rx.modelSelected(DiscoveryModel.self)
            .subscribe(onNext: { model in
                
                if model.index.section == 0 {
                    self.kyPushViewController(KDFriendAlbumViewController(), animated: true)
                    
                } else if model.index.section == 1 {
                    self.kyPushViewController(KDQRCodeViewController(), animated: true)
                    
                } else {
                    self.kyPushViewController(KDMyLiveViewController(), animated: true)
                }
            }) { 
                
            }
            .addDisposableTo(disposeBag)
        
        viewModel.getDataSource()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}

