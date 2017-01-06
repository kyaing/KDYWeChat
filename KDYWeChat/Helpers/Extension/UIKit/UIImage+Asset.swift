//
//  UIImage+Asset.swift
//  KDYWeChat
//
//  Created by mac on 16/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

import Foundation

typealias KDYAsset = UIImage.AssetIdentifier

extension UIImage {

    enum AssetIdentifier: String {

        // Tabbar
        case Tabbar_Chat_Normal       = "tabbar_mainframe"
        case Tabbar_Chat_Select       = "tabbar_mainframeHL"
        case Tabbar_Contacts_Normal   = "tabbar_contacts"
        case Tabbar_Contacts_Select   = "tabbar_contactsHL"
        case Tabbar_Discover_Normal   = "tabbar_discover"
        case Tabbar_Discover_Select   = "tabbar_discoverHL"
        case Tabbar_Me_Normal         = "tabbar_me"
        case Tabbar_Me_Select         = "tabbar_meHL"
        
        case AvatarDefault            = "user_avatar"
        case MainBack                 = "main_back"
        case AddFriends               = "barbuttonicon_add"

        // WeChat
        case Chat_Recording001        = "RecordingSignal001"
        case Chat_Recording002        = "RecordingSignal002"
        case Chat_Recording003        = "RecordingSignal003"
        case Chat_Recording004        = "RecordingSignal004"
        case Chat_Recording005        = "RecordingSignal005"
        case Chat_Recording006        = "RecordingSignal006"
        case Chat_Recording007        = "RecordingSignal007"
        case Chat_Recording008        = "RecordingSignal008"

        case Chat_Sender_Playing001   = "SenderVoiceNodePlaying001"
        case Chat_Sender_Playing002   = "SenderVoiceNodePlaying002"
        case Chat_Sender_Playing003   = "SenderVoiceNodePlaying003"
        case Chat_Receiver_Playing001 = "ReceiverVoiceNodePlaying001"
        case Chat_Receiver_Playing002 = "ReceiverVoiceNodePlaying002"
        case Chat_Receiver_Playing003 = "ReceiverVoiceNodePlaying003"
        case Chat_Sender_Playing      = "SenderVoiceNodePlaying"
        case Chat_Receiver_Playing    = "ReceiverVoiceNodePlaying"

        case Chat_FreindInfo          = "barbuttonicon_InfoSingle"
        case Chat_MessageSendFail     = "messageSendFail"

        case Chat_SenderBg_Normal     = "SenderTextNodeBkg"
        case Chat_SenderBg_Select     = "SenderTextNodeBkgHL"
        case Chat_ReceiverBg_Normal   = "ReceiverTextNodeBkg"
        case Chat_ReceiverBg_Select   = "ReceiverTextNodeBkgHL"

        case Chat_Keyboard_Normal     = "tool_keyboard_1"
        case Chat_Keyboard_Select     = "tool_keyboard_2"
        case Chat_Voice_Normal        = "tool_voice_1"
        case Chat_Voice_Select        = "tool_voice_2"
        case Chat_Emotion_Normal      = "tool_emotion_1"
        case Chat_Emotion_Select      = "tool_emotion_2"
        case Chat_Share_Normal        = "tool_share_1"
        case Chat_Share_Select        = "tool_share_2"

        // Contacts
        case Contacts_Addfreind       = "barbuttonicon_addfriends"
        case Contacts_Friend          = "plugins_FriendNotify"
        case Contacts_AddGround       = "add_friend_icon_addgroup"
        case Contacts_Offical         = "add_friend_icon_offical"

        // Discover
        case Discover_AlbumHolder     = "place_holder_album"
        case Discover_Live            = "ff_IconLocationService"
        case Discover_QRCode          = "ff_IconQRCode"
        case Discover_Alubm           = "ff_IconShowAlbum"
        case Discover_AlubmCamera     = "barbuttonicon_Camera"

        // Me
        case Me_MyAlbum               = "MoreMyAlbum"
        case Me_MyFavorites           = "MoreMyFavorites"
        case Me_MyBankCard            = "MoreMyBankCard"
        case Me_CardPackageIcon       = "MyCardPackageIcon"
        case Me_ExpressionShops       = "MoreExpressionShops"
        case Me_Setting               = "MoreSetting"

        var image: UIImage {
            return UIImage(assetIdentifier: self)
        }
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}

