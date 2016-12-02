//
//  KDConversationViewController+Delegate.swift
//  KDYWeChat
//
//  Created by mac on 16/12/2.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation

// MARK: - UITableViewDelegate
extension KDConversationViewController: UITableViewDelegate {
    // 是否必要仍然要 delegate 方法？
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension KDConversationViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension KDConversationViewController: UISearchControllerDelegate {
    func willPresentSearchController(searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
}


