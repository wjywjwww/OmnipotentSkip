//
//  AppDelegate.swift
//  OmnipotentSkip
//
//  Created by sks on 17/3/31.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.conductPushParams(params: self.setPushParams())
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // let params = ["class" : "填入需要跳转VC名字字符串" , "property" : [ "跳入VC需要用到的数据Model":["数据Model属性字符串" : "数据Model属性值"] ] , "modelName" : "数据Model在pushModel中的名字"] as [String : Any]
    //这些东西需要和后台进行对接好，不然错误的key，name，会导致取不到想要的值
    func setPushParams() ->[String : AnyObject]{
        let params = ["class" : "WarmColorOneViewController" , "property" : [ "WarmOneDataModel":["topLabelStr" : "我是推送过来的信息" , "bottomLabelStr" : "我也是推送过来的信息"] ] , "modelName" : "warmOneModel"] as [String : Any]
        return params as [String : AnyObject]
    }
    //处理推送信息进行跳转传值方法
    func conductPushParams(params : [String : AnyObject]){
        //先检查推送过来的字典里面Class存不存在
        guard let className = params["class"] as? String else{
            print("参数类名不存在")
            return
        }
        //读取Plist文件
        let filePath = Bundle.main.path(forResource: "VCStoryboardIDList", ofType: "plist") ?? ""
        let vcDic : NSDictionary = NSDictionary(contentsOfFile: filePath) ?? NSDictionary()
        
        //判断plist文件里面是否含有目标VC的Storyboard ID
        if let vcID = vcDic[className] {
            
            guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
                print("命名空间不存在")
                return
            }
            //如果VC是与storyboard关联的通过下面的语句创建VC对象
            let clsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  vcID as! String)
            
            setPushModelInfo(clsVC: clsVC, params: params, nameSpace: nameSpace as! String)
        }else{

            guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
                print("命名空间不存在")
                return
            }
            //如果不是storyboard绑定的UIViewController 则通过这种方式创建其对象
            let vcClassTemp : AnyClass? = NSClassFromString((nameSpace as! String) + "." + className)
            guard let vcClsType = vcClassTemp as? UIViewController.Type else{
                print("无法转换为UIViewController类型")
                return
            }
            //创建对应View Controller 对象
            let clsVC = vcClsType.init()
            setPushModelInfo(clsVC: clsVC, params: params, nameSpace: nameSpace as! String)
        }
    }
    //因为conductPushParams里面if else里面重复代码挺多，所以我抽离出来重新写了一个方法
    func setPushModelInfo(clsVC : UIViewController , params : [String : Any] , nameSpace : String){
        
        //创建PushModel 对象
        let pushModel = PushModel()
        
        //根据 params["property"]里面的dataModel名字字符串，创建其对象，首先获取命名空间字符串
        guard let propertyDic = params["property"] as? [String : Any] else{
            print("property信息不存在")
            return
        }
        for key in propertyDic.keys{
            //然后NSClassFromString获取到DataModel 的Class
            let modelClassTemp : AnyClass? = NSClassFromString((nameSpace) + "." + key)
            //然后判断有没有获取成功
            guard let modleClsType = modelClassTemp as? NSObject.Type else{
                return
            }
            //根据推送过来的信息对dataModel进行赋值
            guard let modelDic = propertyDic[key] as? [String : String]else{
                print("model信息不存在")
                return
            }
            let dataModel = modleClsType.init()
            for modelKey in modelDic.keys{
                //首先确定model里面有相应的属性
                if SwiftRunTimeTool.checkClassPerporty(object: object_getClass(dataModel), propertyStr: modelKey){
                    dataModel.setValue(modelDic[modelKey]! as String, forKey: modelKey)
                }
            }
            //再根据推送过来dataModel再pushModel里面的名字字符串，对pushModel进行赋值
            guard let modelName = params["modelName"] as? String else{
                print("modelName不存在")
                return
            }
            //确保pushModel里面有对应名字的属性
            if SwiftRunTimeTool.checkClassPerporty(object: object_getClass(pushModel), propertyStr: modelName){
                pushModel.setValue(dataModel, forKey: modelName)
            }
        }
        //确保跳转的VC里面有pushModel属性
        if SwiftRunTimeTool.checkClassPerporty(object: object_getClass(clsVC), propertyStr: "pushModel"){
            clsVC.setValue(pushModel, forKey: "pushModel")
        }
        
        //找UITabBarController
        guard let tabBarController = self.window?.rootViewController as?UITabBarController else {
            print("UITabBarController找不到")
            return
        }
        //找UINavigationController
        guard let navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController else {
            print("navigationController找不到")
            return
        }
        //如果有Present上出的页面，可以通过 tabBarController调用Dismiss
//        tabBarController.dismiss(animated: true, completion: nil)
        
        clsVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(clsVC, animated: true)
    }
}























