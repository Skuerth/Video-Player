//
//  ViewController.swift
//  Video Player
//
//  Created by Skuerth on 2019/1/16.
//  Copyright © 2019 Skuerth. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var avPlayerViewController: AVPlayerViewController?
    var avPlayer = AVPlayer()
    var inputURLBar: UITextField!
    var playButton: UIButton!
    var pauseButton: UIButton!
    let bottomBoxHeight: CGFloat = 44
    var isPlaying = false
    var topMargin: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        inputURLBar = UITextField()
        inputURLBar.placeholder = "Enter text here"
        inputURLBar.font = UIFont.systemFont(ofSize: 15)
        inputURLBar.borderStyle = UITextField.BorderStyle.roundedRect
        inputURLBar.autocorrectionType = UITextAutocorrectionType.no
        inputURLBar.keyboardType = UIKeyboardType.default
        inputURLBar.returnKeyType = UIReturnKeyType.done
        inputURLBar.clearButtonMode = UITextField.ViewMode.whileEditing
        inputURLBar.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        inputURLBar.delegate = self
        view.addSubview(inputURLBar)

        self.setNeedsStatusBarAppearanceUpdate()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return UIStatusBarStyle.lightContent
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        setupInpubarConstraints()
    }

    func setupInpubarConstraints() {

        inputURLBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            inputURLBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin + 7),
            inputURLBar.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            inputURLBar.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20),
            inputURLBar.heightAnchor.constraint(equalToConstant: 30)
            ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first{
            view.endEditing(true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        topMargin = view.layoutMargins.top

        inputURLBar.translatesAutoresizingMaskIntoConstraints = false
        setupInpubarConstraints()

        print("topMargin", topMargin)

        avPlayerViewController = AVPlayerViewController()
        avPlayerViewController?.view.frame = CGRect(x: 0, y: topMargin + 50, width: view.frame.width, height: view.frame.height - topMargin - bottomBoxHeight - 50)

        setupButton()

        guard let avPlayerViewController = avPlayerViewController else { return}

        avPlayerViewController.view.alpha = 0.0

        view.addSubview(avPlayerViewController.view)

    }

    func setupButton() {

        let bottomBox = UIView()
        bottomBox.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).cgColor

        playButton = UIButton()
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 16)

        playButton.titleLabel?.numberOfLines = 1
        playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        playButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

        pauseButton = UIButton()
        pauseButton.addTarget(self, action: #selector(didPressPauseButton), for: .touchUpInside)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.titleLabel?.font = .systemFont(ofSize: 16)

        pauseButton.titleLabel?.numberOfLines = 1
        pauseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pauseButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

        view.addSubview(bottomBox)
        bottomBox.addSubview(playButton)
        bottomBox.addSubview(pauseButton)

        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            bottomBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomBox.heightAnchor.constraint(equalToConstant: bottomBoxHeight),

            playButton.centerYAnchor.constraint(equalTo: bottomBox.centerYAnchor, constant: 0),
            playButton.leadingAnchor.constraint(equalTo: bottomBox.leadingAnchor, constant: 20),

            pauseButton.centerYAnchor.constraint(equalTo: bottomBox.centerYAnchor, constant: 0),
            pauseButton.trailingAnchor.constraint(equalTo: bottomBox.trailingAnchor, constant: -16),
        ])
    }

    @objc func didPressPlayButton(_ sender: UIButton) {

        avPlayer.play()

    }

    @objc func didPressPauseButton(_ sender: UIButton) {

        avPlayer.pause()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "rate" {

            guard let frame = avPlayerViewController?.view.frame else { return }

            if avPlayer.rate > 0 {

                if isPlaying == false {
                    UIView.animate(withDuration: 0.5) {

                        let xPosition = frame.origin.x
                        let yPosition = frame.origin.y - 80
                        let height = frame.size.height + 80
                        let width = frame.size.width

                        self.avPlayerViewController?.view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                        self.avPlayerViewController?.view.alpha = 1.0
                        self.isPlaying = true
                    }
                }

            } else if avPlayer.rate == 0.0 {

                if isPlaying == true {

                    UIView.animate(withDuration: 0.5) {

                        let xPosition = frame.origin.x
                        let yPosition = frame.origin.y + 80
                        let height = frame.size.height - 80
                        let width = frame.size.width

                        self.avPlayerViewController?.view.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

                        self.avPlayerViewController?.view.alpha = 0.0
                        self.isPlaying = false
                    }
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let inputText = textField.text else { return false }

        guard let url = URL(string: inputText) else { return false }

        avPlayer = AVPlayer(url: url)

        avPlayerViewController?.player = avPlayer

        avPlayer.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)

        avPlayer.play()

        inputURLBar.resignFirstResponder()

        textField.text = ""

        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        inputURLBar.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        inputURLBar.isFirstResponder
    }
}

extension AVPlayerViewController {

    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
