//
//  ViewController.swift
//  ChatProject
//
//  Created by 이정민 on 5/18/24.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel: ViewModel = ViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "입력하세요"
        
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func loadView() {
        viewModel.reloadDelegate = reloadTableView
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setUpView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        setUpTableView()
        setUpTextFieldView()
    }

    private func setUpTableView() {
        stackView.addArrangedSubview(tableView)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func setUpTextFieldView() {
        stackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(textField)
        textStackView.addArrangedSubview(sendButton)
        textStackView.spacing = 20
        
        textStackView.alignment = .leading
        
        textField.borderStyle = .roundedRect
        
        sendButton.setTitle("보내기", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchDown)
    }
    
    @objc private func sendMessage() {
        viewModel.sendMessage(textField.text)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.senderNameLabel.text = viewModel.data[indexPath.row].0
        cell.dateLabel.text = viewModel.data[indexPath.row].1
        cell.contentLabel.text = viewModel.data[indexPath.row].2
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}
