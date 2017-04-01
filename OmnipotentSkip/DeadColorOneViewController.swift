//
//  DeadColorOneViewController.swift
//  OmnipotentSkip
//
//  Created by sks on 17/3/31.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class DeadColorOneViewController: UIViewController {

    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    var pushModel : PushModel?
    var dataModel : DeadOneDataModel = DeadOneDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if pushModel != nil{
            dataModel = pushModel!.deadOneModel
        }
        oneLabel.text = dataModel.topLabelStr
        twoLabel.text = dataModel.bottomLabelStr
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchClick(_ sender: Any) {
        performSegue(withIdentifier: "DeadOneToTwo", sender: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
