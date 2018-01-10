//
//  LanguageModel.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 3/1/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class LanguageModel: NSObject {
    
    var name:String = "";
    var cultureName:String = "";
    var uploadCultureName:String? = nil;
    
    init(name:String, cultureName:String, uploadCultureName:String? = nil) {
        self.name = name;
        self.cultureName = cultureName;
        self.uploadCultureName = uploadCultureName;
    }
    
}
