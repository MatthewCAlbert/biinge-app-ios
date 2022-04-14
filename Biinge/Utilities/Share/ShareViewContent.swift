//
//  ShareViewContent.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 12/04/22.
//

import UIKit

class ShareViewContent: UIView {

    @IBOutlet weak var monthYearLbl: UILabel!
    @IBOutlet weak var longestStreakLbl: UILabel!
    @IBOutlet weak var sessionSuccessLbl: UILabel!
    @IBOutlet weak var sessionTotalLbl: UILabel!
    @IBOutlet weak var totalWatchTimeLbl: UILabel!
    @IBOutlet weak var accuracyRateLbl: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var circularView: CircularProgressView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
