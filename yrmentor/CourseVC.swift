//
//  CourseVC.swift
//  yrmentor
//
//  Created by Cyrus Chan on 31/5/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import StoreKit
import SDWebImage


class CourseVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate {

    var corecourses :[CoreCourse]=[]
    var courses :[Course]=[]
    var products = [SKProduct]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FIRDatabase.database().reference().child("courses").observe(.childAdded) { (snapshot:FIRDataSnapshot) in
            
            
            let course = Course()
            
            if let dictionary = snapshot.value as? NSDictionary{
                if let fbdiscription = dictionary["discription"] as? String{
                    course.discription = fbdiscription
                }
                if let fbimage = dictionary["image"] as? String{
                    course.image = fbimage
                    
                }
                if let fb_productidentifier = dictionary["productidentifier"] as? String{
                    course.productidentifier = fb_productidentifier
                                        
                }
                
                
            }
          course.title = snapshot.key
           
            self.courses.append(course)
           
            
            self.requestProducts()
            
            self.tableView.reloadData()
            
//print("Firebase courses\(self.courses.count)")
            
            
        }
//        print("Core courses\(corecourses.count)")
//         print("Firebase courses\(courses.count)")
//        
//        if corecourses.count != courses.count {
//            print("transfering to core data")
//            for course in courses{
//                createCourse(productIdentifier: course.productidentifier, purchased: false)
//            }
//        }else{
//            print("nothing to transfer")
//        }
        
//        createCourse(productIdentifier: "com.ckmobile.testing", purchased: true)
//        
//        
        
    }
    
    func createCourse(productIdentifier:String, purchased:Bool ){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let corecourse = CoreCourse(context: context)
        
        corecourse.productidentifier = productIdentifier
        corecourse.purchased = purchased
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursecell", for: indexPath) as! CourseCell
        let course = courses[indexPath.row]
        print(course.title)
        cell.courseTitle.text = course.title
        cell.courseImage.sd_setImage(with: URL(string:course.image))
        for product in self.products{
            if product.productIdentifier == course.productidentifier{
                
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                formatter.locale = product.priceLocale
                
                if let price = formatter.string(from: product.price){
                    cell.coursePrice.text = "Buy for \(price)"
                    course.price = price
                                    }
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        performSegue(withIdentifier: "buycourses", sender: course)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? BuyCoursesVC{
//            
//            if(segue.identifier == "buycourses"){
//                
//                let course = segue.destination as! 
//                if let indexpath = self.myTableView.indexPathForSelectedRow{
//                    let year_sent = years[indexpath.row].uid as String
//                    Paper1Question.year_received = year_sent
//                }
//                
//            }
//            
//            
//            if let course = sender as! Course{
//                
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "buycourses"){
            
            let course = segue.destination as! BuyCoursesVC
            if let indexpath = self.tableView.indexPathForSelectedRow{
//                let year_sent = years[indexpath.row].uid as String
//                Paper1Question.year_received = year_sent
                let title_sent = courses[indexpath.row].title as String
                course.title_received = title_sent
            
               
                let discription_sent = courses[indexpath.row].discription as String
                course.discription_received = discription_sent
                
                let image_url_sent = courses[indexpath.row].image as String
                course.image_url_received = image_url_sent
                
                let productidentifier_sent = courses[indexpath.row].productidentifier as String
                course.productidentifier_received = productidentifier_sent
                course.price_received = courses[indexpath.row].price
                
            }
            
        }
        
    }
    
    func requestProducts(){
        var ids = Set<String>()

        print("There are some ids \(ids)")
        for course in courses {

            ids.insert(course.productidentifier)
            

        }
        print(ids)
        
        let productsRequest = SKProductsRequest(productIdentifiers:ids )

        productsRequest.delegate = self
        productsRequest.start()
        
//
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Product responses are \(response.products.count)")
        print("Products not ready:\(response.invalidProductIdentifiers.count)")
        self.products = response.products
        self.tableView.reloadData()
        
        
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("paying stuff")
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchased:
                print("Purchased")
                //                unlockArt(productidentifier: transaction.payment.productIdentifier)
                unlockCourse()
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                break
            case .purchasing:
                print("Purchasing")
                break
            case.failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                queue.finishTransaction(transaction)
                break
            case .restored:
                print("restored")
                queue.finishTransaction(transaction)
                self.unlockCourse()
                
                
                break
            case .deferred:
                print("deferred")
                break
            }
        }
        
    }
    
    func unlockCourse(){
        
        //search throught the product idenfifier in database and see anyone match this one
        //set the purchased be true
        
        
      
        print("bought")
    }

    
    

}
