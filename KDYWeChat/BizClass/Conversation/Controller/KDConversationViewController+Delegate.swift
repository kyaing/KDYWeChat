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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension KDConversationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension KDConversationViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}


