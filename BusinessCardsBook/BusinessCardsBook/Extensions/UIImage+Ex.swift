//
//  UIImage+Ex.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

extension UIImage {
    
    func getThumbnail() -> UIImage {
        var thumbnail = UIImage()
        if let imageData = self.pngData(){
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 100] as CFDictionary
            
            imageData.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, imageData.count),
                    let source = CGImageSourceCreateWithData(cfData, nil) {
                    
                    let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                    thumbnail = UIImage(cgImage: imageReference)
                }
            }
        }
        return thumbnail
    }
}
