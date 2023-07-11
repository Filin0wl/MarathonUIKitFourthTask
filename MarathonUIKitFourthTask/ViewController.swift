//
//  ViewController.swift
//  MarathonUIKitFourthTask
//
//  Created by Anastasiia Perminova on 11.07.2023.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()

    private lazy var data = Array(0...10).map{Item(isChecked: false, number: $0)}

    private lazy var dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        let item = self.data[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "\(item.number)"
        cell.contentConfiguration = configuration
        cell.accessoryType = item.isChecked ? .checkmark : .none

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = .init(
            title: "Shuffle",
            primaryAction: .init(
                handler: { _ in
                    self.shuffle()
                }
            )
        )
        view.addSubview(tableView)
        tableView.frame = CGRect(origin: .zero, size: view.frame.size)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")

        updateDataSource(animated: false)
    }


    private func shuffle() {
        data.shuffle()

        updateDataSource(animated: true)
    }

    private func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.single])
        snapshot.appendItems(data.map(\.number))
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedItem = data[indexPath.row]
        data[indexPath.row].isChecked.toggle()
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([selectedItem.number])
        dataSource.apply(snapshot, animatingDifferences: true)

        if selectedItem.isChecked == false {
            let deletedItem = data.remove(at: indexPath.row)
            data.insert(deletedItem, at: 0)
            updateDataSource(animated: true)
        }
    }

}

extension ViewController {
    enum Section {
        case single
    }

    struct Item {
        var isChecked: Bool
        let number: Int
    }
}
