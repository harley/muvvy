//
//  MoviesViewController.swift
//  muvvy
//
//  Created by Harley Trung on 8/27/15.
//  Copyright (c) 2015 Harley Trung. All rights reserved.
//

import UIKit
import AFNetworking
import PKHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies: [NSDictionary]?
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        println("movies")
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    self.movies = json["movies"] as? [NSDictionary]
                    self.moviesTableView.reloadData()
                }
                
                PKHUD.sharedHUD.hide(animated: true)

                println("loaded")
            
//                println(self.movies)
            }
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
            UITableViewCell {
                var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
                let movie = movies![indexPath.row]
                
                cell.titleLabel.text = movie["title"] as? String
                cell.synopsisLabel.text = movie["synopsis"] as? String
                
                let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
                cell.posterView.setImageWithURL(url)
                
                return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("deselecting")
        moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("Segue!")
        let cell = sender as! UITableViewCell
        
        let indexPath = moviesTableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        
        movieDetailsViewController.movie = movie
    }
    
}
