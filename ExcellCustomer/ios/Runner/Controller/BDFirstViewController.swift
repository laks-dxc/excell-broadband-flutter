
import UIKit

class BDFirstViewController: UIViewController, UITextFieldDelegate, LibraryPaymentStatusProtocol {

    
    var bdvc: BDViewController!
    
    var keyboardDoneButtonView = UIToolbar()
    var msg = [Any]()
    var pmtOptArr = [Any]()
    var blnShowingFilterPopUp = false
    let IDIOM = UI_USER_INTERFACE_IDIOM()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pmtOptArr = ["CC-F", "DC-f", "QP-F", "MB-f", "NB-F", "UPI-F", "SI-F", "TEZ-f", "UPI-f", "CCW-F"]

        keyboardDoneButtonView.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(BDFirstViewController.doneClicked(_:)))

        keyboardDoneButtonView.items = [doneButton]
        

    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func payNowClicked(_ sender: Any) {
        
//        amountField.resignFirstResponder()
                
        SHKActivityIndicator.current().displayActivity("Fetching Data")
         
        
        let respoStr = "EXCLMDIPVL|2046888|NA|2.00|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20210208|V1612789961|NA|APP|EXL|Labbipeta|2.00|https://billpay.excellmedia.net/billdsk.pl|53E26D1E3284715C90FDDE85A2A76657B46FBF1AB6FE24C442CE44FFF095E12D"
    
        let token = "NA"
        
       
        //**************** Below message for UPI failure  *****************//
         
                
                self.bdvc = BDViewController(message: respoStr, andToken:token, andEmail: "abc@xyz.com", andMobile: "9876543210", andTxtPayCategory: "UPI-f")
        
                self.bdvc?.delegate = self
                SHKActivityIndicator.current().displayCompleted("")
                self.bdvc?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(self.bdvc!, animated: true)
    }
    
    // MARK : - Payment status protocol method

    func paymentStatus(_ message: String!) {
        
        navigationController?.popToViewController(self, animated: true)
       
        print("message " + message);
//        message.starts(with: "<div")
        
        if message.starts(with: "<div") {
//            let statusCode = responseComponents[14]
//            showAlert(statusCode)
            showAlert("Succesful")
        } else {
            showAlert("Something went wrong")
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert(_ message: String) {
        
        let alertController = UIAlertController(title: "Payment status", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createJsonObject(_ serverStr: String?) -> String? {
        let mostOuter = serverStr?.components(separatedBy: "^")
        let token = mostOuter?[1]
        let outerList = mostOuter?[0].components(separatedBy: "|")
        print("token is \(token ?? "")")
        if let aList = outerList {
            print("outerList is \(aList)")
        }
        let rawData = outerList?[7].components(separatedBy: "~")
        if let aData = rawData {
            print("rawData is \(aData)")
        }
        return token
    }
    
    
    @IBAction func doneClicked(_ sender: Any) {
        print("Done Clicked.")
        view.endEditing(true)
    }
    
    
    @IBAction func dropBtnClked(_ sender: Any) {


    }
    
 

    


    


}
