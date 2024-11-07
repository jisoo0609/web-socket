package com.example.chat.config;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import com.corundumstudio.socketio.listener.DisconnectListener;
import com.example.chat.model.ChatMessage;
import com.example.chat.model.SocketDetail;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class WebSocketConfig {
//    @Bean
//    public ServerEndpointExporter serverEndpointExporter() {
//        return new ServerEndpointExporter();
//    }

    @Getter
    private final SocketIOServer server;

    public WebSocketConfig(SocketIOServer socketServer) {
        this.server = socketServer;
        // 누군가 소켓에 연결하면 실행
        server.addConnectListener(onConnected());
        // 누군가 소켓에서 연결 끊을 때 실행
        server.addDisconnectListener(onDisconnected());
        socketServer.addEventListener("send_message", ChatMessage.class, onChatReceived());
    }

    public DataListener<ChatMessage> onChatReceived() {
        return (senderClient, data, ackSender) -> {
            log.info(data.toString());
            // 모든 클라이언트에게 데이터 broadcasting
            senderClient.getNamespace().getBroadcastOperations().sendEvent("get_Message", data.getMessage());
        };
    }

    public ConnectListener onConnected() {
        return (client) -> {
            log.info("Socket ID {} Connected to socket", client.getSessionId().toString());
        };
    }

    public DisconnectListener onDisconnected() {
        return (client) -> {
            log.info("Client {} - Disconnected from socket", client.getSessionId().toString());
        };
    }

//    // demoEvent 이벤트를 처리하는 리스너
//    public DataListener<SocketDetail> demoEvent = new DataListener<SocketDetail>() {
//        @Override
//        public void onData(SocketIOClient client, SocketDetail socketDetail, AckRequest ackRequest) {
//            log.info("Demo event received: {}", socketDetail);
//
//            // 비즈니스 로직 처리
//            // TODO
//            // 예시: 데이터 처리를 위한 로직 추가
//            processData(socketDetail);
//
//            // 클라이언트에게 응답 전송
//            ackRequest.sendAckData("Demo event received");
//        }
//    };
//
//    private void processData(SocketDetail socketDetail) {
//        // 실제 데이터 처리 로직을 이곳에 추가
//        log.info("Processing socket detail: {}", socketDetail);
//        // TODO
//        // 예를 들어, socketDetail을 데이터베이스에 저장하거나 다른 처리를 수행할 수 있습니다.
//    }
}
