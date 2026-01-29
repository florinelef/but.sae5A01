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
<fmt:message key="label.create_account" var="labelCreateAccount"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.create_account"/></title>
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
                                    <li><a class="dropdown-item" href="signin?lang=fr"><fmt:message key="label.french"/></a></li>
                                    <li><a class="dropdown-item" href="signin?lang=en"><fmt:message key="label.english"/></a></li>
                                    <li><a class="dropdown-item" href="signin?lang=es"><fmt:message key="label.spanish"/></a></li>
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
            
            <h1 class="mx-auto fw-bold mt-5"><fmt:message key="label.create_account"/></h1>
            <div class="mx-auto mt-1">

                <form:form id="loginForm" action="/check_signin" method="post">
                    <input type="hidden" name="action" value="signin"/>
                    
                    <div class="container-fluid p-0">
                        
                        <div class="row g-2 mb-2">
                            
                            <div class="col-md-6">
                                <label for="loginInput" class="form-label mb-0"><fmt:message key="label.username"/></label>
                                <input class="form-control form-control-sm" name="login" id="loginInput" pattern="[a-zA-Z0-9_.]{3,24}" type="text" placeholder="pmathieu" maxlength="24" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="emailInput" class="form-label mb-0"><fmt:message key="label.email"/></label>
                                <input class="form-control form-control-sm" name="email" id="emailInput" type="email" placeholder="truc@machin.com" required>
                            </div>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-md-6">
                                <label for="nomInput" class="form-label mb-0"><fmt:message key="label.lastname"/></label>
                                <input class="form-control form-control-sm" name="lastname" id="nomInput" type="text" placeholder="Doe" maxlength="24" required>
                            </div>
                            <div class="col-md-6">
                                <label for="prenomInput" class="form-label mb-0"><fmt:message key="label.firstname"/></label>
                                <input class="form-control form-control-sm" name="firstname" id="prenomInput" type="text" placeholder="John" maxlength="24" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="passwordInput" class="form-label mb-0"><fmt:message key="label.password"/></label>
                            <input class="form-control form-control-sm" name="password" id="passwordInput" type="password" placeholder="••••••••••" required>
                            <input type="hidden" name="ownership" value="false">
                        </div>
                        
                        <c:if test="${message != null}">
                            <p class="text-center text-danger">${message}</p>
                        </c:if>

                    </div>
                    
                    <div class="mt-3 d-flex flex-column justify-content-center">
                        <input class="btn btn-primary flex-fill" type="submit" value="${labelCreateAccount}">
                        <a class="btn btn-link mt-2" href="/login?lang=${lang}"><fmt:message key="label.has_account"/></a>
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