package com.morales.pos.application.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
@Slf4j
public class SseService {

    private final CopyOnWriteArrayList<SseEmitter> emitters = new CopyOnWriteArrayList<>();
    private final Map<SseEmitter, String> emitterRoles = new ConcurrentHashMap<>();

    public SseEmitter subscribe(String role) {
        SseEmitter emitter = new SseEmitter(0L); // no timeout
        emitters.add(emitter);
        emitterRoles.put(emitter, role);

        emitter.onCompletion(() -> removeEmitter(emitter));
        emitter.onTimeout(() -> removeEmitter(emitter));
        emitter.onError(e -> removeEmitter(emitter));

        // Send initial connection event
        try {
            emitter.send(SseEmitter.event()
                    .name("connected")
                    .data("{\"status\":\"connected\"}"));
        } catch (IOException e) {
            removeEmitter(emitter);
        }

        log.debug("SSE client connected, role: {}, total: {}", role, emitters.size());
        return emitter;
    }

    public void broadcast(String eventName, Object data) {
        for (SseEmitter emitter : emitters) {
            try {
                emitter.send(SseEmitter.event()
                        .name(eventName)
                        .data(data));
            } catch (IOException e) {
                removeEmitter(emitter);
            }
        }
    }

    public void broadcastToRoles(String eventName, Object data, String... roles) {
        for (SseEmitter emitter : emitters) {
            String emitterRole = emitterRoles.get(emitter);
            if (emitterRole == null) continue;

            boolean match = false;
            for (String role : roles) {
                if (role.equals(emitterRole) || "ADMIN".equals(emitterRole)) {
                    match = true;
                    break;
                }
            }

            if (match) {
                try {
                    emitter.send(SseEmitter.event()
                            .name(eventName)
                            .data(data));
                } catch (IOException e) {
                    removeEmitter(emitter);
                }
            }
        }
    }

    private void removeEmitter(SseEmitter emitter) {
        emitters.remove(emitter);
        emitterRoles.remove(emitter);
        log.debug("SSE client disconnected, remaining: {}", emitters.size());
    }
}
