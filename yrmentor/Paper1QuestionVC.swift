//
//  Paper1QuestionVC.swift
//  yrmentor
//
//  Created by Cyrus Chan on 6/4/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Paper1QuestionVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var answers:[AnswerVideo]=[]
    var year_received:String!

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = year_received
        
        myTableView.dataSource = self
        myTableView.delegate = self
         self.myTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        FIRDatabase.database().reference().child("paper1").child(year_received).observe(.childAdded) { (snapshot:FIRDataSnapshot) in
            let answer = AnswerVideo()
            if let dictionary = snapshot.value as? NSDictionary{
                if let fbanswer = dictionary["answer"] as? String{
                    answer.answer = fbanswer
                }
                if let fb_youtube = dictionary["youtube"] as? String{
                    answer.youtube = fb_youtube
                }
                
            }
            answer.uid = snapshot.key
            self.answers.append(answer)
            self.myTableView.reloadData()
            
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Paper1QuestonCell
       let answer = answers[indexPath.row]
        cell.questionLabel.text = answer.uid
        cell.answerLabel.text = answer.answer
        cell.updateUI()
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myTableView.estimatedRowHeight = 100
        myTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            performSegue(withIdentifier: "showPaper1Video", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPaper1Video") {
            let Paper1Video = segue.destination as! Paper1VideoVC
            if let indexpath = self.myTableView.indexPathForSelectedRow{
                let youtube_sent = answers[indexpath.row].youtube as String
                Paper1Video.youtube_received = youtube_sent
            
                
            }
        }
    }
    
    

}
