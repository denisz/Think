//
//  RRAddTagView.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class RRAddTagView: UIView, UITextViewDelegate {

    lazy var title: UILabel = {
        let title = UILabel(frame: CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width - 20, 20))
        title.font = UIFont(name: "OpenSans", size: 17)
        title.textAlignment = NSTextAlignment.Center
        return title
    }()

    lazy var textEdit: UITextView = {
        let textEdit = UITextView(frame: CGRectMake(10, 30, UIScreen.mainScreen().bounds.size.width - 20, 30))
        textEdit.font = UIFont(name: "OpenSans", size: 16)
        textEdit.delegate = self
        return textEdit
    }()
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if strlen(textView.text) + strlen(text) > 44 {
            return false
        }
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.text = "Create a new tag.".localized
        self.addSubview(title)
        self.addSubview(textEdit)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
