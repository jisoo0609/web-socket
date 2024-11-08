package com.example.chat.controller;

import com.example.chat.service.SocketIOHandler;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/chat")
@AllArgsConstructor
public class ChatController {
    private final SocketIOHandler socketModule;

    @RequestMapping("/lobby")
    public String lobby() {
        log.info("=====enter lobby=====");
        return "lobby";
    }

//    @RequestMapping("/enter")
//    public String enter(Model model) {
//        log.info("=====enter=====");
//        return "chat";
//    }

    @RequestMapping("/enter")
    public String enter(@RequestParam String username, Model model) {
        model.addAttribute("username", username);
        return "chat";
    }

}
