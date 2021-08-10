//
//  DetailMemberViewController.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/01.
//

import UIKit

final class DetailMemberViewController: UIViewController {
    
    // MARK: - Views
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = theme.detailFont
        
        return label
    }()
    private lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.font = theme.detailFont
        
        return label
    }()
    private lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.font = theme.detailFont
        textView.delegate = self
        
        return textView
    }()
    
    // MARK: - Properties
    var dispatch: ((Action) -> Void)?
    private let theme: Theme
    
    // MARK: - Lifecycle
    init(_ theme: Theme = .default) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        build()
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Methods
    func update(with state: ViewState) {
        profileImageView.image = state.profile
        nameLabel.text = state.name
        teamLabel.text = state.team
        bioTextView.text = state.bio
    }
    
    private func build() {
        buildCustomNavigationItem()
        buildVStack()
        buildProfileButton()
    }
    
    private func buildCustomNavigationItem() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let action = UIAction(image: theme.backButtonImage)  { [weak self] _ in
            self?.dispatch?(.backButtonTapped)
        }
        let button = UIButton(primaryAction: action)
        stack.addArrangedSubview(button)
        let spacer = UIView()
        stack.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func buildVStack() {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        vStack.addArrangedSubview(profileImageView)
        let spacer = UIView()
        vStack.addArrangedSubview(spacer)
        let nameHStack = makeHStack(.name)
        vStack.addArrangedSubview(nameHStack)
        let teamHStack = makeHStack(.team)
        vStack.addArrangedSubview(teamHStack)
        let bioVStack = makeBioVStack()
        vStack.addArrangedSubview(bioVStack)
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 16),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            nameHStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, multiplier: 0.7),
            teamHStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, multiplier: 0.7),
            bioVStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, multiplier: 0.7),
            nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            teamLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
        ])
    }
    
    private func buildProfileButton() {
        let action = UIAction { [weak self] _ in
            self?.dispatch?(.profileImageTapped)
        }
        let button = UIButton(type: .custom, primaryAction: action)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            button.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
    }
    
    private func makeHStack(_ type: SubViewStackType) -> UIView {
        let stack = UIStackView()
        let label = UILabel()
        label.text = type.description
        label.font = theme.titleFont
        let spacer = UIView()
        let isNameHStack = type == .name
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(isNameHStack ? nameLabel : teamLabel)
        stack.addArrangedSubview(spacer)
        
        return stack
    }
    
    private func makeBioVStack() -> UIView {
        let vStack = UIStackView()
        vStack.spacing = 8
        vStack.axis = .vertical
        let label = UILabel()
        label.text = "bio"
        label.font = theme.titleFont
        vStack.addArrangedSubview(label)
        vStack.addArrangedSubview(bioTextView)
        
        return vStack
    }
}

// MARK: - UITextViewDelegate
extension DetailMemberViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        dispatch?(.textViewTextChanged(textView.text))
    }
}
