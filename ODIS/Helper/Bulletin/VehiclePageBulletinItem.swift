//
//  VehiclePageBulletinItem.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 30/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import UIKit
import BLTNBoard

class VehiclePageBulletinItem: BLTNPageItem {

    private let feedbackGenerator = UISelectionFeedbackGenerator()

    override func actionButtonTapped(sender: UIButton) {
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        super.actionButtonTapped(sender: sender)
    }

    override func alternativeButtonTapped(sender: UIButton) {
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        super.alternativeButtonTapped(sender: sender)
    }

}
