//
//  JLHttpSession.swift
//  NSURLSessionTests
//
//  Created by Jeunesse Development on 8/8/16.
//  Copyright © 2016 Jaron Lowe. All rights reserved.
//

import UIKit


// ============================================================================
// MARK: - Enums
// ============================================================================

enum JLHttpSessionError: Error {
    case basicError(errorMessage:String)
}


class JLHttpSession: NSObject {
    
    // ============================================================================
    // MARK: - Properties
    // ============================================================================
    
    // Singleton Property
    static let sharedInstance = JLHttpSession();
    
    var headers:[String: String] = [:];
    var session:URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral);
    
    
    // ============================================================================
    // MARK: - Action Methods
    // ============================================================================

    // Forms a request based on passed in parameters
    func formRequestWithURL(url:String, method:String, params:[String: Any]?, headers:[String: String]?, json:Bool) throws -> URLRequest {
        
        var fullURL = url;
        
        // Form and add GET params
        var paramString:String = "";
        if (params != nil) { paramString = JLHttpSession.formatURLParameters(params: params!, method:method); }
        if (method == "GET") { fullURL = fullURL + paramString; }
        
        // Create request
        fullURL = fullURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        if let requestURL:URL = URL(string: fullURL) {
            var request:URLRequest = URLRequest(url: requestURL);
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
            
            
            // Add headers to request
            if (headers == nil) {request.allHTTPHeaderFields = self.headers;}
            else {
                
                // Combine and attach headers
                if let paramHeaders:[String: String] = headers {
                    for (key, value) in paramHeaders {
                        self.headers[key] = value;
                    }
                }
                
                request.allHTTPHeaderFields = self.headers;
            }
            
            // Handle POST
            if (method == "POST") {
                
                // Set method and content type
                request.httpMethod = "POST";
                
                if (json == true) {
                    // JSON Content-Type
                    request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type");
                    
                    // JSON Encoded body parameters
                    if params != nil {
                        if let data:Data = try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted) {
                            request.addValue("\(data.count)", forHTTPHeaderField:"Content-Length");
                            request.httpBody = data;
                        }
                    }
                    
                } else {
                    // x-www-form-urlencoded Content-Type
                    request.addValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type");
                    
                    // Get encoded body parameters
                    // Attach parameter body data
                    if let data:Data = paramString.data(using: String.Encoding.utf8) {
                        request.addValue("\(data.count)", forHTTPHeaderField:"Content-Length");
                        request.httpBody = data;
                    }
                }
                
            }
            
            return request;
        }
        else { throw JLHttpSessionError.basicError(errorMessage: "The request could not be built. Invalid URL passed."); }
        
    }
    
    // Sends a synchronous HTTP request
    func sendSyncRequest(request:URLRequest) -> Data? {
     
        // * DEBUG *
        /*
        if (request.HTTPBody != nil) {
            if let requestBody:NSString = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding) {
                dispatch_async(dispatch_get_main_queue()) {print("Request: \(request)\n\(requestBody)\n\(request.allHTTPHeaderFields)")};
            }
        }
        */
        
        var returnData:Data? = nil;
        let semaphore:DispatchSemaphore = DispatchSemaphore(value: 0);
        let dataTask:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: {(data:Data?, response:URLResponse?, error:Error?) in
            
            returnData = data;
            
            // Check for error
            if (error != nil) {
                returnData = nil;
                print("Synchronous Request Error: \(error!) Request: \(request.allHTTPHeaderFields!)\n\(request.url)");
            }
            
            if let httpResponse:HTTPURLResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200) {
                    returnData = nil;
                    print("Request Failed. HTTP Status code: \(httpResponse.statusCode)");
                }
            }
            
            semaphore.signal()
        });
        
        dataTask.resume();
        _ = semaphore.wait(timeout: DispatchTime.distantFuture);
        
        URLCache.shared.removeAllCachedResponses();
            
        return returnData;
    }
    
    // Sends a asynchronous HTTP request
    func sendAsyncRequest(request:URLRequest, success:@escaping (_ response:URLResponse, _ data:Data) ->(), failure:@escaping (_ response:URLResponse?, _ error:Error?) ->()) {
        
        // * DEBUG *
        /*
        if (request.HTTPBody != nil) {
            if let requestBody:NSString = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding) {
                dispatch_async(dispatch_get_main_queue()) {print("Request: \(request)\n\(requestBody)\n\(request.allHTTPHeaderFields)")};
            }
        }
        */
        
        // Display network activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        let dataTask:URLSessionDataTask = self.session.dataTask(with: request, completionHandler: {(data:Data?, response:URLResponse?, error:Error?) in
            
            // Hide network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
            URLCache.shared.removeAllCachedResponses();
            
            // Verify that response was HTTP
            if let httpResponse:HTTPURLResponse = response as? HTTPURLResponse {
                
                // Check for error
                if (error == nil) {
                    
                    // Check status code
                    if (httpResponse.statusCode == 200) {
                        if (data != nil) { success(httpResponse, data!); }
                        else {failure(httpResponse, error);}
                    }
                    else {failure(httpResponse, error);}
                    
                } else {failure(httpResponse, error);}
            } else {failure(response, error);}
        });
        
        dataTask.resume();
        
    }
    
    
    // ============================================================================
    // MARK: - Class Methods
    // ============================================================================
    
    // Returns a GET parameter string from a dictionary of parameters
    class func formatURLParameters(params:[String: Any], method:String) -> String {
        var paramString:String = "";
        
        let paramCount:Int = params.count;
        if (paramCount > 0 && method != "POST") {paramString = "?";}
        
        var i:Int = 0;
        for (key, value) in params {
            paramString = paramString + "\(key)=\(value)";
            
            i += 1;
            if (i != paramCount) {paramString = paramString + "&";}
        }
        return paramString;
    }
    
    // Converts a string to a base64 encode string
    class func base64StringFromString(string:String) -> String {
        
        var resultString = "";
        
        // UTF 8 str from original
        // NSData! type returned (optional)
        if let utf8Data:Data = string.data(using: String.Encoding.utf8) {
            
            let base64EncodedString:String = utf8Data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            resultString = base64EncodedString;
            
        }
        
        return resultString;
        
    }
    
    // Returns a basic auth header string
    class func basicAuthHeader(username:String, password:String) -> String {
        return "Basic " + JLHttpSession.base64StringFromString(string: "\(username):\(password)");
    }
    
    // Clears any cookies stored by the OS
    class func clearStoredCookies() {
        let cookieStorage:HTTPCookieStorage = HTTPCookieStorage.shared;
        if let cookies:[HTTPCookie] = cookieStorage.cookies {
            for cookie:HTTPCookie in cookies {
                cookieStorage.deleteCookie(cookie);
            }
        }
    }
    
    
}

