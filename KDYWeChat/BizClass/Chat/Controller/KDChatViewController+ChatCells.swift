//
//  KDChatViewController+ChatCells.swift
//  KDYWeChat
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

// MARK: - 聊天Cells
extension MessageContentType {
    func chatCellHeight(model: ChatModel) -> CGFloat {
        switch self {
        case .Text:
            return ChatTextTableCell.layoutCellHeight(model)
            
        case .Time:
            return 40
        
        case .Image:
            return ChatImageTableCell.layoutHeight(model)
            
        case .Voice:
            return ChatAudioTableCell.layoutCellHeight(model)
            
        case .Location:
            return ChatLocationTableCell.layoutCellHeight(model)
            
        default:
            return 0
        }
    }
    
    func chatCell(tableView: UITableView,
                  indexPath: NSIndexPath,
                  model: ChatModel,
                  viewController: KDChatViewController) -> UITableViewCell? {
        
        switch self {
        case .Text:
            let cell: ChatTextTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupCellContent(model)
            cell.cellDelegate = viewController
            
            return cell
        
        case .Time:
            let cell: ChatTimeTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupCellContent(model)
            
            return cell
            
        case .Image:
            let cell: ChatImageTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupCellContent(model)
            cell.cellDelegate = viewController
            
            return cell
            
        case .Voice:
            let cell: ChatAudioTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupCellContent(model)
            cell.cellDelegate = viewController
            
            return cell
            
        case .Location:
            let cell: ChatLocationTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupCellContent(model)
            cell.cellDelegate = viewController
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

