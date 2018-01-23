//
//  DataLoader.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

protocol DataLoaderProtocol {
    func loadDataFromURL(path: String, completion: @escaping (_ data: Data?, _ error: NSError?) -> Void)
}

import Foundation

class DataLoader: DataLoaderProtocol {
    
    fileprivate let session = URLSession.shared
    
    func loadDataFromURL(path: String, completion: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        let url = NSURL(string: path)
        let request = URLRequest(url: url! as URL)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response:URLResponse?, error:Error?) in
            completion(data, error as NSError?)
        })
        
        task.resume()
    }
}
