//
//  MovieDetailViewController.swift
//  muvvy
//
//  Created by Harley Trung on 8/27/15.
//  Copyright (c) 2015 Harley Trung. All rights reserved.
//

import UIKit
import PKHUD

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var placeholderImage: UIImage?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        titleLabel.text = movie.title
        synopsisLabel.text = movie.synopsis
        
        // cache using thumb first
        let request = NSURLRequest(URL: NSURL(string: movie.getHighResURL()!)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
        
        // no need for HUD because we are using a low res place holder image
//        PKHUD.sharedHUD.contentView = PKHUDProgressView()
//        PKHUD.sharedHUD.show()
        
        imageView.setImageWithURLRequest(request, placeholderImage: placeholderImage, success: { (request, response, image) -> Void in
            self.imageView.image = image
            
            if (response.statusCode != 0) {
                self.imageView.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: {
                    self.imageView.alpha = 1.0
                })
            } else {
                print("image cached")
            }
//            PKHUD.sharedHUD.hide(animated: true)
        }, failure: nil)
        // TODO:
//      }, failure: { (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
