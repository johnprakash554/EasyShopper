//
//  ProductHomeVC.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductHomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonHeader: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var categoriesAllBtn: UIButton!
    @IBOutlet weak var saleAllBtn: UIButton!
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var notifBtn: UIButton!
    @IBOutlet weak var headerBtn: UIButton!
    
    private var viewModel = ProductViewModel()
    var loaderView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var loaderLabel: UILabel!
    var remainingTime: Int = 18000
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch products data
        self.setUpCollectionViewLayout()
        
        viewModel.fetchProducts()
        
        // Bind data updates to the UI
        viewModel.onDataFetched = { [weak self] in
            self?.categoriesCollectionView.reloadData()
            self?.productsCollectionView.reloadData()
            self?.startTimer()
            self?.updateCartButton()
        }
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(errorMessage)
        }
    }
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
    @objc func cartButtonTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
            if let cartVC = tabBarController.viewControllers?[2] as? ProductCartVC {
                cartVC.cartItems = viewModel.cartItems.filter { $0.isInCart }
                cartVC.cartTableView.reloadData()
            }
        }
    }
    
    // Function to create the loader view
    
    func createLoaderView() {
        // Create the container view for the loader (this will contain the indicator and label)
        loaderView = UIView()
        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loaderView.layer.cornerRadius = 10
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true  // Initially hidden
        
        // Create the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        // Create the label
        loaderLabel = UILabel()
        loaderLabel.text = "Loading..."
        loaderLabel.textColor = .white
        loaderLabel.translatesAutoresizingMaskIntoConstraints = false
        loaderLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Add the activity indicator and label to the loader view
        loaderView.addSubview(activityIndicator)
        loaderView.addSubview(loaderLabel)
        
        // Add the loader view to the main view
        view.addSubview(loaderView)
        
        // Set up Auto Layout constraints for the loader view
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 200),
            loaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Set up constraints for the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loaderView.topAnchor, constant: 20)
        ])
        
        // Set up constraints for the label
        NSLayoutConstraint.activate([
            loaderLabel.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor),
            loaderLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10)
        ])
        self.loadData()
    }
    func startLoading() {
        loaderView.isHidden = false
        activityIndicator.startAnimating()
    }
    func stopLoading() {
        activityIndicator.stopAnimating()
        loaderView.isHidden = true
    }
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    @objc func updateTimer() {
        remainingTime -= 1
        timerLabel.text = formatTime(seconds: remainingTime)
        if remainingTime <= 0 {
            stopTimer()
            timerLabel.text = "00:00:00"
        }
    }
    
    // MARK: - Collection View DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView{
            return viewModel.products.count
        }else{
            return viewModel.categories.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        if collectionView == productsCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            
            let product = viewModel.products[indexPath.item]
            (cell as! ProductCell).configureCell(with: product)
            
            let cartItem = viewModel.cartItems[indexPath.item]
            (cell as! ProductCell).favouriteBtn.isSelected = cartItem.isInCart
            
            (cell as! ProductCell).heartButtonAction = {
                self.viewModel.toggleCart(for: product.id)
                self.updateCartButton()
                let cartItem = self.viewModel.cartItems.first { $0.product.id == product.id }
                (cell as! ProductCell).favouriteBtn.isSelected = cartItem?.isInCart ?? false
                
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomImagesCell
            let category = viewModel.categories[indexPath.item]
            (cell as! CustomImagesCell).viewModel = viewModel
            (cell as! CustomImagesCell).category(with: category)
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
            if let secondTabVC = tabBarController.viewControllers?[1] as? ProductDetailVC {
                secondTabVC.product = product
                secondTabVC.viewDidLoad()
            }
        }
    }
    func loadData() {
        startLoading()
        DispatchQueue.global().async {
            sleep(8)
            DispatchQueue.main.async {
                self.stopLoading()
            }
        }
    }
    func updateCartBadge() {
        let cartCount = viewModel.cartItemCount()  // Get the count of items in the cart
        let tabBarController = self.tabBarController
        tabBarController?.tabBar.items?[2].badgeValue = cartCount > 0 ? "\(cartCount)" : nil
    }
    
    func toggleCart(for productId: Int) {
        viewModel.toggleCart(for: productId)  // Toggle cart status for the product
        updateCartBadge()  // Update the badge count after the cart changes
    }
    // error alert
    public func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func updateCartButton() {
        let cartCount = viewModel.cartItemCount()
        if let tabBarController = self.tabBarController {
            let cartTabItem = tabBarController.tabBar.items?[2]  // Get the cart tab
            cartTabItem?.badgeValue = cartCount > 0 ? "\(cartCount)" : nil  // Set badge value
        }
    }
    func setUpCollectionViewLayout(){
        headerBtn.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        productsView.setCornerRadius(15.0)
        headerView.setCornerRadius(15.0)
        buttonHeader.setCornerRadius(5.0)
        categoriesAllBtn.makeCircular()
        saleAllBtn.makeCircular()
        couponBtn.makeCircular()
        notifBtn.makeCircular()
        self.timerLabel.text = formatTime(seconds: remainingTime)
        self.createLoaderView()
        self.tabBarController?.delegate = self // Set the delegate to handle tab selection
        let cartButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cartButtonTapped))
        self.navigationItem.rightBarButtonItem = cartButton
        let flowLayout = UICollectionViewFlowLayout()
        // Setting the layout properties
        flowLayout.minimumLineSpacing = -35
        flowLayout.minimumInteritemSpacing = -10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = (numberOfColumns - 1) * spacing
        let width = (productsCollectionView.frame.width - totalSpacing) / numberOfColumns
        flowLayout.itemSize = CGSize(width: width, height: 250)
        
        // Apply the layout to the collection view
        productsCollectionView.collectionViewLayout = flowLayout
    }
}
extension ProductHomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Check if the selected view controller is the Cart View Controller
        if let selectedVC = viewController as? ProductCartVC {
            print("Cart tab selected")
            selectedVC.cartItems = viewModel.cartItems.filter { $0.isInCart }
            selectedVC.cartTableView.reloadData()
        }
    }
}
