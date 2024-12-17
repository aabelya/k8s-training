package com.ms.intro.config;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

import java.util.Enumeration;
import java.util.Optional;

@Component
public class CustomRequestLoggingFilter extends CommonsRequestLoggingFilter {

    public CustomRequestLoggingFilter() {
        setBeforeMessagePrefix("");
        setIncludeClientInfo(true);
    }

    @Override
    protected String createMessage(HttpServletRequest request, String prefix, String suffix) {
        String message = super.createMessage(request, prefix, suffix);
        HttpHeaders headers = (new ServletServerHttpRequest(request)).getHeaders();
        return Optional.ofNullable(headers.get("x-workerid")).map(id -> message + ", worker_id=" + id).orElse(message);
    }

    @Override
    protected void afterRequest(HttpServletRequest request, String message) {
    }
}
