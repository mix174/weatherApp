//
//  ForecastWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

import UIKit

protocol ForecastWeatherViewControllerProtocol: class {
    func updateWeather(weatherArray: [CurrentWeatherDecodable])
    func showSpinner()
    func hideSpinner()
}

final class ForecastWeatherViewController: UIViewController, ForecastWeatherViewControllerProtocol {
    
    // Связи
    var presenter: ForecastWeatherPresenterProtocol?
    var forecastData: [CurrentWeatherDecodable]?
    
    // CollectionView
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    let collectionIdentifier = "collectionViewCell"
    
    // TableView
    @IBOutlet weak var forecastTableView: UITableView!
    let tableIdentifier = "tableViewCell"
    
    // Location Outlet
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("форекаст-вью загрузился")
        presenter?.viewDidLoad()
    }
    
    // Функции обновления данных
    func updateWeather(weatherArray: [CurrentWeatherDecodable]) {
        forecastData = weatherArray
        delegateTableView()
        delegateCollectionView()
    }
    
    // Функция присвоения роли делегата и источника данных для TableView
    func delegateTableView() {
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
    }
    // Функция присвоения роли делегата и источника данных для CollectionView
    func delegateCollectionView() {
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
    }
    
    // Функции Спиннера: дополнить
    func showSpinner() {
        print("Лоадер форекаст показан")
    }
    func hideSpinner() {
        print("Лоадер форекаст спрятан")
    }
    
}
// Дополнение для TableView
extension ForecastWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    // Кол-во прототипов ячейки
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastData?.count ?? 1
    }
    // Построение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath) as! ForecastTableViewCell
        guard let rowData = forecastData?[indexPath.row] else {
            print("Проблема в данных при построении ячейки table в ForecastWeatherViewController")
            cell.temp.text = "not found"
            return cell
        }
        cell.cellSetup(rowData: rowData)
        return cell
    }
}

// Дополнение для CollectionView
extension ForecastWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Количетсво ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastData?.count ?? 1
    }
    // Построение ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as! ForecastCollectionViewCell
        guard let rowData = forecastData?[indexPath.row] else {
            print("Проблема в данных при построении ячейки сollection в ForecastWeatherViewController")
            cell.temp.text = "not found"
            return cell
        }
        cell.cellSetup(rowData: rowData)
        return cell
    }
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    // Сейчас есть проблемы с отступами
    // Отступы
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    // Отступы #2
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//    }
}
