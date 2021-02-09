//
//  SecondViewController.swift
//  Runner
//
//  Created by Lakshman Rao Pilaka on 09/02/21.
//

import UIKit

class SecondViewController: UIViewController,LibraryPaymentStatusProtocol {

    var msg:String?
   
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        retryButton.isHidden = true;
        clickFunction()
        
        
    }
    func setUpNavBar(){
        self.navigationItem.title = "Payment"
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.done, target: self, action: nil)
       
    }
    
    @IBAction func clickBUtton() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor =
            UIColor(red:  14/255.0, green: 52/255.0, blue: 127/255.0, alpha: 100.0/100.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = self.uicolorFromHex(rgbValue: 0xffffff)
        // change navigation item title color
        
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    var coordinatorDelegate: NewsCoordinatorDelegate?
     
      
      var bdvc: BDViewController!
      
      var keyboardDoneButtonView = UIToolbar()
      let IDIOM = UI_USER_INTERFACE_IDIOM()
      
      
     
      @IBAction func doneClicked(_ sender: Any) {
          print("Done Clicked.")
          view.endEditing(true)
      }
      
    @IBAction func goToFlutter(_ sender: Any){
      coordinatorDelegate?.navigateToFlutter()
    }
      
      @IBAction func payNowClicked(_ sender: Any) {
        clickFunction();
      }
    
    func clickFunction() {
        SHKActivityIndicator.current().displayActivity("Fetching Datum")
        
        let respoStr = msg
  
        let token = "NA"
                
        self.bdvc = BDViewController(message: respoStr, andToken:token, andEmail: "abc@xyz.com", andMobile: "9876543210", andTxtPayCategory: "txtPayCategory.text!")
        self.bdvc?.delegate = self
//        self.bdvc.view.backgroundColor = UIColor(red:  14/255.0, green: 52/255.0, blue: 127/255.0, alpha: 100.0/100.0)
        
        
        SHKActivityIndicator.current().displayCompleted("")
        self.bdvc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(self.bdvc!, animated: true)
       
    }
      
           
      func showAlert(_ message: String) {
          
          let alertController = UIAlertController(title: "Payment status", message: message, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
              print("Cancel")
          })
          self.present(alertController, animated: true, completion: nil)
      }
             
      func onError(_ exception: NSException?) {
          if let anException = exception {
              print("Exception got in Merchant App \(anException)")
          }
      }
      
      func tryAgain() {
          print("Try again method in Merchant App")
      }
      
      func cancelTransaction() {
          print("Cancel Transaction method in Merchant App")
      }
      
      func paymentStatus(_ message: String!) {
          navigationController?.popToViewController(self, animated: true)
//          print("message " + message);
          
          if message.starts(with: "<div") {
            paymentStatus.text = "Payment Succesful"
            paymentStatus.font = paymentStatus.font.withSize(30)
            paymentStatus.textAlignment = NSTextAlignment.center
            paymentStatus.textColor = .green
//              showAlert("Succesful !!")
          
          } else {
            retryButton.isHidden = false;
            paymentStatus.text = "Payment Failed"
            paymentStatus.font = paymentStatus.font.withSize(30)
            paymentStatus.textAlignment = NSTextAlignment.center
            paymentStatus.textColor = .red
//              showAlert("Failure.")
            
                    
          }
      }
}
