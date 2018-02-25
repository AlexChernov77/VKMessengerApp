//
//  API_WRAPPER.swift
//  VkMessenger
//
//  Created by Александр Чернов on 17.01.2018.
//  Copyright © 2018 Александр Чернов. All rights reserved.
//

import Foundation
import  SwiftyJSON


class API_WRAPPER {
    
    private class func completionHandler(withResponseData data: Data?, response: URLResponse?, error: Error?, successBlock: (_ jsonResponse: JSON) -> Void, failureBlock: (_ errorCode: Int) -> Void)
    {
        if (error != nil)
        {
            failureBlock((error! as NSError).code)
        }
        
        if (data != nil)
        {
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let swiftyJSON = JSON(json)
                print("ответ - \(swiftyJSON)")
                successBlock(swiftyJSON)
            }
            catch
            {
                failureBlock(-80)
            }
        }
        else
        {
            failureBlock(-80)
        }
    }

    
    class func getJsonDialog (count: Int, offset: Int, succBlock: @escaping (JSON) -> Void, failBlock: @escaping (_ errorDesc: Int) -> Void) -> URLSessionDataTask
    {
        
        
        let argsDictionary = NSMutableDictionary ()
        
        argsDictionary.setObject("\(count)", forKey: Const.URLConst.Arguments.kCount)
        argsDictionary.setObject("\(offset)", forKey: Const.URLConst.Arguments.kOffset)
        argsDictionary.setObject(VKMAuthService.sharedInstance.getAccessToken(), forKey: Const.URLConst.Arguments.kAccessToken)
        
        let request = API_Configurator.createRequest(forBaseURL: Const.URLConst.kBaseURL, andMethod: Const.URLConst.Scripts.kMethodMessage, withParametrs: argsDictionary)
        
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: succBlock, failureBlock: failBlock)
        }
        dataTask.resume()
         return dataTask
    }
    
    class func getJsonUser (usersId: String, succBlock: @escaping (JSON) -> Void,
                            failBlock: @escaping (_ errorDesc: Int) -> Void) -> URLSessionDataTask
    {
        let agrsDictionary = NSMutableDictionary ()
        
        agrsDictionary.setObject("\(usersId)", forKey: Const.URLConst.Arguments.kUser)
        agrsDictionary.setObject("photo_100,photo_50", forKey: Const.URLConst.Arguments.kFields)
        agrsDictionary.setObject(VKMAuthService.sharedInstance.getAccessToken(), forKey: Const.URLConst.Arguments.kAccessToken)
        
        let request = API_Configurator.createRequest(forBaseURL: Const.URLConst.kBaseURL, andMethod: Const.URLConst.Scripts.kMethodUser, withParametrs: agrsDictionary)
        
        
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: succBlock, failureBlock: failBlock)
            }
        dataTask.resume()
        return dataTask
    }
    
    
    class func getChat (offset: Int, count: Int, peer_id: Int64, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void) -> URLSessionDataTask
    {
         let agrsDictionary = NSMutableDictionary()
        agrsDictionary.setObject("\(offset)", forKey: Const.URLConst.Arguments.kOffset)
        agrsDictionary.setObject("\(count)", forKey: Const.URLConst.Arguments.kCount)
        agrsDictionary.setObject("\(peer_id)" , forKey: Const.URLConst.Arguments.kPeer_id)
        agrsDictionary.setObject(VKMAuthService.sharedInstance.getAccessToken(), forKey: Const.URLConst.Arguments.kAccessToken)
        
        let request = API_Configurator.createRequest(forBaseURL: Const.URLConst.kBaseURL, andMethod: Const.URLConst.Scripts.kChat, withParametrs: agrsDictionary)
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: success, failureBlock: failure)
        }
        dataTask.resume()
        return dataTask
    }
    
    
    class func sendMessage ( peer_id: Int64, message: String, random_id: Int, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void)
    {
        let agrsDictionary = NSMutableDictionary()
        let encodeMessage = message.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        agrsDictionary.setObject("\(peer_id)" , forKey: Const.URLConst.Arguments.kPeer_id)
        agrsDictionary.setObject(encodeMessage!, forKey: Const.URLConst.Arguments.kMessage)
        agrsDictionary.setObject("\(random_id)", forKey: Const.URLConst.Arguments.kRandom_id)
        agrsDictionary.setObject(VKMAuthService.sharedInstance.getAccessToken(), forKey: Const.URLConst.Arguments.kAccessToken)
        
        let request = API_Configurator.createRequest(forBaseURL: Const.URLConst.kBaseURL, andMethod: Const.URLConst.Scripts.kSendMessage, withParametrs: agrsDictionary)
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: success, failureBlock: failure)
        }
        dataTask.resume()
    }
    
    
     class func getLongPollServer(success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void)
     {
        let agrsDictionary = NSMutableDictionary()
        
        agrsDictionary.setObject("1", forKey: "need_pts" as NSCopying )
        agrsDictionary.setObject("2", forKey: "lp_version" as NSCopying)
        agrsDictionary.setObject(VKMAuthService.sharedInstance.getAccessToken(), forKey: Const.URLConst.Arguments.kAccessToken)
        
        let request = API_Configurator.createRequest(forBaseURL: Const.URLConst.kBaseURL, andMethod: Const.URLConst.Scripts.kGetLongPoll, withParametrs: agrsDictionary)
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: success, failureBlock: failure)
        }
        dataTask.resume()
     }
    
    class func connectToLongPoll (server: String, key: String, ts: Int, success: @escaping (JSON) -> Void, failure: @escaping (Int) -> Void)
    {
        let url = "https://\(server)?act=a_check&key=\(key)&ts=\(ts)&wait=25&mode=2&version=2"
        
        let request = NSMutableURLRequest ()
        request.httpMethod = "GET"
        request.url = URL(string: url)
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            completionHandler(withResponseData: data, response: response, error: error, successBlock: success, failureBlock: failure)
        }
        dataTask.resume()
    }
    
}

