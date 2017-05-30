//
//  Paper1VC.swift
//  yrmentor
//
//  Created by Cyrus Chan on 5/4/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import FirebaseDatabase

class Paper1VC: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
var years :[Year]=[]
        
    @IBOutlet weak var Paper1HomeBanner: GADBannerView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        Paper1HomeBanner.adUnitID = "ca-app-pub-4445124176774275/8836884140"
        Paper1HomeBanner.rootViewController = self
        Paper1HomeBanner.delegate = self
        Paper1HomeBanner.load(request)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        FIRDatabase.database().reference().child("paper1").observe(.childAdded) { (snapshot:FIRDataSnapshot) in
            let year = Year()
            
            year.uid = snapshot.key
            self.years.append(year)
            self.myTableView.reloadData()
            self.myTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        }
            }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Paper1VC_years_cell
        let year = years[indexPath.row]
    cell.yearlabel.text = year.uid
       

        cell.updateUI()
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPaper1Question", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showPaper1Question"){
            
            let Paper1Question = segue.destination as! Paper1QuestionVC
            if let indexpath = self.myTableView.indexPathForSelectedRow{
                let year_sent = years[indexpath.row].uid as String
                Paper1Question.year_received = year_sent
            }
            
        }
        
    }
    

    
}
