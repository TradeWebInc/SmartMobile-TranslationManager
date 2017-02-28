//
//  TranslationModel.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class TranslationModel: NSObject {
    var key:String = "";
    var text:String = "";
    
    init(key:String, text:String) {
        self.key = key;
        self.text = text;
    }
}
