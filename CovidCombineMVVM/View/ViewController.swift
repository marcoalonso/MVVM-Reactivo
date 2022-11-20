//
//  ViewController.swift
//  CovidCombineMVVM
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
// reference: https://blog.devgenius.io/reactive-mvvm-pattern-in-uikit-30dde1574b6b 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    @IBAction func textFieldEdittingChanged(_ sender: UITextField) {
        print(sender.text!)
        viewModel.searchText = sender.text!
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        viewModel.performSearch()
    }
}

// MARK: - Private
private extension ViewController {
    
    func setupVC() {
        tableView.dataSource = self
        tableView.delegate = self
        title = "MVVM Binding Demo"
        setupBindings()
    }
    
    func setupBindings() {
        
        viewModel.results.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

        viewModel.isButtonEnabled.bind { [weak self] isEnabled in
            self?.btnSearch.isEnabled = isEnabled
        }

        viewModel.isLoadingEnabled.bind { [weak self] isEnabled in
            if isEnabled {
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            }
        }
    }
   
    //Es lo mismo que:
    
    
//    func setupBindings(){
//        tableView.bindTo(viewModel.results)
//        btnSearch.bindTo(viewModel.isButtonEnabled)
//        activityIndicator.bindTo(viewModel.isLoadingEnabled)
//    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.infoSong = viewModel.results.value[indexPath.row]
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.results.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itm = viewModel.getSearchResultVM(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = itm.trackName
        content.secondaryText = itm.collectionName
        cell.contentConfiguration = content
        
        return cell
    }
}
