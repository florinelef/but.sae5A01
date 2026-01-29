<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.Month"%>
<%@ page import="java.time.format.TextStyle"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.time.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${(empty lang) ? 'fr': lang}"/>

<fmt:setBundle basename="messages"/>
<fmt:message key="label.connection" var="labelConnection"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.connection"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="icon" type="image/png" href="${appFavicon}">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <header>
            <!-- NAVBAR -->
            <nav class="navbar navbar-expand bg-light">
                <div class="container-fluid">
                    <div class="collapse navbar-collapse" id="navbarContent">

                        <ul class="navbar-nav ms-auto">

                            <li class="me-3"> 
                                <div class="dropdown">
                                <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <fmt:message key="label.language"/>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="login?lang=fr"><fmt:message key="label.french"/></a></li>
                                    <li><a class="dropdown-item" href="login?lang=en"><fmt:message key="label.english"/></a></li>
                                    <li><a class="dropdown-item" href="login?lang=es"><fmt:message key="label.spanish"/></a></li>
                                </ul>
                                </div>
                            </li>

                        </ul>
                    </div>
                </div>
            </nav>
        </header>
        <div class="container d-flex justify-content-center flex-column">
            <img class="mx-auto mt-5" id="logo" src="${appLogo}" width="350px">


            <h1 class="mx-auto fw-bold mt-5"><fmt:message key="label.login"/></h1>
            <div class="mx-auto mt-1">
                <form:form id="loginForm" action="/check_login" method="post">
                    <input type="hidden" name="action" value="login">
                    <c:if test="${_csrf != null}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>
                    <div>
                        <div class="mt-2 mb-3">
                            <p class="mb-1"><fmt:message key="label.username"/></p>
                            <input class="form-control" name="login" type="text" required>
                        </div>
                        <div class="mb-3">
                            <p class="mb-1"><fmt:message key="label.password"/></p>
                            <input class="form-control" name="password" type="password" required>
                        </div>
                        <div class="d-flex flex-row">
                            <input type="checkbox" name="remember-me">
                            <p class="mb-1 ms-2"><fmt:message key="label.rememberme"/></p>
                        </div>
                        <c:if test="${message != null}">
                            <p class="text-center text-primary">${message}</p>
                        </c:if>
                    </div>
                    <div class="mt-5 d-flex flex-column justify-content-center">
                        <input class="btn btn-primary flex-fill" type="submit" value="${labelConnection}">
                        <a class="btn btn-link mt-2" href="/signin?lang=${lang}"><fmt:message key="label.no_account"/></a>
                    </div>
                </form:form>
            </div>
        </div>
        <footer class="fixed-bottom">
            <div class="d-flex justify-content-between border-top p-3">
                <span>${appTitle} &copy;</span>
                <span>Florine Lefebvre & Charlie Darques</span>
            </div>
        </footer>
    </body>
</html>
