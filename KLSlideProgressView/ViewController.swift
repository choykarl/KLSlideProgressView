//
//  ViewController.swift
//  KLSlideProgressView
//
//  Created by karl on 2018/03/13.
//  Copyright © 2018年 Karl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KLSlideProgressViewDelegate {

    var slideView: KLSlideProgressView?
    let sl = UISlider(frame: CGRect(x: 100, y: 200, width: 200, height: 44))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideView = KLSlideProgressView(frame: CGRect(x: 50, y: 100, width: 300, height: 30), slideHeight: 10, dotSize: 20, dotCount: 6)
        slideView?.unselectColor = UIColor.lightGray
        slideView?.selectColor = UIColor.blue
        slideView?.gestureEnabled = true
        slideView?.delegate = self
        view.addSubview(slideView!)


        
        sl.addTarget(self, action: #selector(slideValueChange(_:)), for: UIControlEvents.valueChanged)
        sl.value = 1
        view.addSubview(sl)
    }
    
    @objc func slideValueChange(_ slide: UISlider) {
        let value = CGFloat(slide.value)
        slideView?.value = value
    }
    
    func slideProgressView(valueChange value: CGFloat) {
        sl.value = Float(value)
    }
}

