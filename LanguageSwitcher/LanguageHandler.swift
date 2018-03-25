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
    case Swedish = "sv"
    case English = "en"
    case ChineseSimplified = "zh-Hans"
    case ChineseTraditional = "zh-Hant"
    case Default = "default"
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
    private var currentLocalization: PreferredLocalization = .Default
    private(set) var currentBundle: Bundle = Bundle.main
    private(set) var currentLocale: Locale = Locale.current

    class var `default`: LanguageHandler {
        return defaultHandler
    }

    override init() {
        super.init()
        loadPreferredLocalizationIfNeeded()
    }

    private func loadPreferredLocalizationIfNeeded() {
        if let key = UserDefaults.standard.string(forKey: PreferredLanguageKey),
            let localization = PreferredLocalization(rawValue: key) {
            currentLocalization = localization
        }
        loadBundleIfNeeded()
        loadCurrentLocaleIfNeeded()
    }

    private func updateFromCurrentLocalization() {
        loadBundleIfNeeded()
        loadCurrentLocaleIfNeeded()
        UserDefaults.standard.setValue(currentLocalization.rawValue, forKey: PreferredLanguageKey)
        NotificationCenter.default.post(name: .PreferredLanguageDidChange, object: nil)
    }

    func localizedString(_ key: String) -> String {
        if currentLocalization == .Default {
            return NSLocalizedString(key, comment: "")
        }
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    private func loadCurrentLocaleIfNeeded() {
        if currentLocalization == .Default {
            currentLocale = Locale.current
        } else {
            let localeString = currentLocalization.rawValue
            currentLocale = Locale(identifier: localeString)
        }
    }

    private func loadBundleIfNeeded() {
        var bundle: Bundle?

        defer {
            currentBundle = bundle ?? Bundle.main
        }

        if preferredLocalization != .Default {
            let key = currentLocalization.rawValue
            if let path = Bundle.main.path(forResource: key, ofType: "lproj") {
                bundle = Bundle(path: path)
            }
        }
    }
}
