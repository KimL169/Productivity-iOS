//
//  CountDownClockView.swift
//  Productivity2
//
//  Created by Kim on 09/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

import UIKit


let totalSecondsCount = 10;
let π:CGFloat = CGFloat(M_PI);

@IBDesignable class CountDownClockView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.greenColor();
    @IBInspectable var outlineColor:UIColor = UIColor.redColor();
    @IBInspectable var counter: Int = 5;
    
    override func drawRect(rect: CGRect) {
        
        var circlePath = UIBezierPath(ovalInRect:  rect);
        fillColor.setFill();
        circlePath.fill();
        
        
        // 4
        let startAngle: CGFloat = 3 * π / 4
        let endAngle: CGFloat = π / 4
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle;
        let arcLengthPerCount = angleDifference / CGFloat(totalSecondsCount);
        
        let outlineEndAngle = arcLengthPerCount * CGFloat(counter) + startAngle;
        
        var outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 1.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true);
        
        
        outlinePath.addArcWithCenter(center, radius: bounds.width/2 - circlePath.bounds.width + 1.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false);
        outlinePath.closePath();
        outlineColor.setStroke();
        outlinePath.lineWidth = 3.0;
        outlinePath.stroke();
    }


}
