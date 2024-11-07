package com.example.chat.config;


import com.corundumstudio.socketio.Configuration;
import com.corundumstudio.socketio.SocketIOServer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import javax.annotation.PreDestroy;
import javax.websocket.Session;
import java.util.HashSet;
import java.util.Set;

@Component
@RequiredArgsConstructor
@Slf4j
public class SocketIoConfig {
    @Value("${socketio.server.hostname}")
    private String hostname;

    @Value("${socketio.server.port}")
    private int port;

    // create socketIO Server
    private SocketIOServer server;

    @Bean
    public SocketIOServer socketIoServer() {
        Configuration config = new Configuration();

        config.setHostname(hostname);
        config.setPort(port);

        server = new SocketIOServer(config);
        log.info("========>server start!");
        server.start();

        server.addConnectListener(client -> log.info("Client connected: {}", client.getSessionId()));
        server.addDisconnectListener(client -> log.info("Client disconnected: {}", client.getSessionId()));

        return server;
    }

    @PreDestroy
    public void stopSocketServer() {
        this.server.stop();
    }
}
