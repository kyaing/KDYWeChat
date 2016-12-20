//
//  UIImage+Extension.swift
//  TSWeChat
//
//  Created by Hilen on 11/24/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import UIKit
import Photos

public extension UIImage {
    //https://github.com/melvitax/AFImageHelper/blob/master/AFImageHelper%2FAFImageExtension.swift
    
    public enum UIImageContentMode {
        case scaleToFill, scaleAspectFit, scaleAspectFill
    }
    
    /**
     Creates a resized copy of an image.
     
     - Parameter size: The new size of the image.
     - Parameter contentMode: The way to handle the content in the new size.
     - Parameter quality:     The image quality
     
     - Returns A new image
     */
    func resize(_ size:CGSize, contentMode: UIImageContentMode = .scaleToFill, quality: CGInterpolationQuality = .medium) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = quality
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    //iOS7+ capture screen
    func screenCaptureWithView(_ view: UIView, rect: CGRect) -> UIImage {
        var capture: UIImage
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        //        let layer: CALayer = view.layer
        
        //  if view.responds(to: #selector(UIView.drawHierarchy(:afterScreenUpdates:)(_:afterScreenUpdates,,:))) {
        //            view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        //        } else {
        //            view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //        }
        capture = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capture
    }
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func roundWithCornerRadius(_ cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func hasAlpha() -> Bool {
        let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
        return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
    }
    
    class func scaleImage(_ image: UIImage, scaleSize: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: image.size.width * scaleSize, height: image.size.height * scaleSize))
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width * scaleSize, height: image.size.height * scaleSize))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return scaleImage!
    }
}

