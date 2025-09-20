//
//  AppConfig.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import Foundation

enum AppConfig {
    static let baseURL: URL = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String,
            let url = URL(string: urlString)
        else {
            fatalError("❌ BaseURL missing or invalid in Info.plist")
        }
        return url
    }()
}
