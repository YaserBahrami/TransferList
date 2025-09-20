//
//  TransferListControllable.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import UIKit

protocol TransferListControllable: AnyObject {
    var viewController: UIViewController { get }
    var onSelect: ((Transfer) -> Void)? { get set }

    func applySearch(_ text: String?)
    func reload()
    func externalFavoritesDidChange()
}

