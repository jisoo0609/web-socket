package com.example.chat.model;

import lombok.Data;

@Data
public class ChatMessage {
    private MessageType type;
    private String username;
    private String message;

    public ChatMessage() {

    }

    public ChatMessage(MessageType type, String username, String message) {
        this.type = type;
        this.username = username;
        this.message = message;
    }
}


