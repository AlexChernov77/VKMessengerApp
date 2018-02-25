//
//  VKMAuthService.swift
//  VkMessenger
//
//  Created by Александр Чернов on 17.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import UIKit
import VK_ios_sdk

//MARK:- интерфейс
class VKMAuthService : NSObject
{
    static let sharedInstance = VKMAuthService()
    private let sdkInstance = VKSdk.initialize(withAppId: "6335075")
    
    weak var baseController : UIViewController?
    var success : (()->Void)?
    var failure : (()->Void)?
    
    func auth ( controller : UIViewController, success : @escaping () -> Void , failure : @escaping () -> Void )
    {
        if getAccessToken() != ""
        {
            success()
            return
        }
        
        self.baseController = controller
        self.success = success
        self.failure = failure
        
        let scope = ["friends", "messages", "offline"]
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        
        VKSdk.authorize(scope)
    }
}

//MARK:- логика авторизации
extension VKMAuthService : VKSdkUIDelegate, VKSdkDelegate
{
    func vkSdkShouldPresent(_ controller: UIViewController!)
    {
        baseController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!)
    {
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!)
    {
        let token = result.token
        
        if token != nil
        {
            let tokenSTR = token!.accessToken
            
            if tokenSTR != nil
            {
                setAccessToken ( token : tokenSTR! )
                success?()
                return
            }
        }
        
        failure?()
    }
    
    func vkSdkUserAuthorizationFailed()
    {
        print("обоссались при авторизации")
        failure?()
    }
    
    func process ( url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:])
    {
        VKSdk.processOpen(url, fromApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!)
    }
}


//MARK:- логика хранения токена
extension VKMAuthService
{
    func setAccessToken ( token : String )
    {
        UserDefaults.standard.set(token, forKey: "FUCK")
        UserDefaults.standard.synchronize()
    }
    
    func getAccessToken () -> String
    {
        if let tokenStr = UserDefaults.standard.object(forKey: "FUCK") as? String
        {
            return tokenStr
        }
        
        return ""
    }
}

