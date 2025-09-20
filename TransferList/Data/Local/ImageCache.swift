//
//  ImageCache.swift
//  TransferList
//
//  Created by Yaser Bahrami on 20.09.2025.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    func image(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let img = cache.object(forKey: url as NSURL) { return completion(img) }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            if let image { self.cache.setObject(image, forKey: url as NSURL) }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
