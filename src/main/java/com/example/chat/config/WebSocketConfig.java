package com.example.chat.config;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;
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
    private final SocketIOServer socketServer;

    public WebSocketConfig(SocketIOServer socketServer, SocketIOServer socketServer1) {
        this.socketServer = socketServer1;
        // "demoEvent" 이벤트에 대한 리스너 등록
        socketServer.addEventListener("message", SocketDetail.class, demoEvent);
    }

    // demoEvent 이벤트를 처리하는 리스너
    public DataListener<SocketDetail> demoEvent = new DataListener<SocketDetail>() {
        @Override
        public void onData(SocketIOClient client, SocketDetail socketDetail, AckRequest ackRequest) {
            log.info("Demo event received: {}", socketDetail);

            // 비즈니스 로직 처리
            // TODO
            // 예시: 데이터 처리를 위한 로직 추가
            processData(socketDetail);

            // 클라이언트에게 응답 전송
            ackRequest.sendAckData("Demo event received");
        }
    };

    private void processData(SocketDetail socketDetail) {
        // 실제 데이터 처리 로직을 이곳에 추가
        log.info("Processing socket detail: {}", socketDetail);
        // TODO
        // 예를 들어, socketDetail을 데이터베이스에 저장하거나 다른 처리를 수행할 수 있습니다.
    }
}
