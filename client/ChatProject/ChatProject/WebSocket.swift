//
//  WebSocket.swift
//  ChatProject
//
//  Created by 이정민 on 5/18/24.
//

import Foundation

enum WebSocketError: Error {
  case invalidURL
}

final class WebSocket: NSObject {
    static let shared = WebSocket()
    
    var url: URL?
    var onReceiveClosure: ((String?, Data?) -> ())?
    weak var delegate: URLSessionWebSocketDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
      }
    private var timer: Timer?
    
    private override init() {}
    
    func openWebsocket() throws {
        guard let url = url else { throw WebSocketError.invalidURL }
        
        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        let webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        
        self.webSocketTask = webSocketTask
        self.startPing()
    }
    
    func closeWebSocket() {
        self.webSocketTask = nil
        self.onReceiveClosure = nil
        self.timer?.invalidate()
        self.delegate = nil
      }
    
    private func startPing() {
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(
        withTimeInterval: 10,
        repeats: true,
        block: { [weak self] _ in self?.ping() }
      )
    }
    
    private func ping() {
      self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
        guard let error = error else { return }
        print("Ping failed \(error)")
        self?.startPing()
      })
    }
    
    func send(message: String) {
      self.send(message: message, data: nil)
    }
    
    func send(data: Data) {
      self.send(message: nil, data: data)
    }
    
    private func send(message: String?, data: Data?) {
      let taskMessage: URLSessionWebSocketTask.Message
      if let string = message {
        taskMessage = URLSessionWebSocketTask.Message.string(string)
      } else if let data = data {
        taskMessage = URLSessionWebSocketTask.Message.data(data)
      } else {
        return
      }
      
      print("Send message \(taskMessage)")
      self.webSocketTask?.send(taskMessage, completionHandler: { error in
        guard let error = error else { return }
        print("WebSOcket sending error: \(error)")
      })
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
      ) {
        self.delegate?.urlSession?(
          session,
          webSocketTask: webSocketTask,
          didOpenWithProtocol: `protocol`
        )
      }
      
      func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
      ) {
        self.delegate?.urlSession?(
          session,
          webSocketTask: webSocketTask,
          didCloseWith: closeCode,
          reason: reason
        )
      }
}
