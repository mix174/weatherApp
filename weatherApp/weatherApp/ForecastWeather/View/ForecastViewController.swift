//
//  ForecastWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

import UIKit

protocol ForecastWeatherViewControllerProtocol: class {
    func showMainLoader()
    func hideMainLoader()
}

final class ForecastWeatherViewController: UIViewController, ForecastWeatherViewControllerProtocol {
    
    // Delegates
    var presenter: ForecastWeatherPresenterProtocol?
    
    // Тренировка на TableView
    @IBOutlet weak var forecastTableView: UITableView!
    let identifier = "ZeroCell"
    var array = ["1", "2", "3", "4", "5"]
    
    @IBAction func toCurrentViewButtom(_ sender: UIButton) {
        print("Move to cur buttom entered")
        presenter?.moveToCurrentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("форекаст-вью загрузился")
        presenter?.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
    }
    
//  Для Спиннера
    func showMainLoader() {
        print("Лоадер форекаст показан")
    }
    func hideMainLoader() {
        print("Лоадер форекаст спрятан")
    }
    
}
//  Дополнеие для TableView
extension ForecastWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
}
