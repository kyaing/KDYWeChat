//
//  KDChatViewController+ChatCells.swift
//  KDYWeChat
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

// MARK: - 聊天Cell
extension MessageContentType {
    func chatCellHeight(model: ChatModel) -> CGFloat {
        switch self {
        case .Text:
            return ChatTextTableCell.layoutCellHeight(model)
            
        case .Time:
            return 40
            
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
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatTextTableCell", forIndexPath: indexPath) as! ChatTextTableCell
            cell.setupCellContent(model)
            
            return cell
        
        case .Time:
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatTimeTableCell", forIndexPath: indexPath) as! ChatTimeTableCell
            cell.setupCellContent(model)
            
            return cell
            
        default:
            return nil
        }
    }
}

