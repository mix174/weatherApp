//
//  ResultTableViewController.swift
//  weatherApp
//
//  Created by Mix174 on 30.07.2021.
//

import UIKit

protocol SearchViewControllerProtocol: class {
    func mainSetup(size: CGRect)
    func updateCity(array: [String])
    func showResultTable()
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    // Интерфейс презентера
    weak var presenter: CurrentWeatherPresenterProtocol?
    
    // Хранение resultTable
    var resultTable: ResultTableView?
    
    // Подгружаемый массив данных
    var cities: [String] = []
    // Массив отфильтрованных результатов поиска
    var citiesFiltered: [String] = []
    
    // Инициализация SearchController
    let searchController = UISearchController()
    
    // Параметры для фильтра поиска
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: Функции настройки отображения поисковой строки и результатов поиска
    // размеры рамки searchBar — решить вопрос, как брать эти данные
    let searchBarFrame2 = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 50)
    // Преднастройка класса
    func mainSetup(size: CGRect) {
        searchSetup()
        resultTableSetup(searchBarSize: size)
    }
    
    // Настройка строки поиска и добавление на MainVC
    func searchSetup() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Выберите город"
        searchBar.searchBarStyle = .minimal
        searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        // передача searchBar в презентер
        presenter?.setOnView(searchBar: searchBar)
    }
    
    // Настройка таблички результатов поиска
    func resultTableSetup(searchBarSize: CGRect) {
        let tableFrame = CGRect(x: searchBarSize.minX,
                                y: searchBarSize.maxY,
                                width: searchBarSize.width,
                                height: searchBarSize.height * 4)
        resultTable = ResultTableView(frame: tableFrame)
        resultTable?.register(UINib(nibName: ResultTableViewCell.reuseIdentifier, bundle: nil),
                              forCellReuseIdentifier: ResultTableViewCell.reuseIdentifier)
        resultTable?.backgroundColor = .clear
        resultTable?.delegate = self
        resultTable?.dataSource = self
    }
    
    // MARK: Функции показа и скрытия resultTable на currentView
    // Функция показа результатов
    func showResultTable() {
        guard let resultTable = resultTable else {
            print("SearchController.tableViewShow(): Guard hasn't been passed")
            return
        }
        // Передача resultTable в презентер
        presenter?.setOnView(resultTable: resultTable)
        self.resultTable?.reloadData()
    }
    
    // Функция сокрытия результатов
    func hideResultTable() {
        resultTable?.removeFromSuperview()
    }
    
    // Триггерк показу столбика результатов и к загрузке списка городов
    func willPresentSearchController(_ searchController: UISearchController) {
        guard cities.isEmpty else {
            showResultTable()
            return
        }
        presenter?.getCities()
    }

    // Триггер к сокрытию столбика результатов
    func willDismissSearchController(_ searchController: UISearchController) {
        hideResultTable()
    }
    
    // MARK: Фильтр поика и работа со списком городов
    // Фильтр результатов поиска
    func filterContentForSearchText(_ searchText: String) {
        citiesFiltered = cities.filter { (city: String) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        }
        resultTable?.reloadData()
    }
    
    // Обновление массива списка городов
    func updateCity(array: [String]) {
        cities = array
        resultTable?.reloadData()
    }
    
    // MARK: Функции выбора ячейки города и отправки запроса
    // Обработка выбора ячейки в resultTable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityChoice: String
        if isFiltering {
            cityChoice = citiesFiltered[indexPath.row]
        } else {
            cityChoice = cities[indexPath.row]
        }
        // отправка запроса
        cityWeatherRequest(city: cityChoice)
        // отмена выбора ячейки в resultTable
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        // скрытие resultTable (почему автоматически не срабатывает willDismissSearchController или didDismissSearchController при ручном searchController.dismiss?)
        searchController.dismiss(animated: true) { [weak self] in
            // self optinal bindinig
            guard let self = self else { return }
            self.hideResultTable()
        }
    }
    
    // Функция отправки запроса выбранного города
    func cityWeatherRequest(city: String) {
        presenter?.getWeatherFor(city: city)
    }
}

// MARK: Extensions
// extension для TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Выбор массива с городами
        if isFiltering {
            return citiesFiltered.count
          }
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ResultTableViewCell
        // Выбор массива с городами
        if isFiltering {
            let rowDataFiltered = citiesFiltered[indexPath.row]
            cell.cellSetup(city: rowDataFiltered)
        } else {
            let rowData = cities[indexPath.row]
            cell.cellSetup(city: rowData)
        }
        return cell
    }
}

// extension для SearchController
extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
