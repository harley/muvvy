//
//  DvdsViewController.swift
//  muvvy
//
//  Created by Harley Trung on 9/1/15.
//  Copyright (c) 2015 Harley Trung. All rights reserved.
//

import UIKit

class DvdsViewController: ParentViewController {

    override func viewDidLoad() {

        self.remoteSourceUrl = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("Segue!")
        let cell = sender as! MovieCell
        
        let indexPath = moviesTableView.indexPathForCell(cell)!
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        
        movieDetailsViewController.movie = Movie(dict: movies![indexPath.row])
        movieDetailsViewController.placeholderImage = cell.posterView.image
    }

}
