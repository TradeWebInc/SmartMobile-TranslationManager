//
//  EnvironmentModel.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class EnvironmentModel: NSObject {
    var name:String = "";
    var tag:String = "";
    var isActive:Bool = true;
    
    init (name:String, tag:String, isActive:Bool) {
        self.name = name;
        self.tag = tag;
        self.isActive = isActive;
    }
}
