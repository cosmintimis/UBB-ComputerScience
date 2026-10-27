package org.example.serverapp.socket;

import org.example.serverapp.service.GenerateFakeDataService;
import org.example.serverapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;


@Component
@EnableScheduling
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
public class WebSocketBroadcaster extends TextWebSocketHandler {

    private final ConcurrentLinkedQueue<WebSocketSession> sessions = new ConcurrentLinkedQueue<>();
    private final GenerateFakeDataService generateFakeDataService;

    @Autowired
    public WebSocketBroadcaster(GenerateFakeDataService generateFakeDataService) {
        this.generateFakeDataService = generateFakeDataService;
//        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
//        executorService.scheduleAtFixedRate(this::notifySessions, 0, 15, TimeUnit.SECONDS);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        super.afterConnectionEstablished(session);
        sessions.add(session);
        System.out.println("Connection established");
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        super.afterConnectionClosed(session, status);
        sessions.remove(session);
        System.out.println("Connection removed");;
    }

//    @Scheduled(fixedRate = 500)
//    public void notifySessions() {
//
//        System.out.println(sessions.size());
//        for (WebSocketSession session : sessions) {
//            try {
//                userService.generateUsers();
//                session.sendMessage(new TextMessage("Your periodic message"));
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//    }

    public void notifySessions(){
        int n = 10;
        for (WebSocketSession session : sessions) {
            try {
                generateFakeDataService.generateUsers(n);
                session.sendMessage(new TextMessage("Your periodic message"));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}


