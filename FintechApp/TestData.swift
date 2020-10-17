//
//  TestData.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 25.09.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

let conversationsTestData = [
    [
        ConversationCellModel(name: "John", message: "Hello, my friend!", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Alex", message: "", date: Date().addingTimeInterval(-12000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Max", message: "Why?", date: Date().addingTimeInterval(-86400), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Sally", message: "Well done", date: Date().addingTimeInterval(-89000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Nick",
                              message: "Qwerty? BlahBlahBlahBlahBlahBlahBlahBlahBlah",
                              date: Date().addingTimeInterval(-189000),
                              isOnline: true,
                              hasUnreadMessages: false),
        ConversationCellModel(name: "Joe", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Michelle", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Sara", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Jane", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "John", message: "Hello, my friend!", date: Date(), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Alex", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Max", message: "Why?", date: Date().addingTimeInterval(-86400), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Sally", message: "Well done", date: Date().addingTimeInterval(-89000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Nick", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Joe", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Michelle", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Sara", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Jane", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: true, hasUnreadMessages: false)],
    [
        ConversationCellModel(name: "John", message: "Hello, my friend!", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Alex", message: "HI!", date: Date().addingTimeInterval(-12000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Max", message: "Why?", date: Date().addingTimeInterval(-86400), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Sally", message: "Well done", date: Date().addingTimeInterval(-89000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Nick",
                              message: "Qwerty? BlahBlahBlahBlahBlahBlahBlahBlahBlah",
                              date: Date().addingTimeInterval(-189000),
                              isOnline: false,
                              hasUnreadMessages: false),
        ConversationCellModel(name: "Joe", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Michelle", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Sara", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Jane", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "John", message: "Hello, my friend!", date: Date(), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Alex", message: "OI)", date: Date(), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Max", message: "Why?", date: Date().addingTimeInterval(-86400), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Sally", message: "Well done", date: Date().addingTimeInterval(-89000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Nick", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Joe", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Michelle", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Sara", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Jane", message: "Qwerty?", date: Date().addingTimeInterval(-189000), isOnline: false, hasUnreadMessages: false)]
]

let messagesTestData = [
    MessageCellModel(text: "Lorem ipsum dolor sit amet, consectetur"),
    MessageCellModel(text: "qwerty"),
    MessageCellModel(text:
                        """
                        asvolutpat iaculis erat at pretium. Cras id
                        dolor eros. Vivamus rutrum mollis est, ut sollicitudin nibh porttitor ac. Praesent metus eros, pellentesque df
                        """),
    MessageCellModel(text: "ec diam maximus erat pharetra tempus. Viv"),
    MessageCellModel(text: "ec diam maximus erat pharetra tempus. Viv"),
    MessageCellModel(text: "ec diam maximus erat pharetra tempus. Viv"),
    MessageCellModel(text: "pulvinar sit amet "),
    MessageCellModel(text: "asdf"),
    MessageCellModel(text: "Praesent bibendum velit eu felis semper, eu di"),
    MessageCellModel(text: "is et ligula a metus"),
    MessageCellModel(text: "Aenean ac tortor nisi. Etiam dapibus sem ac est tempus feugiat. Praesent pulvinar nunc"),
    MessageCellModel(text: "Aenean ac tortor nisi. Etiam dapibus sem ac est tempus feugiat. Praesent pulvinar nunc")
]
