//
//  ImageDownloader.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//
import Foundation
import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private init() {}
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion(nil)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }.resume()
        }
}
