//
//  PushModel.swift
//  OmnipotentSkip
//
//  Created by sks on 17/3/31.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class PushModel: NSObject {
    var warmOneModel : WarmOneDataModel = WarmOneDataModel()
    var warmTwoModel : WarmTwoDataModel = WarmTwoDataModel()
    var deadOneModel : DeadOneDataModel = DeadOneDataModel()
    var deadTwoModel : DeadTwoDataModel = DeadTwoDataModel()
    override init() {
        super.init()
    }
}
