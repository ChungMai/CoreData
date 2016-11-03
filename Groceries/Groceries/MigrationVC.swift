//
//  MigrationVC.swift
//  Groceries
//
//  Created by Home on 10/31/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import UIKit

class MigrationVC: UIViewController {

    @IBOutlet var progress: UIProgressView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(progressChanged(note:)), name:Notification.Name("migrationProgress"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:Notification.Name("migrationProgress"), object: nil)
    }
    func progressChanged (note:AnyObject?){
        if let note = note as? NSNotification{
            if let progress = note.object as? NSNumber{
                let progressFloat:Float = round(progress.floatValue * 100)
                let text = "Migration Progress: \(progressFloat)%"
                print(text)
                
                DispatchQueue.main.async {
                    self.label.text = text
                    self.progress.progress = progress.floatValue
                }
            }
            else{
                print("\(#function) failed to get progress")
            }
            
        }
        else {
            print("\(#function) failed to get note")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
