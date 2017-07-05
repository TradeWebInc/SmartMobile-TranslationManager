//
//  AppManager.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

// ============================================================================
// MARK: - Class Creation
// ============================================================================

class AppManager : NSObject {
    
    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    // Singleton Property
    static let sharedInstance = AppManager();

    var currentCultureName:String = "en";
    var languages:[LanguageModel] = [
        LanguageModel(name: "English", cultureName: "en"),
        LanguageModel(name: "Spanish", cultureName: "es"),
        LanguageModel(name: "French", cultureName: "fr"),
        LanguageModel(name: "Danish", cultureName: "da"),
        LanguageModel(name: "Indonesian", cultureName: "id"),
        LanguageModel(name: "Italian", cultureName: "it"),
        LanguageModel(name: "Japanese", cultureName: "ja"),
        LanguageModel(name: "Korean", cultureName: "ko"),
        LanguageModel(name: "Malay", cultureName: "ms"),
        LanguageModel(name: "Portuguese", cultureName: "pt"),
        LanguageModel(name: "Russian", cultureName: "ru"),
        LanguageModel(name: "Thai", cultureName: "th"),
        LanguageModel(name: "Chinese (Simplified)", cultureName: "zh-Hans"),
        LanguageModel(name: "Chinese (Traditional)", cultureName: "zh-Hant")
    ];
    
    var clients:[ClientModel] = [
        ClientModel(name: "SmartMobile", tag: "SM", isActive: true),
        ClientModel(name: "JMobile", tag: "JM", isActive: true),
        ClientModel(name: "ZMobile", tag: "ZM", isActive: true),
        ClientModel(name: "Avon Spark", tag: "AS", isActive: true),
    ];
    var environments:[EnvironmentModel] = [
        EnvironmentModel(name: "Development", tag: "DEV", isActive: false),
        EnvironmentModel(name: "Test", tag: "TEST", isActive: false),
        EnvironmentModel(name: "Stage", tag: "STG", isActive: false),
        EnvironmentModel(name: "Production", tag: "PROD", isActive: true),
    ];
    
    var URLS:[String:Any] = [
        "SM":[
            "DEV":"https://admin.smartmobiledirectdev.com/api/",
            "PROD":"https://admin.smartmobiledirect.com/api/"
        ],
        "JM":[
            "DEV":"https://jadmin2.jeunesseglobalbuild.com/api/",
            "TEST":"https://jadmin2.jeunesseglobaltest.com/api/",
            "STG":"https://jadmin2.jeunesseglobalstage.com/api/",
            "PROD":"https://jadmin2.jeunesseglobal.com/api/"
        ],
        "ZM":[
            "DEV":"https://zurvita.smartmobiledirectdev.com/api/",
            "PROD":"https://zurvita.smartmobiledirect.com/api/"
        ],
        "AS":[
            "DEV":"https://avonca.smartmobiledirectdev.com/api/",
            "PROD":"https://avonca.smartmobiledirect.com/api/"
        ],
    ];
    
    var translations:[TranslationModel] = [];
    var organizedTranslations:[TranslationListModel] = [];
    
    override init() {
        super.init();
        
        self.loadTranslations(cultureName: self.currentCultureName);
    }
    
    func loadTranslations(cultureName:String) {
        
        self.translations = [];
        self.organizedTranslations = [];
        self.currentCultureName = cultureName;
        
        // Get .strings filepath
        if let path:String = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: cultureName) {
            
            // Get contents of .strings file
            if let dict:NSDictionary = NSDictionary(contentsOfFile: path) {
                
                // Parse to swift dictionary
                if let swiftDict:[String: String] = dict as? [String: String] {
                    print("Localizable Strings: \nCount: \(dict.count)\n\(dict) ")
                    
                    // Loop through and insert new translations
                    for (key, value) in swiftDict {
                        var escapedValue:String = value.replacingOccurrences(of: "\\", with: "\\\\");
                        escapedValue = escapedValue.replacingOccurrences(of: "\"", with: "\\\"");
                        escapedValue = escapedValue.replacingOccurrences(of: "\'", with: "\\\'");
                        escapedValue = escapedValue.replacingOccurrences(of: "\n", with: "\\n");
                        escapedValue = escapedValue.replacingOccurrences(of: "\t", with: "\\t");
                        escapedValue = escapedValue.replacingOccurrences(of: "\r", with: "\\r");
                        
                        self.translations.append(TranslationModel(key:key, text:escapedValue));
                    }
                    self.translations.sort(by: {$0.key < $1.key});
                    
                    for translation in translations {
                        
                        let sectionName:String = translation.key.components(separatedBy: "_")[0];
                        
                        
                        if let existingListModel:TranslationListModel = self.organizedTranslations.filter({$0.sectionName == sectionName}).first {
                            existingListModel.translations.append(translation);
                        }
                        else {
                            let newListModel:TranslationListModel = TranslationListModel();
                            newListModel.sectionName = sectionName;
                            newListModel.translations.append(translation);
                            self.organizedTranslations.append(newListModel);
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
}
