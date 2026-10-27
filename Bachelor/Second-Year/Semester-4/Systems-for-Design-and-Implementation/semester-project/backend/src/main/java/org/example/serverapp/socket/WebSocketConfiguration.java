package org.example.serverapp.socket;

import org.example.serverapp.service.GenerateFakeDataService;
import org.example.serverapp.service.UserService;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocket
public class WebSocketConfiguration implements WebSocketConfigurer {

    private final GenerateFakeDataService generateFakeDataService;

    public WebSocketConfiguration(GenerateFakeDataService generateFakeDataService) {
        this.generateFakeDataService = generateFakeDataService;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new WebSocketBroadcaster(generateFakeDataService), "/websocket-broadcaster")
                .setAllowedOrigins("*");
    }
}
