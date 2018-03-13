//
//  KLSlideProgressView.swift
//  KLSlideProgressView
//
//  Created by karl on 2018/03/13.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

protocol KLSlideProgressViewDelegate: class {
    func slideProgressView(valueChange value: CGFloat)
}

class KLSlideProgressView: UIView {
    var value: CGFloat = 0 {
        didSet {
            if value < 0 {
                value = 0
            } else if value > 1 {
                value = 1
            }
            
            slideColorLayer?.frame = CGRect(x: 0, y: 0, width: frame.width * value, height: frame.height)
            delegate?.slideProgressView(valueChange: value)
        }
    }
    
    var unselectColor = UIColor.lightGray {
        didSet {
            lineLayer.backgroundColor = unselectColor.cgColor
            dotArray.forEach({$0.backgroundColor = unselectColor})
        }
    }
    var selectColor = UIColor.blue {
        didSet {
            if slideColorLayer == nil {
                prepare()
            }
            slideColorLayer?.backgroundColor = selectColor.cgColor
        }
    }
    
    var gestureEnabled: Bool = true {
        didSet {
            if gestureEnabled {
                if panGestureRecognizer == nil {
                    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureAction(_:)))
                    addGestureRecognizer(panGestureRecognizer!)
                    
                    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureAction(_:)))
                    addGestureRecognizer(tapGestureRecognizer!)
                } else {
                    panGestureRecognizer?.isEnabled = true
                    tapGestureRecognizer?.isEnabled = true
                }
            } else {
                panGestureRecognizer?.isEnabled = false
                tapGestureRecognizer?.isEnabled = false
            }
        }
    }
    weak var delegate: KLSlideProgressViewDelegate?
    private let lineLayer = CALayer()
    private var dotArray = [UIButton]()
    private var slideColorLayer: CALayer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    init(frame: CGRect, slideHeight:CGFloat, dotSize: CGFloat, dotCount: Int) {
        super.init(frame: frame)
        
        lineLayer.frame = CGRect(x: 0, y: (frame.height - slideHeight) / 2, width: frame.width, height: slideHeight)
        lineLayer.cornerRadius = slideHeight / 2
        layer.addSublayer(lineLayer)
        
        let dotMargin = (frame.width - (CGFloat(dotCount) * dotSize)) / CGFloat((dotCount - 1))
        for i in 0 ..< dotCount {
            let dot = UIButton(frame: CGRect(x: CGFloat(i) * (dotMargin + dotSize), y: (frame.height - dotSize) / 2, width: dotSize, height: dotSize))
            dotArray.append(dot)
            dot.addTarget(self, action: #selector(dotClick(_:)), for: .touchUpInside)
            dot.layer.cornerRadius = dotSize / 2
            addSubview(dot)
        }
    }
    
    private func prepare() {
        guard slideColorLayer == nil, let image = kl_converToImage() else {
            return
        }
        let maskLayer = CALayer()
        maskLayer.frame = bounds
        maskLayer.contentsScale = UIScreen.main.scale
        maskLayer.contents = image.cgImage
        
        slideColorLayer = CALayer()
        slideColorLayer!.frame = bounds
        slideColorLayer!.mask = maskLayer
        layer.addSublayer(slideColorLayer!)
    }
    
    @objc private func gestureAction(_ gesture: UIGestureRecognizer) {
        self.value = gesture.location(in: self).x / frame.width
    }
    
    @objc private func dotClick(_ btn: UIButton) {
        self.value = btn.frame.maxX / frame.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func kl_converToImage() -> UIImage? {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
}
