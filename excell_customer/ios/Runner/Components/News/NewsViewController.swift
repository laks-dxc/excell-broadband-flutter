//
//  NewsViewController.swift
//  Runner
//
//  Created by Lakshman Rao Pilaka on 09/02/21.
//

import UIKit
class NewsViewController: UIViewController, LibraryPaymentStatusProtocol {

    
  var coordinatorDelegate: NewsCoordinatorDelegate?
   
    
    var bdvc: BDViewController!
    
    var keyboardDoneButtonView = UIToolbar()
    let IDIOM = UI_USER_INTERFACE_IDIOM()
    
    
  override func viewDidLoad() {
     super.viewDidLoad()
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(NewsViewController.doneClicked(_:)))
    keyboardDoneButtonView.items = [doneButton]
    keyboardDoneButtonView.sizeToFit()

  }
    
    @IBAction func doneClicked(_ sender: Any) {
        print("Done Clicked.")
        view.endEditing(true)
    }
    
  @IBAction func goToFlutter(_ sender: Any){
    coordinatorDelegate?.navigateToFlutter()
  }
    
    @IBAction func payNowClicked(_ sender: Any) {
             
        SHKActivityIndicator.current().displayActivity("Fetching Datum")
        
        let respoStr = "EXCLMDIPVL|2046888|NA|2.00|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20210208|V1612789961|NA|APP|EXL|Labbipeta|2.00|https://billpay.excellmedia.net/billdsk.pl|53E26D1E3284715C90FDDE85A2A76657B46FBF1AB6FE24C442CE44FFF095E12D"
    
        let token = "NA"
                
        self.bdvc = BDViewController(message: respoStr, andToken:token, andEmail: "abc@xyz.com", andMobile: "9876543210", andTxtPayCategory: "txtPayCategory.text!")
        self.bdvc?.delegate = self
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
        print("message " + message);
        
        if message.starts(with: "<div") {
            showAlert("Succesful")
        } else {
            showAlert("Something went wrong")
        }
    }
}
