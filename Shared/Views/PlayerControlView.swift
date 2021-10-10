//
//  PlayerControllView.swift
//  SummerPlayerView
//
//  Created by derrick on 2020/09/13.
//  Copyright © 2020 Derrick. All rights reserved.
//

import UIKit
import AVKit

class PlayerControllView: UIView {
    
    private var isPlaying: Bool = true
    
    var delegate: PlayerControlViewDelegate?
    
    lazy private var backButton = PlayerControlCommonButton(systemImageName: "arrow.left", size: CGSize(width: 70, height: 70))
    lazy private var previousButtonLeft = PlayerControlCommonButton(systemImageName: "backward.end.fill", size: CGSize(width: 70, height: 70))
    lazy private var previousButtonRight = PlayerControlCommonButton(systemImageName: "backward.end.fill", size: CGSize(width: 50, height: 50))
    lazy private var repeatButton = PlayerControlCommonButton(systemImageName: "repeat", size: CGSize(width: 70, height: 70))
    lazy private var nextButton = PlayerControlCommonButton(systemImageName: "forward.end.fill", size: CGSize(width: 70, height: 70))
    lazy private var airplayButton = PlayerControlCommonButton(systemImageName: "airplayaudio", size: CGSize(width: 30, height: 30))
    lazy private var repeatTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(backButton)
        addSubview(previousButtonLeft)
        addSubview(previousButtonRight)
        addSubview(repeatButton)
        addSubview(airplayButton)
        addSubview(nextButton)
        addSubview(repeatTimeLabel)
        backButton.addTarget(self, action: #selector(self.clickBackButton(_:)), for: .touchUpInside)
        previousButtonLeft.addTarget(self, action: #selector(self.clickPreviousButton(_:)), for: .touchUpInside)
        previousButtonRight.addTarget(self, action: #selector(self.clickPreviousButton(_:)), for: .touchUpInside)
        previousButtonRight.alpha = 0.3
        repeatButton.addTarget(self, action: #selector(self.clickRepeatButton(_:)), for: .touchUpInside)
        repeatButton.tintColor = .red
        nextButton.addTarget(self, action: #selector(self.clickNextButton(_:)), for: .touchUpInside)
        airplayButton.addTarget(self, action: #selector(self.clickAirPlayButton(_:)), for: .touchUpInside)
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // TODO: need to deal with the constraint warning
            backButton.topAnchor.constraint(equalTo: self.topAnchor , constant: 15),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 30),
            
            airplayButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            airplayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -50),
            
            previousButtonLeft.bottomAnchor.constraint(equalTo: self.bottomAnchor ,constant: 0),
            previousButtonLeft.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            previousButtonLeft.topAnchor.constraint(equalTo: repeatButton.bottomAnchor, constant: 30),
            repeatButton.leadingAnchor.constraint(equalTo: previousButtonLeft.leadingAnchor, constant: 0),
            
            repeatButton.topAnchor.constraint(equalTo: repeatTimeLabel.bottomAnchor, constant: 15),
            repeatTimeLabel.leadingAnchor.constraint(equalTo: repeatButton.leadingAnchor, constant: 0),
            
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor ,constant: 0),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: previousButtonRight.bottomAnchor, constant: 30),
            previousButtonRight.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 0),
        ])
    }
    
    @objc func clickBackButton(_ sender: UIButton) {
        delegate?.didPressedBackButton()
    }
    
    @objc func clickPreviousButton(_ sender: UIButton) {
        delegate?.didPressedPreviousButton()
    }
    
    @objc func clickRepeatButton(_ sender: UIButton) {
        if let result = delegate?.didPressedRepeatButton() {
            changeRepeatStatus(isRepeatMode: result.isRepeatMode, repeatTime: result.repeatTime)
        }
    }
    
    func changeRepeatStatus(isRepeatMode: Bool, repeatTime: CMTime?) {
        repeatButton.tintColor = isRepeatMode ? .yellow : .red
        repeatTimeLabel.text = repeatTime?.description ?? ""
    }
    
    @objc func clickAirPlayButton(_ sender: UIButton) {
        delegate?.didPressedAirPlayButton()
    }
    
    @objc func clickNextButton(_ sender: UIButton) {
        delegate?.didPressedNextButton()
    }
    
}
