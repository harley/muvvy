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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    var movies: [NSDictionary]?
    var refreshControl:UIRefreshControl!
    var scopedMovies: [NSDictionary]?
    var searching: Bool = false

    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var moviesSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        loadMovies()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        self.networkErrorLabel.alpha = 1

        moviesTableView.dataSource = self
        moviesTableView.delegate = self

        moviesSearchBar.delegate = self
        moviesSearchBar.placeholder = "Enter text"
        moviesSearchBar.showsCancelButton = true

        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshMovies:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.addSubview(refreshControl)
    }
    
    func refreshMovies(sender: AnyObject) {
        loadMovies(refreshing: true)
    }
    
    func loadMovies(refreshing: Bool = false) {
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if response != nil {
                    self.networkErrorLabel.alpha = 0
                    
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        self.movies = json["movies"] as? [NSDictionary]
                        self.moviesTableView.reloadData()
                    }
                } else {
                    self.networkErrorLabel.alpha = 1
                }
                
                if refreshing {
                    self.refreshControl.endRefreshing()
                }
                
                PKHUD.sharedHUD.hide(animated: true)
                
                println("loaded")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
            UITableViewCell {
                var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
                let movie = Movie(dict: movies![indexPath.row])
                
                cell.titleLabel.text = movie.title
                cell.synopsisLabel.text = movie.synopsis
                
                let url = NSURL(string: movie.thumbImageURL)!
                let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 10)
                cell.posterView.setImageWithURLRequest(request, placeholderImage: nil, success: nil, failure: nil)
                
                let selectedBackgroundView = UIView()
                selectedBackgroundView.backgroundColor = UIColor.orangeColor()
                cell.selectedBackgroundView = selectedBackgroundView
                return cell
    }
    
    // change cell text colors when highlighting
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! MovieCell
        cell.titleLabel.textColor = UIColor.lightTextColor()
        cell.synopsisLabel.textColor = UIColor.lightTextColor()
    }

    // restore cell colors
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! MovieCell
        cell.titleLabel.textColor = UIColor.blackColor()
        cell.synopsisLabel.textColor = UIColor.blackColor()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return scopedMovies!.count
        } else {
            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
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
        let cell = sender as! MovieCell
        
        let indexPath = moviesTableView.indexPathForCell(cell)!
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailViewController
        
        movieDetailsViewController.movie = Movie(dict: movies![indexPath.row])
        movieDetailsViewController.placeholderImage = cell.posterView.image
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        moviesSearchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searching = true
            scopedMovies = movies?.filter {
                dict in
                let movie = Movie(dict: dict)
                let found = movie.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return found != nil
            }
        } else {
            self.searching = false
        }

        moviesTableView.reloadData()
    }
}