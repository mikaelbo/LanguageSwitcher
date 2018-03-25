//
//  LanguageHandler.swift
//  LanguageSwitcher
//
//  Created by Mikael on 2018-03-25.
//  Copyright © 2018 Mikael. All rights reserved.
//

import Foundation

func LocalizedString(_ key: String) -> String {
    return LanguageHandler.default.localizedString(key)
}

enum PreferredLocalization: String {
    case swedish = "sv"
    case english = "en"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case `default` = "default"
}

extension NSNotification.Name {
    static let PreferredLanguageDidChange = NSNotification.Name(rawValue: "PreferredLanguageDidChange")
}

private let PreferredLanguageKey = "PreferredLanguage"
private let defaultHandler = LanguageHandler()

class LanguageHandler: NSObject {

    var preferredLocalization: PreferredLocalization {
        set {
            if currentLocalization != newValue {
                currentLocalization = newValue
                updateFromCurrentLocalization()
            }
        }
        get {
            return currentLocalization
        }
    }
    private var currentLocalization: PreferredLocalization = .default
    private(set) var currentBundle: Bundle = Bundle.main
    private(set) var currentLocale: Locale = Locale.current

    class var `default`: LanguageHandler {
        return defaultHandler
    }

    override init() {
        super.init()
        loadCurrentLocalizationIfNeeded()
    }

    private func loadCurrentLocalizationIfNeeded() {
        if let key = UserDefaults.standard.string(forKey: PreferredLanguageKey),
            let localization = PreferredLocalization(rawValue: key) {
            currentLocalization = localization
        }
        loadCurrentBundleAndLocale()
    }

    private func updateFromCurrentLocalization() {
        loadCurrentBundleAndLocale()
        UserDefaults.standard.setValue(currentLocalization.rawValue, forKey: PreferredLanguageKey)
        NotificationCenter.default.post(name: .PreferredLanguageDidChange, object: nil)
    }

    func localizedString(_ key: String) -> String {
        if currentLocalization == .default {
            return NSLocalizedString(key, comment: "")
        }
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    private func loadCurrentBundleAndLocale() {
        loadCurrentBundle()
        loadCurrentLocale()
    }

    private func loadCurrentBundle() {
        var bundle: Bundle?
        if preferredLocalization != .default {
            let key = currentLocalization.rawValue
            if let path = Bundle.main.path(forResource: key, ofType: "lproj") {
                bundle = Bundle(path: path)
            }
        }
        currentBundle = bundle ?? Bundle.main
    }

    private func loadCurrentLocale() {
        var locale: Locale?
        if currentLocalization != .default {
            locale = Locale(identifier: currentLocalization.rawValue)
        }
        currentLocale = locale ?? Locale.current
    }
}
