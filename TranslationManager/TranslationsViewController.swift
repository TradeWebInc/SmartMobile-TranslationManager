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
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        
        self.tableViewLinked.rowHeight = UITableViewAutomaticDimension;
        self.tableViewLinked.estimatedRowHeight = 50;
        
        self.navigationItem.title = "Translations (\(AppManager.sharedInstance.translations.count))";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}

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
    
    
}
