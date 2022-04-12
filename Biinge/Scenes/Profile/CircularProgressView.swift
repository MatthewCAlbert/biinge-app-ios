//
//  CircularProgressView.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 11/04/22.
//

import UIKit

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    var _accomplish: Int = UserProfile.shared.accomplish
    var _exceed: Int = UserProfile.shared.exceed
//    var _accomplish: Int? = 1
//    var _exceed: Int? = 1

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect){
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor = UIColor(rgb: 0xFF1E1E) {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    var trackColor = UIColor(rgb: 0x19A4DF) {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    var accomplish: Int {   
        set { _accomplish = newValue }
        get { return _accomplish}
      }
    
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlepath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.path = circlepath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 10.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlepath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = CGFloat(_exceed)/CGFloat(_exceed + _accomplish)
//        progressLayer.strokeEnd = 0.5
        layer.addSublayer(progressLayer)
    }

}


