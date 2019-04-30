//
//  BulletinDataSource.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 30/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import UIKit
import BLTNBoard
import SafariServices

enum BulletinDataSource {

    static func makeVehiclePage(title: String?, subTitle: String?) -> VehiclePageBulletinItem {
        let page = VehiclePageBulletinItem(title: title ?? "")
        page.descriptionText = subTitle
        page.isDismissable = true

        return page
    }
 
}
