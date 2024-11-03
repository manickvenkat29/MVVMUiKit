//
//  ProductListViewController.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import UIKit

class ProductListViewController: UIViewController {

   
    var userName, email : String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameTitle: UINavigationItem!
    
    private let viewModel = ProductListViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureTableView()
        viewModel.fetchInitialProducts()
    }
    
    private func configureTableView(){
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        cell.productName.text = "# \(viewModel.products[indexPath.row].id) - \(viewModel.products[indexPath.row].title)"
        cell.productDescription.text = viewModel.products[indexPath.row].description
        
        if let url = URL(string: viewModel.products[indexPath.row].thumbnail) {
            cell.thumnailImage?.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Detect when user scroll near bottom of the list
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        if offsetY > contentHeight - frameHeight * 1.5 {
            viewModel.fetchNextPage() // Fetch the next page when user scrolls near the bottom
        }
    }
}

extension ProductListViewController: ProductListViewModelDelegate {
    func didUpdateProducts() {
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: String) {
        
    }
    
    
}
