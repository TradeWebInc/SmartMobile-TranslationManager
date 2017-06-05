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
        if (self.sectionName.characters.count > 0) { return String(self.sectionName.uppercased().trimmingCharacters(in: .whitespacesAndNewlines).characters.first!); }
        return "";
    }
    
}
