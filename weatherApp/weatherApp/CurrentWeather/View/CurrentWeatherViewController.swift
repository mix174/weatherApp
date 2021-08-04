//
//  CurrentWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit
import MBProgressHUD

protocol CurrentWeatherViewControllerProtocol: class {
    // loading
    func showSpinner()
    func hideSpinner()
    // apperance
    func setBackground(backgroundImage: UIImage)
    func setOnView(searchBar: UISearchBar)
    func setOnView(resultTable: ResultTableView)
    // parameters
    func setWeather(data: CurrentWetherStruct)
    func updateForecastTable(forecastWeather: [ShortForecastWeatherStruct])
    // failure
    func failureLocation()
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    // Интерфейс презентера
    var presenter: CurrentWeatherPresenterProtocol?
    
    // Инициализация спиннера
    private let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: Основные аутлеты
    // Местоположение
    @IBOutlet private weak var locationLabel: UILabel!
    // Описание погоды
    @IBOutlet private weak var weatherDescribLabel: UILabel!
    // Иконка погоды
    @IBOutlet private weak var iconImage: UIImageView!
    // Основная температура
    @IBOutlet private weak var mainTempLabel: UILabel!
    // Влажность
    @IBOutlet private weak var humidityLabel: GrayLabel!
    // Скорость ветра
    @IBOutlet private weak var windSpeedLabel: GrayLabel!
    
    // MARK: Аутлет forecastTableView
    @IBOutlet private weak var currentTableView: UITableView!
    // Массив структур для ячеек forecastTableView
    var forecastTableViewData: [ShortForecastWeatherStruct] = []
    
    var background: UIImageView?
    
    
    // MARK: Кнопки навигации
    @IBAction private func moveToForecastView(_ sender: UIButton) {
        self.presenter?.moveToForecastView()
    }
    
// ————————————————————————————————————————————————— //
    
    // MARK: Работа с поиском и результатами (ДРАФТ)
    
    let searchBarFrame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 50) // Надо менять такой код
    
    // Размещение searchBar
    func setOnView(searchBar: UISearchBar) {
        let extraView = UIView(frame: searchBarFrame)
        extraView.addSubview(searchBar)
        searchBar.frame = CGRect(x: 0, y: 0, width: extraView.frame.width, height: extraView.frame.height)
        view.addSubview(extraView)
    }
    
    // Размещение resultTable
    func setOnView(resultTable: ResultTableView) {
        view.addSubview(resultTable)
    }
        
    
// ————————————————————————————————————————————————— //
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    // MARK: Настройка фона
    func setBackground(backgroundImage: UIImage) {
        // Проверка на уже установленный фон
        guard self.background == nil else {
            // Замена фона
            self.background?.image = backgroundImage
            return
        }
        // Установка фона
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        self.background = imageView
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // MARK: Функции для отображения данных
    // Установка основных данных экрана и фона
    func setWeather(data: CurrentWetherStruct) {
        // Установка фона
        self.setBackground(backgroundImage: data.backgroundImage)
        // Установка основных данных
        locationLabel.text = data.location
        weatherDescribLabel.text = data.description
        iconImage.image = data.icon
        mainTempLabel.text = data.temp
        humidityLabel.set2LineText(type: .humidity, secondLine: data.humidity)
        windSpeedLabel.set2LineText(type: .windSpeed, secondLine: data.windSpeed)
        
        var counter = 0
        for i in view.subviews {
            if i is UIImageView {
                counter += 1
            }
        }
        print("counter: ", counter)
        
    }
    // Присвоение прогнозных данных и активация роли делегата для текущего вьюКонтроллера
    func updateForecastTable(forecastWeather: [ShortForecastWeatherStruct]) {
        forecastTableViewData = forecastWeather
        setupTableViewDelegate()
        currentTableView.reloadData() // без релоуд данные не появляются самостоятельно
    }
    
    // Функция присвоения роли делегата и источника данных для TableView
    func setupTableViewDelegate() {
        currentTableView.delegate = self
        currentTableView.dataSource = self
    }
    
    // MARK: Функции спиннера
    // Показать спиннер
    func showSpinner() {
        guard spinner.alpha == 0 else {
            print("spinner is alredy showed") // Test
            return
        }
        spinner.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(spinner)
        spinner.show(animated: true)
        print("spinner показан") // Test
    }
    
    // Спрятать спиннер
    func hideSpinner() {
        spinner.hide(animated: true)
        spinner.removeFromSuperview()
        print("spinner спрятан") // Test
    }
    
    // MARK: Обработка ошибок
    // Отображение ошибки (требует доработки)
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
// MARK: Extensions
// extension для forecastTableView
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastTableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentTableViewCell.reuseIdentifier, for: indexPath) as! CurrentTableViewCell
        guard let rowData = forecastTableViewData[safe: indexPath.row] else {
            print("Проблема в данных при построении ячейки в CurrentWeatherViewController")
            return cell
        }
        cell.cellSetup(rowData: rowData)
        return cell
    }
}
