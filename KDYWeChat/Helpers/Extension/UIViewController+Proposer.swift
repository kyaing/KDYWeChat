//
//  UIViewController+Proposer.swift
//  KDYWeChat
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import Foundation
import Proposer

extension PrivateResource {
    
    var proposeMessage: String {
        switch self {
        case .Photos:
            return NSLocalizedString("Proposer need to access your Photos to choose photo.", comment: "")
        case .Camera:
            return NSLocalizedString("Proposer need to access your Camera to take photo.", comment: "")
        case .Microphone:
            return NSLocalizedString("Proposer need to access your Microphone to record audio.", comment: "")
        case .Contacts:
            return NSLocalizedString("Proposer need to access your Contacts to match friends.", comment: "")
        case .Reminders:
            return NSLocalizedString("Proposer need to access your Reminders to create reminder.", comment: "")
        case .Calendar:
            return NSLocalizedString("Proposer need to access your Calendar to create event.", comment: "")
        case .Location:
            return NSLocalizedString("Proposer need to get your Location to share to your friends.", comment: "")
        }
    }
    
    var noPermissionMessage: String {
        switch self {
        case .Photos:
            return NSLocalizedString("Proposer can NOT access your Photos, but you can change it in iOS Settings.", comment: "")
        case .Camera:
            return NSLocalizedString("Proposer can NOT access your Camera, but you can change it in iOS Settings.", comment: "")
        case .Microphone:
            return NSLocalizedString("Proposer can NOT access your Microphone, but you can change it in iOS Settings.", comment: "")
        case .Contacts:
            return NSLocalizedString("Proposer can NOT access your Contacts, but you can change it in iOS Settings.", comment: "")
        case .Reminders:
            return NSLocalizedString("Proposer can NOT access your Reminders, but you can change it in iOS Settings.", comment: "")
        case .Calendar:
            return NSLocalizedString("Proposer can NOT access your Calendar, but you can change it in iOS Settings.", comment: "")
        case .Location:
            return NSLocalizedString("Proposer can NOT get your Location, but you can change it in iOS Settings.", comment: "")
        }
    }
}

extension UIViewController {
    
    private func showDialogWithTitle(title: String, message: String, cancelTitle: String, confirmTitle: String, withCancelAction cancelAction : (() -> Void)?, confirmAction: (() -> Void)?) {
        
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .Cancel) { _ in
                cancelAction?()
            }
            alertController.addAction(cancelAction)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .Default) { _ in
                confirmAction?()
            }
            alertController.addAction(confirmAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    func showProposeMessageIfNeedFor(resource: PrivateResource, andTryPropose propose: Propose) {
        
        if resource.isNotDeterminedAuthorization {
            showDialogWithTitle(NSLocalizedString("Notice", comment: ""), message: resource.proposeMessage, cancelTitle: NSLocalizedString("Not now", comment: ""), confirmTitle: NSLocalizedString("OK", comment: ""), withCancelAction: nil, confirmAction: {
                propose()
            })
            
        } else {
            propose()
        }
    }
    
    func alertNoPermissionToAccess(resource: PrivateResource) {
        
        showDialogWithTitle(NSLocalizedString("Sorry", comment: ""), message: resource.noPermissionMessage, cancelTitle: NSLocalizedString("Dismiss", comment: ""), confirmTitle: NSLocalizedString("Change it now", comment: ""), withCancelAction: nil, confirmAction: {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
    }
}


