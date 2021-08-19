//
//  ForecastWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

import UIKit
import MBProgressHUD
import SnapKit

protocol ForecastWeatherViewControllerProtocol: AnyObject {
    func updateWeather(weatherArray: [LongForecastWeatherStruct])
    func showSpinner()
    func hideSpinner()
}

final class ForecastWeatherViewController: UIViewController, ForecastWeatherViewControllerProtocol {
    // MARK: Связи
    // Интерфейс презентера
    var presenter: ForecastWeatherPresenterProtocol?
    
    // Инициализация спиннера
    private let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    // Прогнозные данные
    var forecastData: [LongForecastWeatherStruct] = []
    
    // MARK: Аутлеты
    // Location Outlet
    @IBOutlet private weak var locationLabel: UILabel!
    // CollectionView
    @IBOutlet private weak var forecastCollectionView: UICollectionView!
    // CollectionView Scroll Indicator
    @IBOutlet weak var indicatorScroll: IndicatorScroll!
    // TableView
    @IBOutlet private weak var forecastTableView: UITableView!
    // Кнопка назад
    @IBOutlet weak var backButton: GrayButton!
    @IBAction func moveBack(_ sender: UIButton) {
        presenter?.moveToCurrentView()
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        presenter?.viewDidLoad()
    }
    
    // MARK: Функции обновления данных
    // Центральная функция обновления
    func updateWeather(weatherArray: [LongForecastWeatherStruct]) {
        forecastData = weatherArray
        delegateTableView()
        delegateCollectionView()
        updateLocationLabel()
        // Indicator Scroll количество точек
        indicatorScroll.numberOfPages = weatherArray.count
        
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
        imageView.contentMode =  .center
        imageView.clipsToBounds = false
        imageView.image = backgroundImage
        imageView.alpha = 0.9
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // MARK: Функции Спиннера
    // Показать Спиннер
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
    
    // Спрятать Спиннер
    func hideSpinner() {
        spinner.hide(animated: true)
        spinner.removeFromSuperview()
        print("spinner спрятан")
    }
}

// MARK: extensions
// extension для TableView
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
        cell.setConstrints()
        cell.cellSetup(rowData: rowData)
        return cell
    }
}

// extension для CollectionView
extension ForecastWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Количетсво ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastData.count
    }
    // Сборка ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseIdentifier, for: indexPath) as! ForecastCollectionViewCell
        guard let itemData = forecastData[safe: indexPath.item] else {
            print("Проблема в данных при построении ячейки сollection в ForecastWeatherViewController")
            return cell
        }
        cell.setConstraints()
        cell.cellSetup(itemData: itemData)
        return cell
    }
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
    }
    // Отступы между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    // Отступы от краев
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// extension для CollectionView (как ScrollView) + IndicatorScroll
extension ForecastWeatherViewController: UIScrollViewDelegate {
    // Номер ячейки, который будет показан на indicatorScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == forecastCollectionView {
            guard let indexCell = forecastCollectionView.indexPathsForVisibleItems.first?.item else {
                print("Error at detecting cell index for IndicatorScroll")
                return }
            indicatorScroll.currentPage = indexCell
        }
    }
}

