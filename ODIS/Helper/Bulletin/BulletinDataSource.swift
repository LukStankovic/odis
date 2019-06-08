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

    static func makeVehiclePage(vehicle: VehicleTO?) -> VehiclePageBulletinItem {
        if (vehicle == nil) {
            return VehiclePageBulletinItem(title: "")
        }

        let page = VehiclePageBulletinItem(title: self.getTitle(vehicle: vehicle!))
        page.attributedDescriptionText = self.getVehicleInformation(vehicle: vehicle!)
        page.isDismissable = true

        return page
    }

    private static func getTitle(vehicle: VehicleTO) -> String {
        let lowFloor = vehicle.lowFloor ? "♿" : ""
        return  vehicle.line + " " + lowFloor + "\n" + vehicle.finalStop
    }

    private static func getVehicleInformation(vehicle: VehicleTO) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
        let vehicleInformation = NSAttributedString(string: "🚏 " + vehicle.lastStop + "\n⏱ " + vehicle.delay + "\n🚌 " + vehicle.vehicleNumber + " (" + vehicle.connection + ")", attributes: attributes)

        return vehicleInformation
    }

}
