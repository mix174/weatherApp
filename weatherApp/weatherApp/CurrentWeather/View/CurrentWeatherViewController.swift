//
//  CurrentWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit
import MBProgressHUD
import SnapKit

protocol CurrentWeatherViewControllerProtocol: AnyObject {
    // loading
    func showSpinner()
    func hideSpinner()
    // apperance
    func setBackground(backgroundImage: UIImage)
    // searchBar
    func getSearchBarAnchor() -> CGFloat
    // parameters
    func setWeather(data: CurrentWetherStruct)
    func updateForecastTable(forecastWeather: [ShortForecastWeatherStruct])
    // failure
    func failureLocation()
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    // MARK: Связи
    // Интерфейс презентера
    var presenter: CurrentPresenterProtocol?
    // searchController
    var searchController: UISearchController?
    
    // MARK: Переменные класса
    // Инициализация спиннера
    private let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // Переменная фона
    private var background: UIImageView?
    
    // Массив структур для ячеек forecastTableView
    private var forecastTableViewData: [ShortForecastWeatherStruct] = []
    
    // MARK: Основные аутлеты
    // Местоположение
    @IBOutlet private weak var locationLabel: UILabel!
    // Описание погоды
    @IBOutlet private weak var weatherDescribLabel: UILabel!
    // Иконка погоды
    @IBOutlet private weak var iconImage: UIImageView!
    // Основная температура
    @IBOutlet private weak var mainTempLabel: UILabel!
    // Значок градуса основной температуры
    @IBOutlet private weak var tempDegree: UILabel!
    // Влажность
    @IBOutlet private weak var humidityLabel: GrayLabel!
    // Скорость ветра
    @IBOutlet private weak var windSpeedLabel: GrayLabel!
    
    // MARK: Аутлет forecastTableView
    @IBOutlet private weak var currentTableView: UITableView!
    
    // MARK: Кнопки навигации
    // Кнопка "Прогноз на неделю" (аутлет)
    @IBOutlet private weak var toForecastButton: GrayButton!
    // Кнопка "Прогноз на неделю" (действие)
    @IBAction private func moveToForecastView(_ sender: UIButton) {
        self.presenter?.moveToForecastView()
    }
    
// ————————————————————————————————————————————————— //
    
    // MARK: Работа с поиском и результатами (ДРАФТ)
    @IBOutlet private weak var searchBarView: UIView!
    
    func searchSetup() {
        guard let searchBar = searchController?.searchBar else {
            print("currentViewController: Cannot set searchBar")
            return }
        searchBar.placeholder = "Выберите город"
        searchBar.searchBarStyle = .minimal
        searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController?.obscuresBackgroundDuringPresentation = true
        searchBarView.addSubview(searchBar)
        
        // !ШАМАНИТЬ ЗДЕСЬ!
        
//        searchBar.frame = searchBarView.bounds
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight]
    }
    
    // Размещение resultTable
    func setOnView(resultTable: ResultTableView) {
        view.addSubview(resultTable)
    }
    
    // Размеры для resultTable
    func getSearchBarAnchor() -> CGFloat {
        var anchor: CGFloat { searchBarView.frame.maxY }
        // TEST
        print("!!! searchBarView.frame parametrs !!!")
        let a = searchBarView.frame
        print(a.height)
        print(a.maxY)
        print(a.minY)
        
        let g = searchBarView.snp.bottom
        print(g)
        return anchor
    }
    
// ————————————————————————————————————————————————— //
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        searchSetup()
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
        imageView.contentMode =  .center
        imageView.clipsToBounds = false
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
        mainTempLabel.text = data.tempBlank
        humidityLabel.labelSetup(type: .humidity, value: data.humidity)
        windSpeedLabel.labelSetup(type: .windSpeed, value: data.windSpeed)
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
    // Отображение ошибки
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
        forecastTableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentTableViewCell.reuseIdentifier, for: indexPath) as! CurrentTableViewCell
        guard let rowData = forecastTableViewData[safe: indexPath.row] else {
            print("Проблема в данных при построении ячейки в CurrentWeatherViewController")
            return cell
        }
        // Констрейнты
        cell.setConstraints()
        // Значения и параметры
        cell.cellSetup(rowData: rowData)
        return cell
    }
}

