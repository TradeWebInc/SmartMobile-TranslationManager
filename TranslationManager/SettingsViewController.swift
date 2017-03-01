//
//  SettingsViewController.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    // IBOutlets
    @IBOutlet weak var translationsButtonLinked: UIBarButtonItem!;
    @IBOutlet weak var uploadButtonLinked: UIBarButtonItem!;
    @IBOutlet weak var languageTextFieldLinked: UITextField!;
    @IBOutlet weak var languageButtonLinked: UIButton!;
    @IBOutlet weak var clientTableLinked: UITableView!;
    @IBOutlet weak var environmentTableLinked: UITableView!;
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        
        self.addLabelWithString("Language", textField: self.languageTextFieldLinked);
        self.refreshView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    // ============================================================================
    // MARK: - IBActions
    // ============================================================================

    @IBAction func languageButtonPressed(_ sender: UIButton) {
        let controller:UIAlertController = UIAlertController(
            title: "Select Language",
            message: nil,
            preferredStyle: .actionSheet
        );
        
        for language in AppManager.sharedInstance.languages {
            controller.addAction(
                UIAlertAction(
                    title: "\(language.name) (\(language.cultureName))",
                    style: .default,
                    handler: { (action:UIAlertAction) in
                        AppManager.sharedInstance.loadTranslations(cultureName: language.cultureName);
                        self.refreshView();
                    }
                )
            );
        }
        
        controller.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
        );
        
        self.present(controller, animated: true, completion: nil);
    }
    
    @IBAction func clientSwitchToggled(_ sender:UISwitch) {
        let client:ClientModel = AppManager.sharedInstance.clients[sender.tag];
        client.isActive = sender.isOn;
    }
    
    @IBAction func environmentSwitchToggled(_ sender:UISwitch) {
        let environment:EnvironmentModel = AppManager.sharedInstance.environments[sender.tag];
        environment.isActive = sender.isOn;
    }
    
    
    // ============================================================================
    // MARK: - Action Methods
    // ============================================================================
    
    func refreshView() {
        self.languageTextFieldLinked.text = AppManager.sharedInstance.currentCultureName;
    }
    
    // ============================================================================
    // MARK: - Helper Methods
    // ============================================================================
    
    func addLabelWithString(_ string:String, textField:UITextField) {
        let label:UILabel = UILabel(frame: CGRect(x: 8, y: 0, width: 135, height: textField.frame.size.height));
        label.text = string + ":";
        label.textColor = UIColor.orange;
        label.textAlignment = .left
        
        let view:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 135, height: label.frame.size.height));
        view.addSubview(label);
        
        textField.placeholder = string;
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewMode.always;
    }
    
}

// ============================================================================
// MARK: - Extensions
// ============================================================================


// ============================================================================
// MARK: - UITableViewDataSource
// ============================================================================

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.clientTableLinked) { return AppManager.sharedInstance.clients.count; }
        else if (tableView == self.environmentTableLinked) { return AppManager.sharedInstance.environments.count; }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewCell;
        
        
        if (tableView == self.clientTableLinked) {
            // Get cell contents
            let cellmodel:ClientModel = AppManager.sharedInstance.clients[indexPath.row];
            
            cell.titleLabelLinked.text = cellmodel.name;
            cell.switchLinked.setOn(cellmodel.isActive, animated: false);
            cell.switchLinked.tag = indexPath.row;
            cell.switchLinked.addTarget(self, action: #selector(self.clientSwitchToggled(_:)), for: .valueChanged);
        }
        else if (tableView == self.environmentTableLinked) {
            // Get cell contents
            let cellmodel:EnvironmentModel = AppManager.sharedInstance.environments[indexPath.row];
            
            cell.titleLabelLinked.text = cellmodel.name;
            cell.switchLinked.setOn(cellmodel.isActive, animated: false);
            cell.switchLinked.tag = indexPath.row;
            cell.switchLinked.addTarget(self, action: #selector(self.environmentSwitchToggled(_:)), for: .valueChanged);
        }
        
        
        return cell;
    }
    
    
}
