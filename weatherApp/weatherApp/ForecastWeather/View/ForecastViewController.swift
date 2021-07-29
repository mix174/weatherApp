//
//  ForecastWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

import UIKit
import MBProgressHUD

protocol ForecastWeatherViewControllerProtocol: class {
    func updateWeather(weatherArray: [ForecastWeatherStruct])
    func showSpinner()
    func hideSpinner()
}

final class ForecastWeatherViewController: UIViewController, ForecastWeatherViewControllerProtocol {
    
    // Связи
    // Интерфейс презентера
    var presenter: ForecastWeatherPresenterProtocol?
    
    // Инициализация спиннера
    private let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    // Прогнозные данные
    var forecastData: [ForecastWeatherStruct] = []
    
    // CollectionView
    @IBOutlet private weak var forecastCollectionView: UICollectionView!
    
    // TableView
    @IBOutlet private weak var forecastTableView: UITableView!
    
    // Location Outlet
    @IBOutlet private weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("форекаст-вью загрузился")
        presenter?.viewDidLoad()
    }
    
    // Функции обновления данных
    func updateWeather(weatherArray: [ForecastWeatherStruct]) {
        forecastData = weatherArray
        delegateTableView()
        delegateCollectionView()
        updateLocationLabel()
        
        // пока без проверки
        setBackground(backgroundImage: weatherArray.first?.backgroundImage ??
                        UIImage(imageLiteralResourceName: "BG-NormalWeather"))
        hideSpinner()
    }
    // Обновление лейбла местоположения
    func updateLocationLabel() {
        guard let location = forecastData.first?.location else { return }
        locationLabel.text = location
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
    // MARK: Настройка фона
    func setBackground(backgroundImage: UIImage) {

        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.alpha = 0.9
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // Функции Спиннера
    func showSpinner() {
        guard spinner.alpha == 0 else {
            print("spinner is alredy showed")
            return
        }
        spinner.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(spinner)
        spinner.show(animated: true)
        print("spinner показан")
    }
    func hideSpinner() {
        spinner.hide(animated: true)
        spinner.removeFromSuperview()
        print("spinner спрятан")
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
        forecastData.count
    }
    // Построение ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier, for: indexPath) as! ForecastTableViewCell
        guard let rowData = forecastData[safe: indexPath.row] else {
            print("Проблема в данных при построении ячейки table в ForecastWeatherViewController")
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
        forecastData.count
    }
    // Построение ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseIdentifier, for: indexPath) as! ForecastCollectionViewCell
        guard let rowData = forecastData[safe: indexPath.row] else {
            print("Проблема в данных при построении ячейки сollection в ForecastWeatherViewController")
            return cell
        }
        cell.cellSetup(rowData: rowData)
        return cell
    }
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
    }
    
    // Сейчас есть проблемы с отступами
    // Отступы
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
//    // Отступы #2
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
