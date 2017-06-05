//
//  TranslationsViewController.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class TranslationsViewController: UIViewController {

    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    // IBOutlets
    @IBOutlet weak var tableViewLinked: UITableView!;
    
    // Variables
    var indexingDict:[Int:Int] = [:];
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Translations (\(AppManager.sharedInstance.translations.count))";
        
        self.tableViewLinked.rowHeight = UITableViewAutomaticDimension;
        self.tableViewLinked.estimatedRowHeight = 50;
        self.tableViewLinked.sectionIndexColor = UIColor(red: 1.0, green: 0.35, blue: 0, alpha: 1.0);
        
        self.formIndexingDictionary();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    // ============================================================================
    // MARK: - Action Methods
    // ============================================================================
    
    func formIndexingDictionary() {
        let collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.current();
        
        self.indexingDict = [:];
        var collationIndex:Int = 0;
        let collationCount:Int = collation.sectionIndexTitles.count;
        
        
        for jindex in collationIndex..<collationCount {
            let collationLetter:String = collation.sectionIndexTitles[jindex];
            
            for (index, value) in AppManager.sharedInstance.organizedTranslations.enumerated() {
                let firstLetter:String = value.indexLetter;
                if (firstLetter == collationLetter) {
                    collationIndex += 1;
                    self.indexingDict[jindex] = index;
                    break;
                }
            }
        }
        
        for (index, contactIndex) in self.indexingDict {
            print("Letter: \(collation.sectionIndexTitles[index]) Contact: \(AppManager.sharedInstance.organizedTranslations[contactIndex].sectionName)");
        }
    }
    
    
    // ============================================================================
    // MARK: - Helper Methods
    // ============================================================================

}


// ============================================================================
// MARK: - Extensions
// ============================================================================


// ============================================================================
// MARK: - UITableViewDelegate, UITableViewDataSource
// ============================================================================

extension TranslationsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppManager.sharedInstance.organizedTranslations.count;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AppManager.sharedInstance.organizedTranslations[section].sectionName.uppercased();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.sharedInstance.organizedTranslations[section].translations.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TranslationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TranslationTableViewCell;
        
        let cellModel:TranslationModel = AppManager.sharedInstance.organizedTranslations[indexPath.section].translations[indexPath.row];
        cell.keyLabelLinked.text = cellModel.key;
        cell.textLabelLinked.text = cellModel.text;
        
        return cell;
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionIndexTitles;
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        for i in stride(from: index, through: 0, by: -1) {
            if let sectionNum:Int = self.indexingDict[i] {
                let collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.current();
                print("i: \(i) index: \(index) Section Num: \(sectionNum) Letter Selected: \(collation.sectionIndexTitles[index]) Letter Used: \(collation.sectionIndexTitles[i]) Value Used: \(AppManager.sharedInstance.organizedTranslations[sectionNum].sectionName)");
                return sectionNum;
            }
        }
        
        return AppManager.sharedInstance.organizedTranslations.count-1;
    }
    
}