extension ForecastWeatherViewController {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("did rotate (ForecastScreen)")
        // Удаление установленных констрейнтов
        locationLabel.snp.removeConstraints()
        forecastCollectionView.snp.removeConstraints()
        indicatorScroll.snp.removeConstraints()
        forecastTableView.snp.removeConstraints()
        // Повторная установка констрейнтов
        setConstraints()
    }
    
    // Энум с состояниями экрана
    enum SizeClass {
        case any
        case regularRegular // Айпад
        case regularCompact // LandScape
        case compactCompact
        // дабавить, если надо
    }
    func setConstraints() {
        // отключение AutoresizingMask
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Safe area guide
        let safeArea = self.view.safeAreaLayoutGuide
        
        // определение горизонтального класса экрана
        let widthSizeClasse = self.view.traitCollection.horizontalSizeClass
//        print("widthSizeClasse: \(widthSizeClasse.rawValue)") // Test
        // определение вертикального класса экрана
        let heightSizeClasses = self.view.traitCollection.verticalSizeClass
//        print("heightSizeClasses: \(heightSizeClasses.rawValue)") // Test
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
        print("sizeClass: \(sizeClass)") // Test
        
        // Установка констрейнтов
        constraintLocationLabel(for: sizeClass, safeArea: safeArea)
        constraintCollectionView(for: sizeClass, safeArea: safeArea)
        constraintIndicatorScroll(for: sizeClass, safeArea: safeArea)
        constraintTableView(for: sizeClass, safeArea: safeArea)
        constraintBackButton(for: sizeClass, safeArea: safeArea)
    }
    // Локация
    func constraintLocationLabel(for sizeClass: SizeClass, safeArea: UILayoutGuide) {
        switch sizeClass {
        case .compactCompact:
            fallthrough
        case .regularCompact:
            locationLabel.snp.makeConstraints { make in
                make.top.equalTo(safeArea).inset(20)
                make.leading.trailing.equalTo(safeArea).inset(20)
            }
        case .regularRegular:
            locationLabel.snp.makeConstraints{ make in
                make.top.equalTo(safeArea).inset(40)
                make.leading.trailing.equalTo(safeArea).inset(80)
            }
        default: // any
            locationLabel.snp.makeConstraints { make in
                make.top.equalTo(safeArea).inset(20)
                make.leading.trailing.equalToSuperview().inset(10)
            }
        }
    }
    // CollectionView
    func constraintCollectionView(for sizeClass: SizeClass, safeArea: UILayoutGuide) {
        switch sizeClass {
        case .compactCompact:
            fallthrough
        case .regularCompact:
            forecastCollectionView.clipsToBounds = true
            forecastCollectionView.snp.makeConstraints { make in
                make.top.equalTo(locationLabel.snp.bottom).offset(10)
                make.leading.equalTo(locationLabel)
            }
        case .regularRegular:
            fallthrough
        default: // any
            forecastCollectionView.clipsToBounds = false
            forecastCollectionView.snp.makeConstraints { make in
                make.top.equalTo(locationLabel.snp.bottom).offset(20)
                make.leading.trailing.equalTo(locationLabel)
                make.height.equalTo(forecastTableView).multipliedBy(0.65)
            }
        }
        
    }
    
    // CollectionView Scroll Indicator
    func constraintIndicatorScroll(for sizeClass: SizeClass, safeArea: UILayoutGuide) {
        switch sizeClass {
        case .compactCompact:
            fallthrough
        case .regularCompact:
            indicatorScroll.snp.makeConstraints { make in
                make.top.equalTo(forecastCollectionView.snp.bottom)
                make.leading.trailing.equalTo(forecastCollectionView)
                make.bottom.equalTo(safeArea).inset(40)
            }
        case .regularRegular:
            fallthrough
        default: // any
            indicatorScroll.snp.makeConstraints { make in
                make.top.equalTo(forecastCollectionView.snp.bottom)
                make.leading.trailing.equalTo(locationLabel)
            }
        }
    }
    
    // TableView
    func constraintTableView(for sizeClass: SizeClass, safeArea: UILayoutGuide) {
        switch sizeClass {
        case .compactCompact:
            fallthrough
        case .regularCompact:
            forecastTableView.snp.makeConstraints { make in
                make.top.equalTo(forecastCollectionView)
                make.bottom.equalTo(forecastCollectionView)
                make.leading.equalTo(forecastCollectionView.snp.trailing).offset(20)
                make.trailing.equalTo(locationLabel)
                make.width.equalTo(forecastCollectionView)
            }
        case .regularRegular:
            fallthrough
        default: // any
            forecastTableView.snp.makeConstraints { make in
                make.top.equalTo(indicatorScroll.snp.bottom).offset(30)
                make.bottom.equalTo(safeArea).inset(30)
                make.leading.trailing.equalTo(locationLabel)
            }
        }
    }
    
    // Кнопка назад
    func constraintBackButton(for sizeClass: SizeClass, safeArea: UILayoutGuide) {
        switch sizeClass {
        case .compactCompact:
            fallthrough
        case .regularCompact:
            backButton.snp.makeConstraints { make in
                make.top.equalTo(forecastTableView.snp.bottom).offset(10)
                make.bottom.equalTo(safeArea).inset(10)
                make.leading.trailing.equalTo(forecastTableView).inset(20)
            }
        case .regularRegular:
            break
        default: // any
            break
        }
    }
}
