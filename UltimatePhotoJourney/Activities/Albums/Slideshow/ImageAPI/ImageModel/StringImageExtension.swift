//
//  ImageExtension.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 15.09.22.
//

import Foundation
import SwiftUI

extension String {
    func load() -> UIImage {
        do {
            // convert String to URL
            guard let url = URL(string: self) else {
                //return empty Image if the URL is invalid
                return UIImage()
            }
            
            // convert URL to data
            let data: Data = try Data(contentsOf: url)
            
            // create UIImage object from data and optional value if URL doesn't exist
            return UIImage(data: data) ?? UIImage()
        } catch {
            //
        }
        
        return UIImage()
    }
}
