//
//  ViewController.swift
//  OmnipotentSkip
//
//  Created by sks on 17/3/31.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var pushModel : PushModel?
    var warmOneModel : WarmOneDataModel = WarmOneDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "我是没有绑定Storyboard的VC"
        self.view.backgroundColor = UIColor.brown
        if pushModel != nil {
            warmOneModel = pushModel!.warmOneModel
        }
        let labelOne = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 20))
        let labelTwo = UILabel(frame: CGRect(x: 100, y: 150, width: 200, height: 20))
        self.view.addSubview(labelOne)
        self.view.addSubview(labelTwo)
        labelOne.text = warmOneModel.topLabelStr
        labelTwo.text = warmOneModel.bottomLabelStr
        
        let gen = UITapGestureRecognizer(target: self, action: #selector(ViewController.touchClick(sender:)))
        self.view.addGestureRecognizer(gen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func touchClick(sender : UIGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
    }
}


