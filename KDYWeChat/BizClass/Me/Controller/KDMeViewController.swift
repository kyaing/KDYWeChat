//
//  KDMeViewController.swift
//  KDYWeChat
//
//  Created by kaideyi on 16/10/16.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import UIKit

/// 我界面
class KDMeViewController: UITableViewController {

    @IBOutlet var meTableView: UITableView!

    let itemDataSouce: [[(name: String, image: UIImage?)]] = [
        [
            ("", nil)
            ],
        [
            ("相册", KDYAsset.Me_MyAlbum.image),
            ("收藏", KDYAsset.Me_MyFavorites.image),
            ("钱包", KDYAsset.Me_MyBankCard.image),
            ("卡包", KDYAsset.Me_CardPackageIcon.image)
            ],
        [
            ("表情", KDYAsset.Me_ExpressionShops.image)
            ],
        [
            ("设置", KDYAsset.Me_Setting.image)
            ],
    ]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        meTableView.backgroundColor = KDYColor.TableBackground.color
        meTableView.separatorColor  = KDYColor.Separator.color
        meTableView.register(cellType: MeHeaderTableCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.meTableView.reloadData()
    }

    // MARK: - UITableViewDataSoure
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let headerCell: MeHeaderTableCell = tableView.dequeueReusableCell(for: indexPath)

            if let currentUser = UserInfoManager.shareInstance.getCurrentUserInfo() {
                headerCell.usernameLabel.text = currentUser.username

                if let nickname = currentUser.nickname {
                    headerCell.useridLabel.text = "昵称：" + nickname
                } else {
                    headerCell.useridLabel.text = "ID：" + (currentUser.objectId)!
                }

                if let imageURL = currentUser.imageUrl {
                    headerCell.avatorImageView.kf.setImage(with: URL(string: imageURL), placeholder: KDYAsset.AvatarDefault.image)
                }
            }

            return headerCell

        } else {
            var baseCell = tableView.dequeueReusableCell(withIdentifier: "baseCell")
            if baseCell == nil {
                baseCell = UITableViewCell(style: .default, reuseIdentifier: "baseCell")
            }

            configureCells(baseCell!, indexPath: indexPath)

            return baseCell!
        }
    }

    func configureCells(_ baseCell: UITableViewCell, indexPath: IndexPath) {

        baseCell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        baseCell.accessoryType = .disclosureIndicator
        baseCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        let item = itemDataSouce[indexPath.section][indexPath.row]
        baseCell.textLabel?.text = item.name
        baseCell.imageView?.image = item.image
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath as NSIndexPath).section == 0 {
            ky_pushViewController(KDPersonInfoViewController(), animated: true)

        } else if (indexPath as NSIndexPath).section == 3 {
            ky_pushViewController(KDSettingViewController(), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 15
    }
}
