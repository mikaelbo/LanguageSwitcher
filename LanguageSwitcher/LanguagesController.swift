//
//  LanguagesController.swift
//  LanguageSwitcher
//
//  Created by Mikael on 2018-03-25.
//  Copyright © 2018 Mikael. All rights reserved.
//

import UIKit

class LanguagesController: UITableViewController {

    let localizations: [PreferredLocalization] = [.Default, .English, .Swedish, .ChineseSimplified, .ChineseTraditional]

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectCurrentLanguageCell()
    }

    func selectCurrentLanguageCell() { // For demonstrating purposes only ;)
        let localization = LanguageHandler.default.preferredLocalization
        if let index = localizations.index(of: localization) {
            for cell in tableView.visibleCells {
                if let indexPath = tableView.indexPath(for: cell) {
                    let isSelectedCell = index == indexPath.row
                    cell.accessoryType = isSelectedCell ? .checkmark : .none
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let localization = localizations[indexPath.row]
        LanguageHandler.default.preferredLocalization = localization
        selectCurrentLanguageCell()
    }
}
