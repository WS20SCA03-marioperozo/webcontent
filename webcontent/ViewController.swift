//
//  ViewController.swift
//  webcontent
//
//  Created by Mario Perozo on 5/31/20.
//  Copyright © 2020 Mario Perozo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var globalPrice : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func returnButtonPressed(_ sender: UITextField) {
        
        sender.resignFirstResponder();
        
        let address: String = "https://www.marketwatch.com/investing/stock/"
            + "\(sender.text!)";
        
        guard let url: URL = URL(string: address) else {
            print("Could not create URL from address \"\(address)\".");
            return;
        }
        
        guard let webPage: String = textFromURL(url: url) else {
            print("Received nothing from URL \"\(url)\".");
            return;
        }
        
        let s: String = "<meta name=\"price\" content=\"";
        guard let range: Range<String.Index> = webPage.range(of: s) else {
            print("\(s) not found");
            return;
        }
        
        let charAfterGreater: String.Index = range.upperBound; //the character after the ">"
        let restOfPage: Substring = webPage[charAfterGreater...];
        
        guard let lessThan: String.Index = restOfPage.firstIndex(of: "\"") else {
            print("Couldn't find <");
            return;
        }
        
        let priceAsString: Substring = restOfPage[..<lessThan];
        
        guard let price: Double = Double(priceAsString) else {
            print("Priece was not a Double");
            return;
        }
        
        
        globalPrice = price
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        guard let secondViewController: SecondViewController = segue.destination as? SecondViewController else {
            print("Destination was not SecondViewController.");
            return;
        }
        
        secondViewController.transferredPrice = String(globalPrice);
    }
    
    func textFromURL(url: URL) -> String? {
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
        var result: String? = nil;
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error: Error = error { //I hope this if is false.
                print(error);
            }
            if let data: Data = data {    //I hope this if is true.
                result = String(data: data, encoding: String.Encoding.utf8);
            }
            semaphore.signal();   //Cause the semaphore's wait method to return.
        }
        
        task.resume();    //Try to download the web page into the Data object, then execute the closure.
        semaphore.wait(); //Wait here until the download and closure have finished executing.
        return result;    //Do this return after the closure has finished executing.
    }
    
    
    
}
