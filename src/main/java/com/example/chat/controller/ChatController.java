package com.example.chat.controller;

import com.example.chat.model.Message;
import com.example.chat.service.SocketIOHandler;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/chat")
@AllArgsConstructor
public class ChatController {
    private final SocketIOHandler socketIOHandler;

    @RequestMapping("/lobby")
    public String lobby() {
        log.info("=====enter lobby=====");
        return "lobby";
    }

    @RequestMapping("/enter")
    public String enter(@RequestParam String username, Model model) {
        model.addAttribute("username", username);
        return "chat";
    }

    @RequestMapping("/monitor")
    public String monitor(@RequestParam("username") String username, Model model) {
        log.info("username: {}", username);

        Map<String, Message> attend = socketIOHandler.getAttend();
        model.addAttribute("attend", attend);

        log.info("attend: {}", attend);

        return "monitor";
    }
}
