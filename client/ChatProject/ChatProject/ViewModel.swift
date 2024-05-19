//
//  ViewModel.swift
//  ChatProject
//
//  Created by 이정민 on 5/18/24.
//

import Foundation

class ViewModel: NSObject {
    var reloadDelegate: (() -> ())?
    private var isOpen = false
    
    private var webSocketTask: URLSessionWebSocketTask? {
       didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
     }
    
    let data: Array<(String, String, String)> = [
        ("이름", "시간", "내용"),
        ("이름", "시간", "내용"),
        ("이름", "시간", "내용"),
        ("이름", "시간", "내용"),
    ]
    
    override init() {
        let webSocket = WebSocket.shared
        webSocket.url = URL(string: "ws://localhost:8080/api/")
        try? webSocket.openWebsocket()
        webSocket.onReceiveClosure = { (string, data) in
            print(string, data)
        }
        
        webSocket.send(message: "hello world")
    }
    
    func sendMessage(_ message: String?) {
        let webSocket = WebSocket.shared
        webSocket.send(message: message ?? "")
    }
}
