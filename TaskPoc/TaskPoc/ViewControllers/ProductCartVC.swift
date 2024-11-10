//
//  ProductCartVC.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductCartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartTxtview: UIView!
    @IBOutlet weak var productview: UIView!
    @IBOutlet weak var productLocview: UIView!
    @IBOutlet weak var productBtn: UIButton!
    
    var cartItems: [CartItem] = []  // Cart items passed from ProductHomeVC

    override func viewDidLoad() {
        super.viewDidLoad()
        cartTxtview.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        productview.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        productLocview.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        productBtn.makeCircular()
        print("Cart items count: \(cartItems.count)")

        // Set up table view
        cartTableView.register(UINib(nibName: "ProductCartCell", bundle: nil), forCellReuseIdentifier: "ProductCartCell")
        cartTableView.reloadData()

    }
 
    @IBAction func checkoutBtnTapped(_ sender: UIButton) {
        self.presentThankYouPopup()
    }
    
    func presentThankYouPopup() {
          // Create an alert controller with a title and message
          let alertController = UIAlertController(title: "Thank You!", message: "We appreciate your feedback.", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.cartItems.removeAll()
            self.cartTableView.reloadData()
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
            }
            print("Thank you button tapped")
        }
          alertController.addAction(okAction)
          
          self.present(alertController, animated: true, completion: nil)
      }

    
    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
        let cartItem = cartItems[indexPath.row]
        cell.descLbl.text = cartItem.product.title
        cell.priceLbl?.text = "$\(cartItem.product.price)"
        let imageUrlString = cartItem.product.image
        if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString) {
            cell.cartImage?.image = cachedImage
        } else {
            // Load the image asynchronously if not cached
            DispatchQueue.global().async {
                if let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    ImageCache.shared.saveImage(image, forKey: imageUrlString)
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        cell.cartImage?.image = image
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
