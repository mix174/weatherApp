//
//  ResultViewController.swift
//  weatherApp
//
//  Created by Mix174 on 12.08.2021.
//

import UIKit
import SnapKit

protocol SearchResultControllerProtocol: AnyObject {
    func mainSetup()
    func updateCities(array: [String])
}

final class SearchResultController: UIViewController, SearchResultControllerProtocol {
    // // MARK: Связи
    weak var presenter: CurrentPresenterProtocol?
    weak var searchController: UISearchController?
    
    // MARK: Хранение данных
    // resultTable
    private var resultTable: ResultTableView?
    // Подгружаемый массив данных
    private var cities: [String] = []
    // Массив отфильтрованных результатов поиска
    private var citiesFiltered: [String] = []
    
    // MARK: Основная настройка
    func mainSetup() {
        searchControllerDelegate()
        resultTableSetup()
        setCancelTap()
    }
    // функция делегирования и направления поискового запроса для searchController
    func searchControllerDelegate() {
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
    }
    
    // MARK: Настройка resultTable
    // Настройка таблички результатов поиска
    func resultTableSetup() {
        resultTable = ResultTableView()
        guard let resultTable = resultTable else { return }
        // делегирование и установкв источника данных для resultTable
        resultTable.delegate = self
        resultTable.dataSource = self
        // Настройка ячейки
        resultTable.register(UINib(nibName: ResultTableViewCell.reuseIdentifier,
                                   bundle: nil),
                             forCellReuseIdentifier: ResultTableViewCell.reuseIdentifier)
        resultTable.backgroundColor = .clear
        resultTable.tableFooterView = UIView()
        view.addSubview(resultTable)
    }
    
    // Функция обновления констрейнтов для resultTable
    // Значение Anchor = searchBarView.frame.maxY — верхняя точка для resultTable
    func setResultTableConstraints(newAnchor: CGFloat) {
        print("newAnchor: \(newAnchor)")
        resultTable?.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.top).inset(newAnchor)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.3)
        }
    }
    
    // MARK: Тач отмены
    // Тач по темной зоне -> отмена поиска
    func setCancelTap() {
        let cancelView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelTapped(_:)))
        cancelView.addGestureRecognizer(tapGesture)
        cancelView.isUserInteractionEnabled = true
        view.addSubview(cancelView)
        // констрейнты
        cancelView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.sendSubviewToBack(cancelView)
    }
    @objc func cancelTapped(_ sender: UITapGestureRecognizer) {
        searchController?.dismiss(animated: true)
    }
    
    // MARK: Триггер к показу
    // Триггер показу столбика результатов и к загрузке списка городов
    func willPresentSearchController(_ searchController: UISearchController) {
        // обновление констрейнтов таблички результатов
        if let newAnchor = presenter?.getSearchBarAnchor() {
            setResultTableConstraints(newAnchor: newAnchor)
        } else {
            // стандартное безопасное значение
            print("SearchResultController: can' bind newAnchor, 104.0 pix for upper inset setted instead")
            setResultTableConstraints(newAnchor: 104)
        }
        // проверка списка городов: если не загружен - загрузить
        guard cities.isEmpty else {
            print("searchResultController: cities are already downloaded")
            return
        }
        presenter?.getCities()
    }
    
    // MARK: Фильтр поиска и работа со списком городов
    // Фильтр результатов поиска
    func filterContentForSearchText(_ searchText: String) {
        citiesFiltered = cities.filter { (city: String) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        }
        resultTable?.reloadData()
    }
    
    // Обновление массива списка городов
    func updateCities(array: [String]) {
        cities = array
        resultTable?.reloadData()
    }
    
    // MARK: Функции выбора ячейки города и отправки запроса
    // Обработка выбора ячейки в resultTable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityChoice = citiesFiltered[indexPath.row]
        // отправка запроса
        cityWeatherRequest(city: cityChoice)
        // отмена выбора ячейки в resultTable
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        // скрытие resultTable
        searchController?.dismiss(animated: true)
        // сброс поискового запроса в searchBar
        searchController?.searchBar.text = ""
    }
    
    // Функция отправки запроса выбранного города
    func cityWeatherRequest(city: String) {
        presenter?.getWeatherFor(city: city)
    }
}

// MARK: Extensions
// extension для TableView
extension SearchResultController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        citiesFiltered.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ResultTableViewCell
        let rowDataFiltered = citiesFiltered[indexPath.row]
        cell.cellSetup(city: rowDataFiltered)
        return cell
    }
}

// extension для searchController
extension SearchResultController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        print(searchController.searchBar.text!)
    }
}
