//
//  CaTask.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/14.
//

import Foundation
import Alamofire

public class CaTask{
    
    var arg:CaArg
    var nCallMethod:Int
    var bShowWaitDialog:Bool
    var viewControl:AnyObject
    
    let toast:Toast = Toast()
    
    let strUrlApi:String = "https://www.egservice.co.kr:3187/api/"
    //let strUrlApi:String = "https://175.124.213.170:3187/api/"
    
    init(_ arg: CaArg, _ method: Int, _ showWait: Bool, _ viewController:AnyObject) {
        self.arg = arg
        self.nCallMethod = method
        self.bShowWaitDialog = showWait
        self.viewControl = viewController
    }
    
    func run() -> CaResult{
        
        print("CaTask: Task run")
        
        var result:CaResult = CaResult(JSONResult: [String:Any](), callback: 0)
        
        if(bShowWaitDialog){
            self.toast.showWaitDialog(viewControl)
        }
        
        let alamo = AF.request(strUrlApi + arg.command, method: .post, parameters: arg.args).validate(statusCode: 200..<300)
        
        print("CaTask: request is " + strUrlApi + arg.command)
        print("CaTask: request parameter is " + arg.args.description)
        
        alamo.responseJSON(){ response in
            
            if(self.bShowWaitDialog){
                // animation이 완전이 dismiss 된 이후에 코드가 작동하도록 수정
                self.viewControl.dismiss(animated: false){
                    
                    switch response.result {
                        case .success(let value):
                            let jsonObj = value as? [String: Any]
                            
                            print("CaTask: request response: " + jsonObj!.description)
                            print("CaTask: Call Method: " + String(self.nCallMethod))
                            
                            result.JSONResult = jsonObj!
                            result.callback = self.nCallMethod
                            
                            if self.viewControl is CustomUIViewController {
                                (self.viewControl as! CustomUIViewController).onResult(result)
                            }
                            
                        
                        case .failure(_):
                            self.toast.showToast(controller: self.viewControl, message: "Network Error!", seconds: 2.0)
                    }
                    
                }
            }
            else {
                switch response.result {
                    case .success(let value):
                        let jsonObj = value as? [String: Any]
                        
                        print("CaTask: request response: " + jsonObj!.description)
                        print("CaTask: Call Method: " + String(self.nCallMethod))
                        
                        result.JSONResult = jsonObj!
                        result.callback = self.nCallMethod
                        
                        // CustimUIViewController의 onResult를 호출함
                        // 만약 UIView말고 다른 UI에서도 onResult를 호출하고 싶다면, 그 UI를 override하는 Custom UI를 만든 후, onResult 함수를 만듦
                        if self.viewControl is CustomUIViewController {
                            (self.viewControl as! CustomUIViewController).onResult(result)
                        }
                        
                    
                    case .failure(_):
                        self.toast.showToast(controller: self.viewControl, message: "Network Error!", seconds: 2.0)
                }
            }
        }
        return result
    }
}
