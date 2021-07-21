//
//  CurrentWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation
import UIKit
import MBProgressHUD

protocol CurrentWeatherViewControllerProtocol: class {
    
    func showSpinner()
    func hideSpinner()
    func setBackground(backgroundImage: UIImage)
    func setWeather(data: CurrentWeatherDecodable)
    func failureLocation()
    
    func updateForecastTable(forecastWeather: ForecastWeatherDecodable)
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    // Интерфейс презентера
    var presenter: CurrentWeatherPresenterProtocol?
    
    // Loading spinner init in property
    let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: Основные аутлеты
    // Местоположение
    @IBOutlet weak var locationLabel: UILabel!
    // Описание погоды
    @IBOutlet weak var weatherDescribLabel: UILabel!
    // Иконка погоды
    @IBOutlet weak var iconImage: UIImageView!
    // Основная температура
    @IBOutlet weak var mainTempLabel: UILabel!
    // Влажность
    @IBOutlet weak var humidityLabel: UILabel!
    // Скорость ветра
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: Аутлет tableView
    @IBOutlet weak var currentTableView: UITableView!
    // Для tableView
    let identifier = "forecastAtCurrentCell"
    var forecastTableViewData: ForecastWeatherDecodable?
    
    
    // MARK: Кнопки навигации
    @IBAction func moveToForecastView(_ sender: UIButton) {
        print("forecastButton pressed")
        self.presenter?.moveToForecastView()
    }
    
    // MARK: Функция viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("куррент-вью загрузился")
        presenter?.viewDidLoad()
    }
    
    // MARK: Настройка фона
    // Background Setup — нужно сделать выбор между методом
    func setBackground(backgroundImage: UIImage) {

        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // MARK: Функции для отображения данных
    func setWeather(data: CurrentWeatherDecodable) {
        // Установка фона
        guard let background = data.weather[0].backgroundImage else { return }
        self.setBackground(backgroundImage: background)
        // Установка основных данных
        locationLabel.text = data.city
        weatherDescribLabel.text = data.weather[0].description
        iconImage.image = data.weather[0].iconImage
        mainTempLabel.text = data.main.tempConverted
        humidityLabel.text = data.main.humidityConverted
        windSpeedLabel.text = data.wind.windSpeedConverted
    }
    // Функция присвоения данных и активации роли делегата для текущего вьюКонтроллера
    func updateForecastTable(forecastWeather: ForecastWeatherDecodable) {
        forecastTableViewData = forecastWeather
        delegateForecastTableView()
        currentTableView.reloadData() // без релоуд данные не появляются самостоятельно
    }
    // Функция присвоения роли делегата и источника данных для TableView
    func delegateForecastTableView() {
        currentTableView.delegate = self
        currentTableView.dataSource = self
    }
    
    // MARK: Функции спиннера
    // Funcs for spinner
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
    
    // MARK: Обработка ошибок
    // Функция отображения ошибки (требует доработки)
    func failureLocation() {
        let failureController = UIAlertController(title: "Ошибка", message: "Проблема с локацией", preferredStyle: .alert)
        
        let tryAgain = UIAlertAction(title: "Перезапустить локацию", style: .default) { [weak self] _ in
            self?.presenter?.getLocation()
        }
        let showHomeCity = UIAlertAction(title: "Показать домашний регион", style: .default) { [weak self] _ in
            // требует доработки
            self?.presenter?.getWeatherFor(city: "Moscow")
        }
        
        failureController.addAction(tryAgain)
        failureController.addAction(showHomeCity)
        
        self.present(failureController, animated: true, completion: nil)
    }
}


// Дополнение для TableView
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CurrentTableViewCell
        
        guard let rowData = forecastTableViewData?.partWeather[indexPath.row] else {
            print("Проблема в данных при построении ячейки в CurrentWeatherViewController")
            cell.time.text = "not found"
            return cell
        }
        cell.cellSetup(rowData: rowData)
        return cell
    }
}
