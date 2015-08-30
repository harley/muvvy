//
//  MovieDetailViewController.swift
//  muvvy
//
//  Created by Harley Trung on 8/27/15.
//  Copyright (c) 2015 Harley Trung. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        var url = movie!.valueForKeyPath("posters.detailed") as! String
        var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            self.imageView.image = image
            
            if (response.statusCode != 0) {
                self.imageView.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: {
                    self.imageView.alpha = 1.0
                })
            } else {
                print("image cached")
            }
            
        }, failure: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    var movie: NSDictionary!
    /*

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
