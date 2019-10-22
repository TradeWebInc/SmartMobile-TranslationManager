//
//  TranslationListModel.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/28/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class TranslationListModel: NSObject {
    var sectionName:String = "";
    var translations:[TranslationModel] = [];
    
    var indexLetter:String {
        let name:String = self.sectionName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased();
        if (name.isEmpty == false) { return String(name.first!); }
        return "";
    }
    
}
