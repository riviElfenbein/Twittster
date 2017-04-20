//
//  ViewController.swift
//  Twittster
//
//  Created by Rivi Elfenboim on 18/04/2017.
//  Copyright © 2017 Rivi Elfenboim. All rights reserved.
//

import UIKit
import TwitterKit
import MBProgressHUD
import TwittsterApi


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = Array<TWTRTweet>()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: searchBar))!{
            return false
           
        } else {
            searchBar.resignFirstResponder()
        }
        return true
    }
    
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let tweet = tweets[indexPath.row]
        let cell = TWTRTweetTableViewCell(style: .default, reuseIdentifier: "TweetTableReuseIdentifier")
        cell.configure(with: tweet)
        cell.tweetView.showBorder = true
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tweets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200.0
       
    }
    
    //MARK: Search funcs 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            startSearching(searchStr: searchBar.text!)
            
        }
        searchBar.resignFirstResponder()
        
    }
    
    
    func startSearching(searchStr:String) {
        MBProgressHUD.showAdded(to: view, animated: true)
        Api.startSearchByWord(client: TWTRAPIClient(), searchWord: searchStr, sucess: {(results) -> () in
            if results != nil && results!.count > 0 {
                self.tweets = results!
                DispatchQueue.main.async(execute: { () -> Void in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                })
            } else  {
                
                DispatchQueue.main.async(execute: { () -> Void in
                   MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.isHidden = true
                    self.noResultsLabel.text = "Nothing comes up in search, which is a little strange. Maybe you should check what you were looking for and try again."
                     self.noResultsLabel.isHidden = false
                })
                
            }
            
            
        },failure: {(error)-> () in
            DispatchQueue.main.async(execute: { () -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.isHidden = true
                self.noResultsLabel.text = error?.localizedDescription
                self.noResultsLabel.isHidden = false
            })

            
        })
        
    }
    
    

    
        
    
    //MARK: LifeSycle funcs:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        noResultsLabel.isHidden = true
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.delegate = self
        
        self.view.addGestureRecognizer(gestureRecognizer)
        
     }

  

}

