package com.example.chat.model;

import lombok.Data;

@Data
public class ChatMessage {
    private MessageType type;
    private String room;
    private String message;

    public ChatMessage() {

    }

    public ChatMessage(MessageType type, String room, String message) {
        this.type = type;
        this.room = room;
        this.message = message;
    }
}