// MARK: Констрейнты
// extension для constraints
extension CurrentWeatherViewController {
    // смена ориентации экрана
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("did rotate")
        // Удаление констрентов
        // Строка поиска
        searchBarView.snp.removeConstraints()
        // Локация
        locationLabel.snp.removeConstraints()
        // Описание погоды
        weatherDescribLabel.snp.removeConstraints()
        // Иконка погоды
        iconImage.snp.removeConstraints()
        // Основная температура
        mainTempLabel.snp.removeConstraints()
        // Значок градуса основной температуры
        tempDegree.snp.removeConstraints()
        // Влажность
        humidityLabel.snp.removeConstraints()
        humidityLabel.removeInnerConstraints()
        // Скорость ветра
        windSpeedLabel.snp.removeConstraints()
        windSpeedLabel.removeInnerConstraints()
        // Тейбл прогноза
        currentTableView.snp.removeConstraints()
        // Кнопка перехода на экран с прогнозом
        toForecastButton.snp.removeConstraints()
        
        // Повторная установка констрейнтов
        setConstraints()
    }
    // Энум с состояниями экрана
    enum SizeClass {
        case any
        case regularRegular // Айпад
        case regularCompact // LandScape
        case compactCompact // iphone SE LandScape
        // дабавить, если надо
    }
    // MARK: Основная функция установки констрейнтов
    func setConstraints() {
        // отключение AutoresizingMask
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Safe area guide
        let safeArea = self.view.safeAreaLayoutGuide
        
        // определение горизонтального класса экрана
        let widthSizeClasse = self.view.traitCollection.horizontalSizeClass
        // определение вертикального класса экрана
        let heightSizeClasses = self.view.traitCollection.verticalSizeClass
        
        // проверка на size classes (используется в switch ниже)
        var sizeClass: SizeClass {
            if widthSizeClasse == .regular &&
                heightSizeClasses == .regular {
                return .regularRegular
            } else if widthSizeClasse == .regular && heightSizeClasses == .compact {
                return .regularCompact
            } else if widthSizeClasse == .compact && heightSizeClasses == .compact {
                return .compactCompact
            } else {
                return .any
            }
        }
        // Установка констрейнтов исходя из текущего состояния экрана
        switch sizeClass {
        case .regularRegular: // Ipad
            constraintSearchBarView_Any(safeArea: safeArea)
            constraintLocationLabel_Any(safeArea: safeArea)
            constraintDescribLabel_Any()
            constraintIconView_RR()
            constraintMainTemp_Any()
            constraintHumidityLabel_Any()
            constraintWindLabel_Any()
            constraintCurrentTable_RR()
            constraintForecastButton_Any(safeArea: safeArea)
        case .compactCompact: // landscape на маленьком iphone
            fallthrough
        case .regularCompact: // landscape
            constraintSearchBarView_RC(safeArea: safeArea)
            constraintLocationLabel_RC(safeArea: safeArea)
            constraintMainTemp_RC(safeArea: safeArea)
            constraintDescribtionLabel_RC()
            constraintIconView_RC()
            constraintHumidityLabel_RC(safeArea: safeArea)
            constraintWindLabel_RC()
            constraintCurrentTable_RC(safeArea: safeArea)
            constraintForecastButton_RC(safeArea: safeArea)
        default: // Any (обычное состояние (в данном случае portrait))
            constraintSearchBarView_Any(safeArea: safeArea)
            constraintLocationLabel_Any(safeArea: safeArea)
            constraintDescribLabel_Any()
            constraintIconView_Any()
            constraintMainTemp_Any()
            constraintHumidityLabel_Any()
            constraintWindLabel_Any()
            constraintCurrentTable_Any()
            constraintForecastButton_Any(safeArea: safeArea)
        }
    }
    // MARK: строка поиска
    func constraintSearchBarView_Any(safeArea: UILayoutGuide) {
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(10)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(50)
        }
    }
    func constraintSearchBarView_RC(safeArea: UILayoutGuide) {
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(20)
            make.leading.trailing.equalTo(safeArea).inset(10)
            make.height.equalTo(50)
        }
    }
    // MARK: Локация
    func constraintLocationLabel_Any(safeArea: UILayoutGuide) {
        locationLabel.snp.contentHuggingVerticalPriority = 250 // чтобы лейбл с городом мог увеличиваться вертикально
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeArea).inset(20)
        }
    }
    func constraintLocationLabel_RC(safeArea: UILayoutGuide) {
        locationLabel.snp.contentHuggingVerticalPriority = 250 // ровныеа
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(safeArea).inset(30)
        }
    }
    // MARK: описание погоды
    func constraintDescribLabel_Any() {
        weatherDescribLabel.snp.contentHuggingVerticalPriority = 251 // чтобы лейбл с городом мог увеличиваться
        weatherDescribLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(locationLabel)
        }
    }
    func constraintDescribtionLabel_RC() {
        weatherDescribLabel.snp.contentHuggingVerticalPriority = 250 // ровные
        weatherDescribLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.equalTo(locationLabel)
            make.trailing.equalTo(mainTempLabel.snp.leading).offset(-20)
        }
    }
    // MARK: иконка погоды
    func constraintIconView_Any() {
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(weatherDescribLabel.snp.bottom).offset(15)
            make.leading.greaterThanOrEqualTo(locationLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(locationLabel.snp.trailing)
            make.centerX.equalTo(weatherDescribLabel.snp.centerX) // нужна, так как ширины иногда будет меньше, чем leading и trailing
            make.width.lessThanOrEqualTo(500)
            // если не айпад то высота иконки погоды = 20% экрана
            make.height.equalTo(self.view.snp.height).multipliedBy(0.2)
        }
    }
    func constraintIconView_RR() {
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(weatherDescribLabel.snp.bottom).offset(15)
            make.leading.greaterThanOrEqualTo(locationLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(locationLabel.snp.trailing)
            make.centerX.equalTo(weatherDescribLabel) // нужна, так как ширина может быть меньше, чем leading и trailing
            make.width.lessThanOrEqualTo(500)
        }
    }
    func constraintIconView_RC() {
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(weatherDescribLabel.snp.bottom).offset(20)
            make.leading.equalTo(weatherDescribLabel)
            make.trailing.equalTo(weatherDescribLabel)
        }
    }
    
    // MARK: главная температура и градус температуры
    func constraintMainTemp_Any() {
        mainTempLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom)
            make.centerX.equalTo(iconImage.snp.centerX)
        }
        tempDegree.snp.makeConstraints { make in
            make.leading.equalTo(mainTempLabel.snp.trailing)
            make.top.bottom.equalTo(mainTempLabel)
        }
    }
    func constraintMainTemp_RC(safeArea: UILayoutGuide) {
        mainTempLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.bottom.equalTo(safeArea).inset(20)
            make.centerX.equalTo(locationLabel.snp.centerX)
        }
        tempDegree.snp.contentHuggingHorizontalPriority = 260
        tempDegree.snp.makeConstraints { make in
            make.leading.equalTo(mainTempLabel.snp.trailing)
            make.top.bottom.equalTo(mainTempLabel)
        }
    }
    // MARK: влажность
    func constraintHumidityLabel_Any() {
        humidityLabel.snp.makeConstraints {make in
            make.top.equalTo(mainTempLabel.snp.bottom).offset(5)
            make.leading.equalTo(iconImage)
            make.height.lessThanOrEqualTo(80)
        }
        // влажность: параметр и значение
        humidityLabel.setConstraints()
    }
    func constraintHumidityLabel_RC(safeArea: UILayoutGuide) {
        humidityLabel.snp.makeConstraints {make in
            make.top.equalTo(iconImage.snp.bottom).offset(5)
            make.bottom.equalTo(safeArea).inset(20)
            make.leading.equalTo(weatherDescribLabel)
            make.height.lessThanOrEqualTo(80)
        }
        // влажность: параметр и значение
        humidityLabel.setConstraints()
    }
    // MARK: скорость ветра
    func constraintWindLabel_Any() {
        windSpeedLabel.snp.makeConstraints {make in
            make.top.bottom.equalTo(humidityLabel)
            make.leading.greaterThanOrEqualTo(humidityLabel.snp.trailing).offset(20)
            make.trailing.equalTo(iconImage)
            make.width.equalTo(humidityLabel)
        }
        // скорость ветра: параметр и значение
        windSpeedLabel.setConstraints()
    }
    func constraintWindLabel_RC() {
        windSpeedLabel.snp.makeConstraints {make in
            make.top.bottom.equalTo(humidityLabel)
            make.leading.greaterThanOrEqualTo(humidityLabel.snp.trailing).offset(20)
            make.trailing.equalTo(weatherDescribLabel)
            make.width.equalTo(humidityLabel)
        }
        // скорость ветра: параметр и значение
        windSpeedLabel.setConstraints()
    }
    
    // MARK: таблица с прогнозом
    // настройка констрейнтов ячейки запускается в tableView (extension)
    func constraintCurrentTable_Any() {
        currentTableView.snp.makeConstraints {make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(15)
            make.centerX.equalTo(iconImage)
            make.width.equalTo(iconImage).multipliedBy(0.7)
            make.height.lessThanOrEqualTo(200)
            make.height.greaterThanOrEqualTo(120)
        }
    }
    func constraintCurrentTable_RR() {
        currentTableView.snp.makeConstraints {make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(15)
            make.centerX.equalTo(iconImage)
            make.width.equalTo(iconImage).multipliedBy(0.7)
            make.height.equalTo(200)
        }
    }
    func constraintCurrentTable_RC(safeArea: UILayoutGuide) {
        currentTableView.snp.makeConstraints { make in
            make.top.equalTo(weatherDescribLabel)
            make.bottom.equalTo(iconImage)
            make.leading.equalTo(tempDegree.snp.trailing).offset(20)
            make.trailing.equalTo(safeArea).inset(20)
        }
    }
    
    // MARK: кнопка на переход к экрану с прогнозом на неделю
    func constraintForecastButton_Any(safeArea: UILayoutGuide) {
        toForecastButton.snp.makeConstraints {make in
            make.top.equalTo(currentTableView.snp.bottom).offset(10)
            make.bottom.equalTo(safeArea).inset(5)
            make.leading.trailing.equalTo(iconImage)
            make.height.equalTo(50)
        }
    }
    func constraintForecastButton_RC(safeArea: UILayoutGuide) {
        toForecastButton.snp.makeConstraints {make in
            make.top.equalTo(currentTableView.snp.bottom).offset(20)
            make.bottom.equalTo(safeArea).inset(20)
            make.leading.trailing.equalTo(currentTableView)
            make.height.equalTo(50)
        }
    }
    
    
    
    // MARK: старая функция настройки констрейнтов
    func makeConstraints() {
        // отключение AutoresizingMask
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Safe area guide
        let safeArea = self.view.safeAreaLayoutGuide
        
        // для размеров экрана regular x regular (Ipad)
        let widthSizeClasse = self.view.traitCollection.horizontalSizeClass
        let heightSizeClasses = self.view.traitCollection.verticalSizeClass
        // проверка на size classes (используется в if ниже)
        let isRegularRegularSizeClass = (widthSizeClasse == .regular && heightSizeClasses == .regular)
        
        // строка поиска
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(10)
            make.leading.trailing.equalTo(safeArea)
            make.height.equalTo(50)
        }
        
        // MARK: место
        locationLabel.snp.contentHuggingVerticalPriority = 250 // чтобы лейбл с городом мог увеличиваться вертикально
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeArea).inset(20)
        }
        
        // MARK: описание погоды
        weatherDescribLabel.snp.contentHuggingVerticalPriority = 251 // чтобы лейбл с городом мог увеличиваться
        weatherDescribLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(locationLabel)
        }
        
        // MARK: иконка погоды
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(weatherDescribLabel.snp.bottom).offset(15)
            make.leading.greaterThanOrEqualTo(locationLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(locationLabel.snp.trailing)
            make.centerX.equalTo(weatherDescribLabel.snp.centerX) // нужна, так как ширины иногда будет меньше, чем leading и trailing
            make.width.lessThanOrEqualTo(500)
            // исключение для Ipad (sizeClasses == Regular Regular)
            // если не айпад то высота иконки погоды = 20% экрана
            if !isRegularRegularSizeClass {
                make.height.equalTo(self.view.snp.height).multipliedBy(0.2)
            }
        }
        
        // MARK: главная температура
        mainTempLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom)
            make.centerX.equalTo(iconImage.snp.centerX)
        }
        
        // MARK: градус температуры
        tempDegree.snp.makeConstraints { make in
            make.leading.equalTo(mainTempLabel.snp.trailing)
            make.top.bottom.equalTo(mainTempLabel)
        }
        
        // MARK: влажность
        humidityLabel.snp.makeConstraints {make in
            make.top.equalTo(mainTempLabel.snp.bottom).offset(5)
            make.leading.equalTo(iconImage)
            make.height.lessThanOrEqualTo(80)
        }
        // MARK: влажность: параметр и значение
        humidityLabel.setConstraints()
        
        // MARK: скорость ветра
        windSpeedLabel.snp.makeConstraints {make in
            make.centerY.equalTo(humidityLabel)
            make.leading.greaterThanOrEqualTo(humidityLabel.snp.trailing).offset(20)
            make.trailing.equalTo(iconImage)
            make.size.equalTo(humidityLabel)
        }
        // MARK: скорость ветра: параметр и значение
        windSpeedLabel.setConstraints()
        
        // MARK: таблица с прогнозом
        // настройка констрейнтов ячейки запускается в tableView (extension)
        currentTableView.snp.makeConstraints {make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(15)
            make.centerX.equalTo(iconImage) // ?
            make.width.equalTo(iconImage).multipliedBy(0.7)
            // Если айпад, то другие констрейнты
            if isRegularRegularSizeClass {
                make.height.equalTo(200)
            } else {
                make.height.lessThanOrEqualTo(200)
                make.height.greaterThanOrEqualTo(120)
            }
        }
        
        // MARK: кнопка на экран с прогнозом
        toForecastButton.snp.makeConstraints {make in
            make.top.equalTo(currentTableView.snp.bottom).offset(10)
            make.bottom.equalTo(safeArea).inset(5)
            make.leading.trailing.equalTo(iconImage)
            make.height.equalTo(50)
        }
    }
}
