//
//  SettingsTableViewCell.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    @IBOutlet weak var titleLabelLinked: UILabel!;
    @IBOutlet weak var switchLinked: UISwitch!;
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
