/**
 * Copyright (C) 2015 JianyingLi <lijy91@foxmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ObjectMapper

class Auth {

    static func check() -> Bool {
        return user() != nil
    }
    
    static func check(controller: UIViewController) -> Bool {
        if (!check()) {
            let loginController: BaseNavigationController = BaseNavigationController(rootViewController: LoginController())
            controller.presentViewController(loginController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    static func id() -> Int {
        if (user() != nil) {
            return (user()?.id)!
        }
        return 0
    }
    
    static func user() -> User! {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let jsonString = standardUserDefaults.stringForKey("auth.user")
        if (jsonString != nil && jsonString != "") {
            let user: User? = Mapper<User>().map(jsonString!)
            return user
        }
        return nil
    }
    
    static func user(user: User?) {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let jsonString = user == nil ? "" : Mapper<User>().toJSONString(user!, prettyPrint: false)
        standardUserDefaults.setValue(jsonString, forKey: "auth.user")
        
        NSNotificationCenter.defaultCenter().postNotificationName("LoginStatusChangedEvent", object: nil)
    }
    
    static func jwtToken() -> AccessToken! {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let jsonString = standardUserDefaults.stringForKey("auth.jwt_token")
        if (jsonString != nil && jsonString != "") {
            let jwtToken: AccessToken? = Mapper<AccessToken>().map(jsonString!)
            return jwtToken
        }
        return nil
    }
    
    static func jwtToken(user: AccessToken?) {
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        let jsonString = user == nil ? "" : Mapper<AccessToken>().toJSONString(user!, prettyPrint: false)
        standardUserDefaults.setValue(jsonString, forKey: "auth.jwt_token")
    }
}
