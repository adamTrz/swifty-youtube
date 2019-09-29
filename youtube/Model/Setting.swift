//
//  Setting.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

enum SettingName: String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case Account = "Switch Account"
    case Feedback = "Send Feedback"
    case Help = "Help"
    case Terms = "Terms & privacy policy"
}

struct Setting {
    let name: SettingName
    let icon: String
    init(name: SettingName, icon: String) {
        self.name = name
        self.icon = icon
    }
}
