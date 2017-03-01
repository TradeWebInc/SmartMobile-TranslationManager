//
//  ReviewViewController.swift
//  TranslationManager
//
//  Created by Jeunesse Development on 2/27/17.
//  Copyright © 2017 Jeunesse Global. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    // IBOutlets
    @IBOutlet weak var languageValuesLabelLinked: UILabel!;
    @IBOutlet weak var clientValuesLabelLinked: UILabel!;
    @IBOutlet weak var environmentValuesLabelLinked: UILabel!;
    @IBOutlet weak var translationsValueLabelLinked: UILabel!;
    @IBOutlet weak var confirmButtonLinked: UIButton!;
    
    @IBOutlet weak var resultsViewLinked: UIView!;
    @IBOutlet weak var startedValueLabelLinked: UILabel!;
    @IBOutlet weak var successfulValueLabelLinked: UILabel!;
    @IBOutlet weak var failedValueLabelLinked: UILabel!;
    @IBOutlet weak var completionValueLabelLinked: UILabel!;
    
    
    // Variables
    var processing:Bool = false;
    var countStarted:Int = 0;
    var countSuccessful:Int = 0;
    var countFailed:Int = 0;
    var countComplete:Int { return self.countSuccessful + self.countFailed; }
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        
        self.languageValuesLabelLinked.text = AppManager.sharedInstance.currentCultureName;
        self.clientValuesLabelLinked.text = AppManager.sharedInstance.clients.filter{$0.isActive == true}.flatMap({$0.tag}).joined(separator: ", ");
        self.environmentValuesLabelLinked.text = AppManager.sharedInstance.environments.filter{$0.isActive == true}.flatMap({$0.tag}).joined(separator: ", ");
        self.translationsValueLabelLinked.text = "\(AppManager.sharedInstance.translations.count)";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    // ============================================================================
    // MARK: - IBActions
    // ============================================================================
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        self.processUpload();
    }
    

    // ============================================================================
    // MARK: - Action Methods
    // ============================================================================
    
    func processUpload() {
        
        self.processing = true;
        self.confirmButtonLinked.isEnabled = false;
        
        for client in AppManager.sharedInstance.clients {
            if (client.isActive == true) {
                for environment in AppManager.sharedInstance.environments {
                    if (environment.isActive == true) {
                        
                        if let baseURL:String = (AppManager.sharedInstance.URLS[client.tag] as! [String:String])[environment.tag] {
                            
                            for translation in AppManager.sharedInstance.translations {
                                
                                let params:[String:String] = [
                                    "TranslationKey": translation.key,
                                    "CultureName": AppManager.sharedInstance.currentCultureName,
                                    "Text": translation.text
                                ]
                                
                                if let request:URLRequest = (try? JLHttpSession.sharedInstance.formRequestWithURL(url: "\(baseURL)AddUpdateMobileTranslation/", method: "POST", params: params, headers: nil, json: true)) {
                                    
                                    self.translationStarted();
                                    JLHttpSession.sharedInstance.sendAsyncRequest(
                                        request: request,
                                        success: { (response:URLResponse, data:Data) in
                                            
                                            if let jsonData:[String:AnyObject] = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String:AnyObject] {
                                                
                                                DispatchQueue.main.async { print("Parsing Response: \(translation.key) - \(jsonData)"); }
                                                
                                                let apiResponse:WebAPIResponse = WebAPIResponse(dataDictionary: jsonData);
                                                if (apiResponse.success == 1) {
                                                    DispatchQueue.main.async { self.translationsSucceeded(); }
                                                } else { DispatchQueue.main.async { self.translationFailed(); } }
                                            } else { DispatchQueue.main.async { self.translationFailed(); } }
                                            
                                        },
                                        failure: { (response:URLResponse?, error:Error?) in
                                            DispatchQueue.main.async { self.translationFailed(); }
                                        }
                                    );
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func translationStarted() {
        self.countStarted += 1;
        self.refreshResults();
    }
    
    func translationsSucceeded() {
        self.countSuccessful += 1;
        self.refreshResults();
    }
    
    func translationFailed() {
        self.countFailed += 1;
        self.refreshResults();
    }
    
    func refreshResults() {
        self.startedValueLabelLinked.text = "\(self.countStarted)";
        self.successfulValueLabelLinked.text = "\(self.countSuccessful)";
        self.failedValueLabelLinked.text = "\(self.countFailed)";
        if (self.countStarted != 0) {
            let percent:Double = (Double(self.countComplete)/Double(self.countStarted))*100.0;
            self.completionValueLabelLinked.text = String(format: "%.2f%%", percent);
        }
        else { self.completionValueLabelLinked.text = "0%"; }
        
        
        if (self.countComplete == self.countStarted) {
            self.confirmButtonLinked.isEnabled = true;
        }
    }
    
}
