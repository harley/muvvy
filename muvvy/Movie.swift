//
//  Movie.swift
//  muvvy
//
//  Created by Harley Trung on 9/1/15.
//  Copyright (c) 2015 Harley Trung. All rights reserved.
//

import Foundation

class Movie: NSObject {
    let title: String
    let synopsis: String
    let thumbImageURL: String
    let origImageURL: String
    
    init(dict: NSDictionary) {
        self.title    = dict["title"] as! String
        self.synopsis = dict["synopsis"] as! String
        self.thumbImageURL = dict.valueForKeyPath("posters.thumbnail") as! String
        self.origImageURL  = dict.valueForKeyPath("posters.original") as! String
    }
    
    func getHighResURL() -> String? {
        if origImageURL != "" {
            var range = origImageURL.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                return origImageURL.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}