//
//  WebAPIResponse.swift
//  SmartMobile
//
//  Created by Jeunesse Development on 7/29/15.
//  Copyright (c) 2015 Jeunesse Global. All rights reserved.
//

import UIKit


class WebAPIResponse: NSObject {
    
    
    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    var success:Int = 0;
    var userMessage:String = "";
    var developerMessage:String = "";
    var data:Any? = nil;
    
    override var description: String {
        return "API Response:\nSuccess: \(self.success)\nUserMessage: \(self.userMessage)\nDeveloperMessage: \(self.developerMessage)\nData: \(String(describing: self.data))";
    }
   
    init(dataDictionary:[String:Any]) {
        if let data:Bool = dataDictionary["success"] as? Bool {self.success = (data == true) ? 1 : 0;}
        if let data:String = dataDictionary["userMessage"] as? String {self.userMessage = data;}
        if let data:String = dataDictionary["developerMessage"] as? String {self.developerMessage = data;}
        if let data:Any = dataDictionary["data"] {self.data = data;}
    }
}
