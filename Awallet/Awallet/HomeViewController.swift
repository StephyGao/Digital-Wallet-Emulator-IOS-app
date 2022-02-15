import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    var wallet: Wallet?
    @IBOutlet var username: UITextField?
    @IBOutlet var totalAmount: UILabel?
    @IBOutlet var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        Api.user{ response, error in
            if let error = error {
                
            } else if let response = response {
                let wallet = Wallet(data: response, ifGenerateAccounts: true)
                self.wallet = wallet
                self.refresh()
                
            }
            
            
        }
    }
    
    //input new username into textfield with total amount
    func refresh() {
        username?.text = wallet?.userName
        if let t = wallet?.totalAmount {
            let total: String = String(format: "%.1f", t)
            totalAmount?.text = total
        }
        tableView?.reloadData()
    }
    
    //update username
    @IBAction func update(sender: UIButton) {
        if let name = username?.text{
            Api.setName(name: name, completion: { (response, error) in
                
            })
        }
    }
    //reset stored phone number
    @IBAction func logout() {
        Storage.phoneNumberInE164 = nil
    }
    
    //define table row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet?.accounts.count ?? 0
    }
    
    //modify text in table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") ?? UITableViewCell()
        cell.textLabel?.text = wallet?.accounts[indexPath.row].name
        if let t = wallet?.accounts[indexPath.row].amount {
            let total: String = String(format: "%.1f", t)
            cell.detailTextLabel?.text = total
        }
        return cell
    }
}
