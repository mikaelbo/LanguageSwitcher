//
//  LocalizableViews.swift
//
//  Created by Adam Kull, modified by Mikael
//  Copyright © 2018 Adam Kull. All rights reserved.
//

import UIKit

@IBDesignable
class LocalizableLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        registerForLanguageChangeNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForLanguageChangeNotification()
    }

    private func registerForLanguageChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(preferredLanguageDidChange),
                                               name: .PreferredLanguageDidChange,
                                               object: nil)
    }

    @objc func preferredLanguageDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.textIdentifier = self?.textIdentifier
        }
    }

    @IBInspectable var textIdentifier: String? {
        didSet {
            guard let tid = textIdentifier, !tid.isEmpty else { return }
            super.text = LocalizedString(tid)
        }
    }

    override var text: String? {
        set { if (textIdentifier ?? "").isEmpty { super.text = newValue } }
        get { return super.text }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@IBDesignable
class LocalizableNavigationItem: UINavigationItem {

    override init(title: String) {
        super.init(title: title)
        registerForLanguageChangeNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForLanguageChangeNotification()
    }

    private func registerForLanguageChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(preferredLanguageDidChange),
                                               name: .PreferredLanguageDidChange,
                                               object: nil)
    }

    @objc func preferredLanguageDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.titleIdentifier = self?.titleIdentifier
        }
    }

    @IBInspectable var titleIdentifier: String? {
        didSet {
            guard let tid = titleIdentifier, !tid.isEmpty else { return }
            let back = backBarButtonItem?.title
            super.title = LocalizedString(titleIdentifier!)
            backBarButtonItem?.title = back
        }
    }

    override var title: String? {
        set { if (titleIdentifier ?? "").isEmpty { super.title = newValue } }
        get { return super.title }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
