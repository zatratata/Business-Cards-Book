//
//  RatingView.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class RatingView: UIView {

    // MARK: - Properties
    private var maxRating: Int = 5
    private var filledStarImage: UIImage? = UIImage(systemName: "star.fill")
    private var emptyStarImage: UIImage? = UIImage(systemName: "star")
    private var spacing: Int = 5

    private var ratingButtons = [UIButton]()
    private var buttonSize: Int {
        return Int(self.frame.height)
    }
    private var width: Int {
        return (buttonSize + spacing) * maxRating
    }

    var rating: Int = 0 {
        didSet {
            if rating < 0 {
                rating = 0
            }
            if rating > maxRating {
                rating = maxRating
            }
            self.setNeedsLayout()
        }
    }

    // MARK: - Initialization

    func initRate() {

        if ratingButtons.count == 0 {
            for _ in 0..<maxRating {
                let button = UIButton()

                button.setImage(emptyStarImage, for: UIControl.State())
                button.setImage(filledStarImage, for: .selected)
                button.setImage(filledStarImage, for: [.highlighted, .selected])
                button.isUserInteractionEnabled = false

                button.adjustsImageWhenHighlighted = false
                ratingButtons += [button]
                addSubview(button)
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        self.initRate()

        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)

        for (index, button) in ratingButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: buttonSize)
    }

    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }

    // MARK: - Gesture recognizer

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches, withEvent: event)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches, withEvent: event)
    }

    func handleStarTouches(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)

            if position.x > -50 && position.x < CGFloat(width + 50) {
                ratingButtonSelected(position)
            }
        }
    }

    func  ratingButtonSelected(_ position: CGPoint) {
        for (index, button) in ratingButtons.enumerated() {
            if position.x > button.frame.minX {
                self.rating = index + 1
            } else if position.x < 0 {
                self.rating = 0
            }
        }
    }
}
